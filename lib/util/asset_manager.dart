// This class is used to load assets from the asset bundle
import 'package:flutter/services.dart';

abstract class IAssetManager {
  // Load an asset from the asset bundle
  Future<Uint8List> load(String key);
}

class AssetManager implements IAssetManager {
  const AssetManager();

  @override
  Future<Uint8List> load(String key) {
    return transferAssetImage(key);
  }

  Future<Uint8List> transferAssetImage(String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return list;
  }
}
