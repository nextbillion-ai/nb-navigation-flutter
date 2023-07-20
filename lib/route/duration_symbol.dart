part of nb_navigation_flutter;

class DurationSymbol extends StatelessWidget {
  final String text;
  final Color primaryBackgroundColor;
  final Color alternativeBackgroundColor;
  final TextStyle primaryTextStyle;
  final TextStyle alternativeTextStyle;
  final bool isPrimary;

  const DurationSymbol({
    Key? key,
    required this.text,
    required this.isPrimary,
    this.primaryBackgroundColor = const Color(0xFF7588E9),
    this.alternativeBackgroundColor = Colors.white,
    this.primaryTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 11,
    ),
    this.alternativeTextStyle = const TextStyle(
      color: Colors.black,
      fontSize: 11,
    ),
  }) : super(key: key);

  ///chat bubble builder method
  @override
  Widget build(BuildContext context) {
    Alignment alignment = isPrimary ? Alignment.topLeft : Alignment.topRight;
    Color color = isPrimary ? primaryBackgroundColor : alternativeBackgroundColor;
    TextStyle textStyle = isPrimary ? primaryTextStyle : alternativeTextStyle;
    EdgeInsets padding = isPrimary
        ? const EdgeInsets.only(left: 20, top: 12, right: 12, bottom: 12)
        : const EdgeInsets.only(left: 12, top: 12, right: 20, bottom: 12);
    EdgeInsets containerPadding = isPrimary ? const EdgeInsets.only(left: 5) : const EdgeInsets.only(right: 5);
    return Container(
      padding: containerPadding,
      constraints: BoxConstraints(maxWidth: 100, maxHeight: 60),
      child: Align(
        alignment: alignment,
        child: CustomPaint(
          painter: BubblePainter(color: color , alignment: alignment),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: padding,
                child: Text(
                  text,
                  style: textStyle,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BubblePainter extends CustomPainter {
  final Color color;
  final Alignment alignment;

  BubblePainter({
    required this.color,
    required this.alignment,
  });

  final double _radius = 6.0;
  final double _x = 10.0;

  @override
  void paint(Canvas canvas, Size size) {
    if (alignment == Alignment.topRight) {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            5,
            size.width - _x,
            size.height - 5,
            bottomLeft: Radius.circular(_radius),
            bottomRight: Radius.circular(_radius),
            topLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
      var path = Path();
      path.moveTo(size.width - _x - 5, 5);
      path.lineTo(size.width - _x, 13);
      path.lineTo(size.width, 0);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            size.width - _x - 5,
            0.0,
            size.width,
            size.height,
            topRight: const Radius.circular(3),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
    } else {
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            _x,
            5,
            size.width,
            size.height - 5,
            bottomRight: Radius.circular(_radius),
            topRight: Radius.circular(_radius),
            bottomLeft: Radius.circular(_radius),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
      var path = Path();
      path.moveTo(_x + 5, 5);
      path.lineTo(_x + 5, 13);
      path.lineTo(0, 0);
      canvas.clipPath(path);
      canvas.drawRRect(
          RRect.fromLTRBAndCorners(
            0,
            0.0,
            _x + 5,
            size.height,
            topLeft: const Radius.circular(3),
          ),
          Paint()
            ..color = color
            ..style = PaintingStyle.fill);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
