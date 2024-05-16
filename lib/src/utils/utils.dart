import 'dart:math';

/// Utility class containing methods for generating IDs and JavaScript code for interacting with a WebView.
class Utils {
  final random =
      Random(); // Instance of Random class for generating random numbers.

  /// Generates a random ID string.
  /// The ID is prefixed with 'BabakCode' followed by two sets of random numbers.
  String get generateId =>
      'BabakCode${random.nextInt(99999)}${random.nextInt(99999)}';

  /// Generates JavaScript code for interacting with a model viewer element.
  ///
  /// The [id] parameter is required and is used to target the specific model viewer element.
  ///
  /// The returned string contains JavaScript functions for various interactions:
  /// - cameraOrbit: Sets the camera orbit angles and radius.
  /// - cameraTarget: Sets the camera target position.
  /// - customEvaluate: Evaluates custom JavaScript code.
  /// - animationName: Sets the animation name.
  /// - availableAnimations: Gets the list of available animations.
  /// - autoRotate: Enables or disables auto-rotate.
  /// - autoPlay: Plays or pauses the animation.
  /// - cameraControls: Enables or disables camera controls.
  /// - variantName: Sets the variant name.
  /// - play: Plays the animation with optional repetitions.
  /// - pause: Pauses the animation.
  String relatedJs({required String id}) => """
cameraOrbit$id = (a, b, c) => {document.querySelector('#$id').cameraOrbit = `\${a}deg \${b}deg \${c}m`}
cameraTarget$id = (x, y, z) => {document.querySelector('#$id').cameraTarget = `\${x}m \${y}m \${z}m`}
customEvaluate$id = (code) => { eval(code) }
animationName$id = (set) => { document.querySelector('#$id').setAttribute('animation-name', set); }
availableAnimations$id = (set) => { return document.querySelector('#$id').availableAnimations; }
autoRotate$id = (set) => { document.querySelector('#$id').setAttribute('auto-rotate', set ?? false); }
autoPlay$id = (set) => { (set ?? false) ? document.querySelector('#$id').play() : document.querySelector('#$id').pause(); }
cameraControls$id = (set) => { document.querySelector('#$id').setAttribute('camera-controls', set ?? false); }
variantName$id = (set) => { document.querySelector('#$id').variantName = set; }
play$id = ({repetitions}) => { document.querySelector('#$id').play({repetitions}); }
pause$id = () => { document.querySelector('#$id').pause(); }
""";
}
