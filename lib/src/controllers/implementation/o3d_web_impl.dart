import 'package:flutter/material.dart';
import '../../app/fake/js_fake.dart' if (dart.library.js) 'dart:js';
import 'package:webview_flutter/webview_flutter.dart';
import '../interfaces/o3d_controller_interface.dart';

/// Implementation of the O3DControllerInterface using JavaScript context calls.
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
    context.callMethod("cameraOrbit$id", [theta, phi, radius]);
  }

  /// Sets the camera target to the specified x, y, and z coordinates.
  @override
  void cameraTarget(double x, double y, double z) {
    context.callMethod("cameraTarget$id", [x, y, z]);
  }

  /// Executes custom JavaScript code.
  @override
  void customJsCode(String code) {
    context.callMethod("customEvaluate$id", [code]);
  }

  @override
  ValueChanged<Object>? logger; // Logger for the controller.

  /// Sets the animation name to be played.
  @override
  set animationName(String? set) {
    context.callMethod("animationName$id", [set]);
  }

  /// Enables or disables auto-rotation of the model.
  @override
  set autoRotate(bool? set) {
    context.callMethod("autoRotate$id", [set]);
  }

  /// Enables or disables auto-play of the animation.
  @override
  set autoPlay(bool? set) {
    context.callMethod("autoPlay$id", [set]);
  }

  /// Enables or disables camera controls.
  @override
  set cameraControls(bool? set) {
    context.callMethod("cameraControls$id", [set]);
  }

  /// Sets the variant name of the model to be displayed.
  @override
  set variantName(String? variantName) {
    context.callMethod("variantName$id", [variantName]);
  }

  /// Returns a list of available animations for the model.
  @override
  Future<List<String>> availableAnimations() async =>
      ((await context.callMethod("availableAnimations$id"))).cast<String>();

  /// Pauses the current animation.
  @override
  void pause() => context.callMethod("pause$id");

  /// Plays the animation with the specified number of repetitions.
  @override
  void play({int? repetitions}) => context.callMethod("customEvaluate$id",
      ['''(() => { play$id({repetitions: $repetitions}); })();''']);
}
