import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../interfaces/o3d_controller_interface.dart';

/// Implementation of the O3DControllerInterface using a WebView controller.
class O3dImp implements O3DControllerInterface {
  final WebViewController? webViewController; // Controller for the WebView.
  final String id; // ID for identifying the specific model viewer instance.

  O3dImp({
    this.webViewController,
    required this.id,
  });

  /// Orbits the camera around the model to the specified theta, phi, and radius.
  @override
  void cameraOrbit(double theta, double phi, double radius) {
    webViewController?.runJavaScript('''(() => {
        cameraOrbit$id($theta, $phi, $radius); 
      })();
    ''');
  }

  /// Sets the camera target to the specified x, y, and z coordinates.
  @override
  void cameraTarget(double x, double y, double z) {
    webViewController?.runJavaScript('''(() => {
        cameraTarget$id($x, $y, $z); 
      })();
    ''');
  }

  /// Executes custom JavaScript code.
  @override
  void customJsCode(String code) {
    webViewController?.runJavaScript('''(() => {
        customEvaluate$id('$code'); 
      })();
    ''');
  }

  @override
  ValueChanged<Object>? logger; // Logger for the controller.

  /// Sets the animation name to be played.
  @override
  set animationName(String? name) {
    webViewController?.runJavaScript('''(() => {
        animationName$id('$name'); 
      })();
    ''');
  }

  /// Enables or disables auto-rotation of the model.
  @override
  set autoRotate(bool? set) {
    webViewController?.runJavaScript('''(() => {
        autoRotate$id($set); 
      })();
    ''');
  }

  /// Enables or disables auto-play of the animation.
  @override
  set autoPlay(bool? set) {
    webViewController?.runJavaScript('''(() => {
        autoPlay$id($set); 
      })();
    ''');
  }

  /// Enables or disables camera controls.
  @override
  set cameraControls(bool? set) {
    webViewController?.runJavaScript('''(() => {
        cameraControls$id($set); 
      })();
    ''');
  }

  /// Sets the variant name of the model to be displayed.
  @override
  set variantName(String? set) {
    webViewController?.runJavaScript('''(() => {
        variantName$id('$set'); 
      })();
    ''');
  }

  /// Returns a list of available animations for the model.
  @override
  Future<List<String>> availableAnimations() async {
    final res = await webViewController?.runJavaScriptReturningResult(
        'document.querySelector(\'#$id\').availableAnimations');
    return jsonDecode(res as String).cast<String>();
  }

  /// Pauses the current animation.
  @override
  void pause() {
    webViewController?.runJavaScript('''(() => {
        pause$id(); 
      })();
  ''');
  }

  /// Plays the animation with the specified number of repetitions.
  @override
  void play({int? repetitions}) {
    webViewController?.runJavaScript('''(() => {
        play$id({repetitions: $repetitions}); 
      })();
  ''');
  }
}
