part of nb_navigation_flutter;

class CaptureImageUtil {
  static Future<Uint8List?> createImageFromWidget(Widget widget, {Duration? wait, required Size imageSize}) async {
    var devicePixelRatio = ui.window.devicePixelRatio;
    final RenderRepaintBoundary repaintBoundary = RenderRepaintBoundary();
    final RenderView renderView = RenderView(
      child: RenderPositionedBox(alignment: Alignment.center, child: repaintBoundary),
      configuration: ViewConfiguration(
        size: imageSize,
        devicePixelRatio: devicePixelRatio,
      ),
      view: ui.PlatformDispatcher.instance.views.single
    );
    final PipelineOwner pipelineOwner = PipelineOwner();
    late BuildOwner buildOwner;
    try {
      buildOwner = BuildOwner(focusManager: FocusManager());
    } catch (e) {
    }

    late RenderObjectToWidgetElement<RenderBox> rootElement;
    try {
      pipelineOwner.rootNode = renderView;
      renderView.prepareInitialFrame();
      rootElement = RenderObjectToWidgetAdapter<RenderBox>(
          container: repaintBoundary,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: widget,
          )).attachToRenderTree(buildOwner);
    } catch (e) {
    }

    if (wait != null) {
      await Future.delayed(wait);
    }
    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();
    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();
    final ui.Image image = await repaintBoundary.toImage(pixelRatio: devicePixelRatio);
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List();
  }
}