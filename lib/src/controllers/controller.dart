part of '../app/o3d.dart';

/// Controller class for the O3D model viewer.
/// This class implements the O3DControllerInterface and delegates its methods to the O3dDataSource.
class O3DController implements O3DControllerInterface {
  late O3dDataSource
      _dataSource; // Data source that handles the actual implementation.

  /// Orbits the camera around the model to the specified theta, phi, and radius.
  @override
  void cameraOrbit(double theta, double phi, double radius) =>
      _dataSource.cameraOrbit(theta, phi, radius);

  /// Sets the camera target to the specified x, y, and z coordinates.
  @override
  void cameraTarget(double x, double y, double z) =>
      _dataSource.cameraTarget(x, y, z);

  /// Executes custom JavaScript code.
  @override
  void customJsCode(String code) => _dataSource.customJsCode(code);

  @override
  ValueChanged<Object>? logger; // Logger for the controller.

  /// Sets the animation name to be played.
  @override
  set animationName(String? set) => _dataSource.animationName = set;

  /// Enables or disables auto-rotation of the model.
  @override
  set autoRotate(bool? set) => _dataSource.autoRotate = set;

  /// Enables or disables camera controls.
  @override
  set cameraControls(bool? set) => _dataSource.cameraControls = set;

  /// Sets the variant name of the model to be displayed.
  @override
  set variantName(String? set) => _dataSource.variantName = set;

  /// Deprecated method to enable or disable auto-play of the animation.
  /// Use play() and pause() methods instead.
  @Deprecated('use play() and pause() methods instead!')
  @override
  set autoPlay(bool? set) => _dataSource.autoPlay = set;

  /// Returns a list of available animations for the model.
  @override
  Future<List<String>> availableAnimations() =>
      _dataSource.availableAnimations();

  /// Pauses the current animation.
  @override
  void pause() => _dataSource.pause();

  /// Plays the animation with the specified number of repetitions.
  @override
  void play({int? repetitions}) => _dataSource.play(repetitions: repetitions);
}
