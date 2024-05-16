import 'package:flutter/material.dart';
import 'package:o3d/src/controllers/interfaces/o3d_controller_interface.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../implementation/o3d_stub_impl.dart'
    if (dart.library.js) '../implementation/o3d_web_impl.dart';

/// Data source implementation for O3D controller interface.
/// This class acts as a wrapper around the O3dImp implementation.
class O3dDataSource implements O3DControllerInterface {
  final O3dImp _o3dImp; // The implementation of the O3D controller interface.

  WebViewController? webViewController; // Controller for the WebView.
  String id; // ID for identifying the specific model viewer instance.

  O3dDataSource({this.webViewController, required this.id})
      : _o3dImp = O3dImp(webViewController: webViewController, id: id);

  /// Orbits the camera around the model to the specified theta, phi, and radius.
  @override
  void cameraOrbit(double theta, double phi, double radius) =>
      _o3dImp.cameraOrbit(theta, phi, radius);

  /// Sets the camera target to the specified x, y, and z coordinates.
  @override
  void cameraTarget(double x, double y, double z) =>
      _o3dImp.cameraTarget(x, y, z);

  /// Executes custom JavaScript code.
  @override
  void customJsCode(String code) => _o3dImp.customJsCode(code);

  @override
  ValueChanged<Object>? logger; // Logger for the controller.

  /// Sets the animation name to be played.
  @override
  set animationName(String? name) => _o3dImp.animationName = name;

  /// Enables or disables auto-rotation of the model.
  @override
  set autoRotate(bool? set) => _o3dImp.autoRotate = set;

  /// Enables or disables auto-play of the animation.
  @override
  set autoPlay(bool? set) => _o3dImp.autoPlay = set;

  /// Enables or disables camera controls.
  @override
  set cameraControls(bool? set) => _o3dImp.cameraControls = set;

  /// Sets the variant name of the model to be displayed.
  @override
  set variantName(String? set) => _o3dImp.variantName = set;

  /// Returns a list of available animations for the model.
  @override
  Future<List<String>> availableAnimations() => _o3dImp.availableAnimations();

  /// Pauses the current animation.
  @override
  void pause() => _o3dImp.pause();

  /// Plays the animation with the specified number of repetitions.
  @override
  void play({int? repetitions}) => _o3dImp.play(repetitions: repetitions);
}
