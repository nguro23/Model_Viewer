import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'html_builder.dart';
import '../fake/dart_html_fake.dart' if (dart.library.html) 'dart:html';
import '../fake/dart_ui_fake.dart' if (dart.library.html) 'dart:ui_web'
    as ui_web;
import 'o3d_model_viewer.dart';

// The state class for the O3DModelViewer widget.
class ModelViewerState extends State<O3DModelViewer> {
  bool _isLoading = true; // Indicates if the model viewer is still loading.

  @override
  void initState() {
    super.initState();
    // Generate the HTML for the model viewer asynchronously.
    unawaited(generateModelViewerHtml());
  }

  /// To generate the HTML code for using the model viewer.
  Future<void> generateModelViewerHtml() async {
    // Load the HTML template from the assets.
    final htmlTemplate =
        await rootBundle.loadString('packages/o3d/assets/template.html');

    // Allow the use of elements.
    final NodeValidator validator =
        widget.overwriteNodeValidatorBuilder ?? defaultNodeValidatorBuilder;

    // Build the HTML using the loaded template.
    final html = _buildHTML(htmlTemplate);

    // Register the view factory for the model viewer.
    ui_web.platformViewRegistry.registerViewFactory(
      'babakcode-model-viewer-html-${widget.id}',
      (viewId) => HtmlHtmlElement()
        // Set styles and inner HTML for the model viewer element.
        // ignore: avoid_dynamic_calls
        ..style.border = 'none'
        // ignore: avoid_dynamic_calls
        ..style.height = '100%'
        // ignore: avoid_dynamic_calls
        ..style.width = '100%'
        ..setInnerHtml(html, validator: validator),
    );

    // Update the loading state.
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(final BuildContext context) {
    // Display a loading indicator if the model viewer is still loading.
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(
              semanticsLabel: 'Loading Model Viewer...',
            ),
          )
        : HtmlElementView(
            viewType: 'babakcode-model-viewer-html-${widget.id}',
            key: Key(widget.id),
          );
  }

  // Builds the HTML string for the model viewer using the provided template.
  String _buildHTML(final String htmlTemplate) {
    if (widget.src.startsWith('file://')) {
      // Local file URL can't be used in Flutter web.
      debugPrint("file:// URL scheme can't be used in Flutter web.");
      throw ArgumentError("file:// URL scheme can't be used in Flutter web.");
    }

    return HTMLBuilder.build(
      htmlTemplate: htmlTemplate.replaceFirst(
        '<script type="module" src="model-viewer.min.js" defer></script>',
        '',
      ),
      // Attributes
      src: widget.src,
      alt: widget.alt,
      poster: widget.poster,
      loading: widget.loading,
      reveal: widget.reveal,
      withCredentials: widget.withCredentials,
      // AR Attributes
      ar: widget.ar,
      arModes: widget.arModes,
      // arScale: widget.arScale,
      // arPlacement: widget.arPlacement,
      iosSrc: widget.iosSrc,
      xrEnvironment: widget.xrEnvironment,
      // Staging & Cameras Attributes
      cameraControls: widget.cameraControls,
      disablePan: widget.disablePan,
      disableTap: widget.disableTap,
      touchAction: widget.touchAction,
      disableZoom: widget.disableZoom,
      orbitSensitivity: widget.orbitSensitivity,
      autoRotate: widget.autoRotate,
      autoRotateDelay: widget.autoRotateDelay,
      rotationPerSecond: widget.rotationPerSecond,
      interactionPrompt: widget.interactionPrompt,
      interactionPromptStyle: widget.interactionPromptStyle,
      interactionPromptThreshold: widget.interactionPromptThreshold,
      cameraOrbit: widget.cameraOrbit,
      cameraTarget: widget.cameraTarget,
      fieldOfView: widget.fieldOfView,
      maxCameraOrbit: widget.maxCameraOrbit,
      minCameraOrbit: widget.minCameraOrbit,
      maxFieldOfView: widget.maxFieldOfView,
      minFieldOfView: widget.minFieldOfView,
      interpolationDecay: widget.interpolationDecay,
      // Lighting & Env Attributes
      skyboxImage: widget.skyboxImage,
      environmentImage: widget.environmentImage,
      exposure: widget.exposure,
      shadowIntensity: widget.shadowIntensity,
      shadowSoftness: widget.shadowSoftness,
      // Animation Attributes
      animationName: widget.animationName,
      animationCrossfadeDuration: widget.animationCrossfadeDuration,
      autoPlay: widget.autoPlay,
      // Materials & Scene Attributes
      variantName: widget.variantName,
      orientation: widget.orientation,
      scale: widget.scale,

      // CSS Styles
      backgroundColor: widget.backgroundColor,

      // Annotations CSS
      minHotspotOpacity: widget.minHotspotOpacity,
      maxHotspotOpacity: widget.maxHotspotOpacity,

      // Others
      innerModelViewerHtml: widget.innerModelViewerHtml,
      relatedCss: widget.relatedCss,
      relatedJs: widget.relatedJs,
      id: widget.id,
      debugLogging: widget.debugLogging,
    );
  }
}

// The default NodeValidatorBuilder allowing specific elements and attributes.
NodeValidatorBuilder defaultNodeValidatorBuilder = NodeValidatorBuilder.common()
  ..allowElement(
    'meta',
    attributes: ['name', 'content'],
    uriPolicy: AllowAllUri(),
  )
  ..allowElement('style')
  ..allowElement(
    'script',
    attributes: [
      'src',
      'type',
      'defer',
      'async',
      'crossorigin',
      'integrity',
      'nomodule',
      'nonce',
      'referrerpolicy',
    ],
    uriPolicy: AllowAllUri(),
  )
  ..allowCustomElement(
    'model-viewer',
    attributes: [
      'style',

      // Loading Attributes
      'src',
      'alt',
      'poster',
      'loading',
      'reveal',
      'with-credentials',

      // Augmented Reality Attributes
      'ar',
      'ar-modes',
      'ar-scale',
      'ar-placement',
      'ios-src',
      'xr-environment',

      // Staing & Cameras Attributes
      'camera-controls',
      'disable-pan',
      'disable-tap',
      'touch-action',
      'disable-zoom',
      'orbit-sensitivity',
      'auto-rotate',
      'auto-rotate-delay',
      'rotation-per-second',
      'interaction-prompt',
      'interaction-prompt-style',
      'interaction-prompt-threshold',
      'camera-orbit',
      'camera-target',
      'field-of-view',
      'max-camera-orbit',
      'min-camera-orbit',
      'max-field-of-view',
      'min-field-of-view',
      'interpolation-decay',

      // Lighting & Env Attributes
      'skybox-image',
      'environment-image',
      'exposure',
      'shadow-intensity',
      'shadow-softness ',

      // Animation Attributes
      'animation-name',
      'animation-crossfade-duration',
      'autoplay',

      // Materials & Scene Attributes
      'variant-name',
      'orientation',
      'scale',
    ],
    uriPolicy: AllowAllUri(),
  );

// A class to allow all URIs in the NodeValidator.
class AllowAllUri implements UriPolicy {
  @override
  bool allowsUri(String uri) {
    return true;
  }
}
