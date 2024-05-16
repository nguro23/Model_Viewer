import 'dart:convert' show htmlEscape;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:o3d/o3d.dart';

// An abstract class for building HTML for a model viewer.
abstract class HTMLBuilder {
  // Private constructor to prevent instantiation.
  HTMLBuilder._();

  // Builds an HTML string with various attributes and styles for a model viewer.
  static String build({
    // Attributes
    // Loading Attributes
    required String src, // Source URL for the 3D model.
    String htmlTemplate = '', // HTML template to be used.
    final String? alt, // Alternate text for the model.
    final String? poster, // Poster image URL.
    final Loading? loading, // Loading behavior for the model.
    final Reveal? reveal, // Reveal behavior for the model.
    final bool? withCredentials, // Whether to include credentials in requests.

    // AR Attributes
    final bool? ar, // Enable augmented reality.
    final List<String>? arModes, // Modes for augmented reality.
    final ArScale? arScale, // Scale for augmented reality.
    final ArPlacement? arPlacement, // Placement for augmented reality.
    String? iosSrc, // iOS-specific source URL.
    final bool? xrEnvironment, // Enable XR environment.

    // Staging & Cameras Attributes
    final bool? cameraControls, // Enable camera controls.
    final bool? disablePan, // Disable pan controls.
    final bool? disableTap, // Disable tap controls.
    final TouchAction? touchAction, // Touch action behavior.
    final bool? disableZoom, // Disable zoom controls.
    final int? orbitSensitivity, // Sensitivity of orbit controls.
    final bool? autoRotate, // Enable auto-rotation.
    final int? autoRotateDelay, // Delay before auto-rotation starts.
    final String? rotationPerSecond, // Rotation speed per second.
    final InteractionPrompt? interactionPrompt, // Interaction prompt behavior.
    final InteractionPromptStyle?
        interactionPromptStyle, // Style of interaction prompt.
    final num? interactionPromptThreshold, // Threshold for interaction prompt.
    final String? cameraOrbit, // Initial camera orbit position.
    final String? cameraTarget, // Initial camera target position.
    final String? fieldOfView, // Field of view.
    final String? maxCameraOrbit, // Maximum camera orbit.
    final String? minCameraOrbit, // Minimum camera orbit.
    final String? maxFieldOfView, // Maximum field of view.
    final String? minFieldOfView, // Minimum field of view.
    final num? interpolationDecay, // Interpolation decay rate.

    // Lighting & Env Attributes
    final String? skyboxImage, // Skybox image URL.
    final String? environmentImage, // Environment image URL.
    final num? exposure, // Exposure level.
    final num? shadowIntensity, // Shadow intensity.
    final num? shadowSoftness, // Shadow softness.

    // Animation Attributes
    final String? animationName, // Name of the animation.
    final num? animationCrossfadeDuration, // Crossfade duration for animations.
    final bool? autoPlay, // Enable auto-play for animations.

    // Scene Graph Attributes
    final String? variantName, // Variant name.
    final String? orientation, // Orientation of the model.
    final String? scale, // Scale of the model.

    // CSS Styles
    final Color backgroundColor = Colors.transparent, // Background color.

    // Annotations CSS
    final num? minHotspotOpacity, // Minimum opacity for hotspots.
    final num? maxHotspotOpacity, // Maximum opacity for hotspots.

    // Others
    final String? innerModelViewerHtml, // Inner HTML for the model viewer.
    final String? relatedCss, // Related CSS to be included.
    final String? relatedJs, // Related JavaScript to be included.
    required final String id, // ID for the model viewer element.
    final bool? debugLogging, // Enable debug logging.
  }) {
    // Replace the placeholder in the HTML template with the related CSS if provided.
    if (relatedCss != null) {
      // ignore: parameter_assignments
      htmlTemplate = htmlTemplate.replaceFirst('/* other-css */', relatedCss);
    }

    // Adjust the src for web builds if it's not a full URL.
    if (kIsWeb) {
      if (!src.trim().startsWith("http")) {
        src = kReleaseMode || kProfileMode ? 'assets/$src' : src;
      }
    }

    // Build the <model-viewer> HTML element.
    final modelViewerHtml = StringBuffer()
      ..write('<model-viewer')
      // Attributes
      // Loading Attributes
      // src
      ..write(' src="${htmlEscape.convert(src)}"');

    // Add alt attribute if provided.
    if (alt != null) {
      modelViewerHtml.write(' alt="${htmlEscape.convert(alt)}"');
    }

    // Add poster attribute if provided.
    if (poster != null) {
      modelViewerHtml.write(' poster="${htmlEscape.convert(poster)}"');
    }

    // Add loading attribute if provided.
    if (loading != null) {
      switch (loading) {
        case Loading.auto:
          modelViewerHtml.write(' loading="auto"');
        case Loading.lazy:
          modelViewerHtml.write(' loading="lazy"');
        case Loading.eager:
          modelViewerHtml.write(' loading="eager"');
      }
    }

    // Add reveal attribute if provided.
    if (reveal != null) {
      switch (reveal) {
        case Reveal.auto:
          modelViewerHtml.write(' reveal="auto"');
        case Reveal.interaction:
          modelViewerHtml.write(' reveal="interaction"');
        case Reveal.manual:
          modelViewerHtml.write(' reveal="manual"');
      }
    }

    // Add with-credentials attribute if true.
    if (withCredentials ?? false) {
      modelViewerHtml.write(' with-credentials');
    }

    // Augmented Reality Attributes
    // Add ar attribute if true.
    if (ar ?? false) {
      modelViewerHtml.write(' ar');
    }

    // Add ar-modes attribute if provided.
    if (arModes != null) {
      modelViewerHtml
          .write(' ar-modes="${htmlEscape.convert(arModes.join(' '))}"');
    }

    // Add ar-scale attribute if provided.
    if (arScale != null) {
      switch (arScale) {
        case ArScale.auto:
          modelViewerHtml.write(' ar-scale="auto"');
        case ArScale.fixed:
          modelViewerHtml.write(' ar-scale="fixed"');
      }
    }

    // Add ar-placement attribute if provided.
    if (arPlacement != null) {
      switch (arPlacement) {
        case ArPlacement.floor:
          modelViewerHtml.write(' ar-placement="floor"');
        case ArPlacement.wall:
          modelViewerHtml.write(' ar-placement="wall"');
      }
    }

    // Add ios-src attribute if provided.
    if (iosSrc != null) {
      if (!iosSrc.trim().startsWith("http") && kIsWeb) {
        iosSrc = kReleaseMode || kProfileMode ? 'assets/$iosSrc' : iosSrc;
      }
      modelViewerHtml.write(' ios-src="${htmlEscape.convert(iosSrc)}"');
    }

    // Add xr-environment attribute if true.
    if (xrEnvironment ?? false) {
      modelViewerHtml.write(' xr-environment');
    }

    // Staging & Cameras Attributes
    // Add camera-controls attribute if true.
    if (cameraControls ?? false) {
      modelViewerHtml.write(' camera-controls');
    }

    // Add disable-pan attribute if true.
    if (disablePan ?? false) {
      modelViewerHtml.write(' disable-pan');
    }

    // Add disable-tap attribute if true.
    if (disableTap ?? false) {
      modelViewerHtml.write(' disable-tap');
    }

    // Add touch-action attribute if provided.
    if (touchAction != null) {
      switch (touchAction) {
        case TouchAction.none:
          modelViewerHtml.write(' touch-action="none"');
        case TouchAction.panX:
          modelViewerHtml.write(' touch-action="pan-x"');
        case TouchAction.panY:
          modelViewerHtml.write(' touch-action="pan-y"');
      }
    }

    // Add disable-zoom attribute if true.
    if (disableZoom ?? false) {
      modelViewerHtml.write(' disable-zoom');
    }

    // Add orbit-sensitivity attribute if provided.
    if (orbitSensitivity != null) {
      modelViewerHtml.write(' orbit-sensitivity="$orbitSensitivity"');
    }

    // Add auto-rotate attribute if true.
    if (autoRotate ?? false) {
      modelViewerHtml.write(' auto-rotate');
    }

    // Add auto-rotate-delay attribute if provided.
    if (autoRotateDelay != null) {
      modelViewerHtml.write(' auto-rotate-delay="$autoRotateDelay"');
    }

    // Add rotation-per-second attribute if provided.
    if (rotationPerSecond != null) {
      modelViewerHtml.write(
        ' rotation-per-second="${htmlEscape.convert(rotationPerSecond)}"',
      );
    }

    // Add interaction-prompt attribute if provided.
    if (interactionPrompt != null) {
      switch (interactionPrompt) {
        case InteractionPrompt.auto:
          modelViewerHtml.write(' interaction-prompt="auto"');
        case InteractionPrompt.none:
          modelViewerHtml.write(' interaction-prompt="none"');
        case InteractionPrompt.whenFocused:
          modelViewerHtml.write(' interaction-prompt="when-focused"');
      }
    }

    // Add interaction-prompt-style attribute if provided.
    if (interactionPromptStyle != null) {
      switch (interactionPromptStyle) {
        case InteractionPromptStyle.basic:
          modelViewerHtml.write(' interaction-prompt-style="basic"');
        case InteractionPromptStyle.wiggle:
          modelViewerHtml.write(' interaction-prompt-style="wiggle"');
      }
    }

    // Add interaction-prompt-threshold attribute if provided.
    if (interactionPromptThreshold != null) {
      if (interactionPromptThreshold < 0) {
        throw RangeError('interaction-prompt-threshold must be >= 0');
      }
      modelViewerHtml
          .write(' interaction-prompt-threshold="$interactionPromptThreshold"');
    }

    // Add camera-orbit attribute if provided.
    if (cameraOrbit != null) {
      modelViewerHtml
          .write(' camera-orbit="${htmlEscape.convert(cameraOrbit)}"');
    }

    // Add camera-target attribute if provided.
    if (cameraTarget != null) {
      modelViewerHtml
          .write(' camera-target="${htmlEscape.convert(cameraTarget)}"');
    }

    // Add field-of-view attribute if provided.
    if (fieldOfView != null) {
      modelViewerHtml
          .write(' field-of-view="${htmlEscape.convert(fieldOfView)}"');
    }

    // Add max-camera-orbit attribute if provided.
    if (maxCameraOrbit != null) {
      modelViewerHtml
          .write(' max-camera-orbit="${htmlEscape.convert(maxCameraOrbit)}"');
    }

    // Add min-camera-orbit attribute if provided.
    if (minCameraOrbit != null) {
      modelViewerHtml
          .write(' min-camera-orbit="${htmlEscape.convert(minCameraOrbit)}"');
    }

    // Add max-field-of-view attribute if provided.
    if (maxFieldOfView != null) {
      modelViewerHtml
          .write(' max-field-of-view="${htmlEscape.convert(maxFieldOfView)}"');
    }

    // Add min-field-of-view attribute if provided.
    if (minFieldOfView != null) {
      modelViewerHtml
          .write(' min-field-of-view="${htmlEscape.convert(minFieldOfView)}"');
    }

    // Add interpolation-decay attribute if provided.
    if (interpolationDecay != null) {
      if (interpolationDecay <= 0) {
        throw RangeError('interaction-decay must be greater than 0');
      }
      modelViewerHtml.write(' interpolation-decay="$interpolationDecay"');
    }

    // Lighting & Env Attributes
    // Add skybox-image attribute if provided.
    if (skyboxImage != null) {
      modelViewerHtml
          .write(' skybox-image="${htmlEscape.convert(skyboxImage)}"');
    }

    // Add environment-image attribute if provided.
    if (environmentImage != null) {
      modelViewerHtml.write(
        ' environment-image="${htmlEscape.convert(environmentImage)}"',
      );
    }

    // Add exposure attribute if provided.
    if (exposure != null) {
      if (exposure < 0) {
        throw RangeError('exposure must be any positive value');
      }
      modelViewerHtml.write(' exposure="$exposure"');
    }

    // Add shadow-intensity attribute if provided.
    if (shadowIntensity != null) {
      if (shadowIntensity < 0 || shadowIntensity > 1) {
        throw RangeError('shadow-intensity must be between 0 and 1');
      }
      modelViewerHtml.write(' shadow-intensity="$shadowIntensity"');
    }

    // Add shadow-softness attribute if provided.
    if (shadowSoftness != null) {
      if (shadowSoftness < 0 || shadowSoftness > 1) {
        throw RangeError('shadow-softness must be between 0 and 1');
      }
      modelViewerHtml.write(' shadow-softness="$shadowSoftness"');
    }

    // Animation Attributes
    // Add animation-name attribute if provided.
    if (animationName != null) {
      modelViewerHtml
          .write(' animation-name="${htmlEscape.convert(animationName)}"');
    }

    // Add animation-crossfade-duration attribute if provided.
    if (animationCrossfadeDuration != null) {
      if (animationCrossfadeDuration < 0) {
        throw RangeError(
            'animation-crossfade-duration must be any number >= 0');
      }
      modelViewerHtml.write(
        ' animation-crossfade-duration="$animationCrossfadeDuration"',
      );
    }

    // Add autoplay attribute if true.
    if (autoPlay ?? false) {
      modelViewerHtml.write(' autoplay');
    }

    // Scene Graph Attributes
    // Add variant-name attribute if provided.
    if (variantName != null) {
      modelViewerHtml
          .write(' variant-name="${htmlEscape.convert(variantName)}"');
    }

    // Add orientation attribute if provided.
    if (orientation != null) {
      modelViewerHtml
          .write(' orientation="${htmlEscape.convert(orientation)}"');
    }

    // Add scale attribute if provided.
    if (scale != null) {
      modelViewerHtml.write(' scale="${htmlEscape.convert(scale)}"');
    }

    // Styles
    // Add CSS styles for background color.
    modelViewerHtml
      ..write(' style="')
      ..write(
        'background-color: rgba(${backgroundColor.red}, ${backgroundColor.green}, ${backgroundColor.blue}, ${backgroundColor.alpha}); ',
      );

    // Annotations CSS
    // Add min-hotspot-opacity style if provided.
    if (minHotspotOpacity != null) {
      if (minHotspotOpacity > 1 || minHotspotOpacity < 0) {
        throw RangeError('--min-hotspot-opacity must be between 0 and 1');
      }
      modelViewerHtml.write('min-hotspot-opacity: $minHotspotOpacity; ');
    }

    // Add max-hotspot-opacity style if provided.
    if (maxHotspotOpacity != null) {
      if (maxHotspotOpacity > 1 || maxHotspotOpacity < 0) {
        throw RangeError('--max-hotspot-opacity must be between 0 and 1');
      }
      modelViewerHtml.write('max-hotspot-opacity: $maxHotspotOpacity; ');
    }

    modelViewerHtml.write('"'); // Close the style attribute.

    // Add the id attribute.
    modelViewerHtml.write(' id="${htmlEscape.convert(id)}"');

    // Close the opening tag for <model-viewer>.
    modelViewerHtml.writeln('>');

    // Add inner HTML if provided.
    if (innerModelViewerHtml != null) {
      modelViewerHtml.writeln(innerModelViewerHtml);
    }

    // Close the <model-viewer> element.
    modelViewerHtml.writeln('</model-viewer>');

    // Add related JavaScript if provided.
    if (relatedJs != null) {
      modelViewerHtml
        ..writeln('<script>')
        ..write(relatedJs)
        ..writeln('</script>');
    }

    // Print debug information if debug logging is enabled.
    if (debugLogging ?? false) {
      debugPrint('HTML generated for model_viewer_plus:');
    }

    // Replace the body placeholder in the HTML template with the generated model viewer HTML.
    final html =
        htmlTemplate.replaceFirst('<!-- body -->', modelViewerHtml.toString());

    // Print the final HTML if debug logging is enabled.
    if (debugLogging ?? false) {
      debugPrint(html);
    }

    // Return the final HTML string.
    return html;
  }
}
