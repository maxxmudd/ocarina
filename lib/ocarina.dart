/*
* Notes:  - speed exists in the constructor and has mechanics to be changed
*           within the application, but it needs to be assigned to parameters
*           each time the value changes as well as on construction
*
* */

import 'dart:async';

import 'package:flutter/services.dart';

class OcarinaPlayer {
  static const MethodChannel _channel = const MethodChannel('ocarina');

  /// Player id
  int _id;
  double volume;
  final bool loop;
  double speed;

  String asset;
  String filePath;

  OcarinaPlayer({
    this.asset,
    this.filePath,
    this.volume = 1.0,
    this.loop = false,
    this.speed = 1.0,
  }) {
    assert(
    (asset != null && filePath == null) ||
        (asset == null && filePath != null),
    'You need to specify an assert, OR filePath, not both, or neither');
  }

  /// Loads your asset or file, no other operation can be performed on this instance before this is called
  Future<void> load() async {
    _id = await _channel.invokeMethod('load', {
      'url': asset ?? filePath,
      'volume': volume,
      'loop': loop,
      'isAsset': asset != null,
      'speed': speed,
    });
  }

  Future<void> play() async {
    _ensureLoaded();
    await _channel.invokeMethod('play', {'playerId': _id});
  }

  Future<void> pause() async {
    _ensureLoaded();
    await _channel.invokeMethod('pause', {'playerId': _id});
  }

  Future<void> resume() async {
    _ensureLoaded();
    await _channel.invokeMethod('resume', {'playerId': _id});
  }

  Future<void> stop() async {
    _ensureLoaded();
    await _channel.invokeMethod('stop', {'playerId': _id});
  }

  Future<void> seek(Duration duration) async {
    _ensureLoaded();
    await _channel.invokeMethod(
        'seek', {'playerId': _id, 'position': duration.inMilliseconds});
  }

  Future<void> updateVolume(double volume) async {
    _ensureLoaded();
    await _channel.invokeMethod('volume', {'playerId': _id, 'volume': volume});
  }


  Future<void> updateSpeed(double speed) async {
    _ensureLoaded();
    await _channel.invokeMethod('speed', {'playerId': _id, 'speed': speed});
  }

  void _ensureLoaded() {
    assert(isLoaded(), 'Player is not loaded yet, you must call load before.');
  }

  bool isLoaded() => _id != null;

  Future<void> dispose() async {
    _ensureLoaded();
    await _channel.invokeMethod('dispose', {'playerId': _id});
    _id = null;
  }
}
