import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:io' show File, HttpServer, HttpStatus, InternetAddress, Platform;
import 'package:android_intent_plus/android_intent.dart' as android_content;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart'
    as android;
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'
    as ios;

import 'html_builder.dart';
import 'o3d_model_viewer.dart';

// The state class for the O3DModelViewer widget.
class ModelViewerState extends State<O3DModelViewer> {
  HttpServer? _proxy; // The HTTP server used as a proxy.
  WebViewController? _webViewController; // The controller for the WebView.
  late String _proxyURL; // The URL for the proxy server.
  List<String> routesRequested = []; // List of requested routes.

  @override
  void initState() {
    super.initState();
    // Initialize the proxy and the WebView controller asynchronously.
    unawaited(
      _initProxy().then(
        (_) => _initController()
          ..catchError(
            (e) => widget.controller?.logger?.call('init control error: $e'),
          ),
      )..catchError(
          (e) => widget.controller?.logger?.call('init proxy error $e'),
        ),
    );
  }

  @override
  void dispose() {
    // Close the proxy server if it is running.
    if (_proxy != null) {
      unawaited(_proxy!.close(force: true));
      _proxy = null;
    }
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    // Show a loading indicator if the proxy or WebView controller is not ready.
    if (_proxy == null || _webViewController == null) {
      return const Center(
        child: CircularProgressIndicator(
          semanticsLabel: 'Loading Model Viewer',
        ),
      );
    }
    // Return the WebView widget with the configured controller.
    return WebViewWidget(
      // onWebViewCreated: (controller) => _webViewController = controller,
      controller: _webViewController!,
      gestureRecognizers: const <Factory<OneSequenceGestureRecognizer>>{
        Factory<OneSequenceGestureRecognizer>(EagerGestureRecognizer.new),
      },
    );
  }

  // Builds the HTML string for the model viewer.
  String _buildHTML(String htmlTemplate) {
    return HTMLBuilder.build(
      htmlTemplate: htmlTemplate,
      src: '/model',
      alt: widget.alt,
      poster: widget.poster,
      loading: widget.loading,
      reveal: widget.reveal,
      withCredentials: widget.withCredentials,
      // AR Attributes
      ar: widget.ar,
      arModes: widget.arModes,
      arScale: widget.arScale,
      arPlacement: widget.arPlacement,
      iosSrc: widget.iosSrc,
      xrEnvironment: widget.xrEnvironment,
      // Cameras Attributes
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

  // Initializes the WebView controller.
  Future<void> _initController() async {
    // Define parameters for WebView controller based on platform.
    // Create platform-specific WebView controller parameters.
    late final PlatformWebViewControllerCreationParams params;
    if (Platform.isAndroid) {
      params = android.AndroidWebViewControllerCreationParams();
    } else if (Platform.isIOS) {
      params = ios.WebKitWebViewControllerCreationParams(
          allowsInlineMediaPlayback: true);
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }
    // Create the WebView controller using the platform-specific parameters.
    final webViewController =
        WebViewController.fromPlatformCreationParams(params);
    // Set the background color and enable JavaScript mode for the WebView.
    await webViewController.setBackgroundColor(Colors.transparent);
    await webViewController.setJavaScriptMode(JavaScriptMode.unrestricted);

    widget.controller?.logger?.call("init config");

    // Set up the navigation delegate to handle navigation requests.
    await webViewController.setNavigationDelegate(
      NavigationDelegate(
        onNavigationRequest: (request) async {
          debugPrint('ModelViewer wants to load: ${request.url}');
          // Handle iOS-specific navigation.
          if (Platform.isIOS && request.url == widget.iosSrc) {
            await launchUrl(
              Uri.parse(request.url.trimLeft()),
              mode: LaunchMode.inAppWebView,
            );
            return NavigationDecision.prevent;
          }
          // Allow navigation for non-Android platforms and non-intent URLs.
          if (!Platform.isAndroid) {
            return NavigationDecision.navigate;
          }
          if (!request.url.startsWith('intent://')) {
            return NavigationDecision.navigate;
          }
          try {
            // Handle Android-specific navigation using intents.
            // Determine the file URL based on the source.

            // Original, just keep as a backup
            // See: https://developers.google.com/ar/develop/java/scene-viewer
            // final intent = android_content.AndroidIntent(
            //   action: "android.intent.action.VIEW", // Intent.ACTION_VIEW
            //   data: "https://arvr.google.com/scene-viewer/1.0",
            //   arguments: <String, dynamic>{
            //     'file': widget.src,
            //     'mode': 'ar_preferred',
            //   },
            //   package: "com.google.ar.core",
            //   flags: <int>[
            //     Flag.FLAG_ACTIVITY_NEW_TASK
            //   ], // Intent.FLAG_ACTIVITY_NEW_TASK,
            // );

            final String fileURL;
            if (['http', 'https'].contains(Uri.parse(widget.src).scheme)) {
              fileURL = widget.src;
            } else {
              fileURL = p.joinAll([_proxyURL, 'model']);
            }
            // Create and launch an Android intent for AR viewing
            final intent = android_content.AndroidIntent(
              action: 'android.intent.action.VIEW',
              // Intent.ACTION_VIEW
              // See https://developers.google.com/ar/develop/scene-viewer#3d-or-ar
              // data should be something like "https://arvr.google.com/scene-viewer/1.0?file=https://raw.githubusercontent.com/KhronosGroup/glTF-Sample-Models/master/2.0/Avocado/glTF/Avocado.gltf"
              data: Uri(
                scheme: 'https',
                host: 'arvr.google.com',
                path: '/scene-viewer/1.0',
                queryParameters: {
                  'mode': 'ar_preferred',
                  'file': fileURL,
                },
              ).toString(),
              // package changed to com.google.android.googlequicksearchbox
              // to support the widest possible range of devices
              package: 'com.google.android.googlequicksearchbox',
              arguments: <String, dynamic>{
                'browser_fallback_url':
                    'market://details?id=com.google.android.googlequicksearchbox',
              },
            );
            await intent.launch().onError((error, stackTrace) {
              debugPrint('ModelViewer Intent Error: $error');
            });
          } on Object catch (error) {
            debugPrint('ModelViewer failed to launch AR: $error');
          }
          return NavigationDecision.prevent;
        },
      ),
    );
    // Add JavaScript channels to the WebView controller if provided.
    widget.javascriptChannels?.forEach((element) {
      webViewController.addJavaScriptChannel(
        element.name,
        onMessageReceived: element.onMessageReceived,
      );
    });

    debugPrint('ModelViewer initializing... <$_proxyURL>');
    widget.onWebViewCreated?.call(webViewController);
    await webViewController.loadRequest(Uri.parse(_proxyURL));
    setState(() => _webViewController = webViewController);
    widget.controller?.logger?.call('initialized webViewController');
    // Future.delayed(const Duration(seconds: 5),() => _webViewController?.loadRequest(Uri.parse('${_proxyURL}model')));
  }

  // Initializes the proxy server.
  Future<void> _initProxy() async {
    try {
      String src = widget.src;

      widget.controller?.logger?.call('init proxy start');

      final url = Uri.parse(src);
      _proxy = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);

      widget.controller?.logger?.call('url is ${url.toString()}');

      setState(() {
        final host = _proxy!.address.address;
        final port = _proxy!.port;
        _proxyURL = 'http://$host:$port/';
      });
      // Listen for incoming HTTP requests to the proxy server.
      _proxy!.listen((request) async {
        final response = request.response;
        // if(routesRequested.contains(request.uri.path)){
        //   return;
        // }

        // routesRequested.add(request.uri.path);

        widget.controller?.logger?.call('url is ${request.uri.path}');

        switch (request.uri.path) {
          case '/':
          case '/index.html':
            // Serve the HTML template.
            final htmlTemplate = await rootBundle
                .loadString('packages/o3d/assets/template.html');
            final html = utf8.encode(_buildHTML(htmlTemplate));

            widget.controller?.logger?.call(
                'html is not empty: ${html.isNotEmpty} and length is ${html.length.toString()}');

            response
              ..statusCode = HttpStatus.ok
              ..headers.add('Content-Type', 'text/html;charset=UTF-8')
              ..headers.add('Access-Control-Allow-Origin', '*')
              ..headers.add('Content-Length', html.length.toString())
              ..add(html);
            await response.close();
          case '/model-viewer.min.js':
            // Serve the model-viewer JavaScript file.

            final code = await rootBundle
                .loadString('packages/o3d/assets/model-viewer.min.js');
            final data = utf8.encode(code);

            widget.controller?.logger?.call(
                'js is not empty: ${code.isNotEmpty} and length: ${data.length.toString()}');

            response
              ..statusCode = HttpStatus.ok
              ..headers
                  .add('Content-Type', 'application/javascript;charset=UTF-8')
              ..headers.add('Access-Control-Allow-Origin', '*')
              ..headers.add('Content-Length', data.length.toString())
              ..add(data);
            await response.close();
          case '/model':
            // Redirect to the model file URL or serve the model data.

            if (url.isAbsolute && !url.isScheme('file')) {
              await response.redirect(url);
            } else {
              final data = await (url.isScheme('file')
                  ? _readFile(url.path)
                  : _readAsset(url.path));
              if (data != null) {
                widget.controller?.logger?.call(
                    'data is not empty: ${data.isNotEmpty} and length is ${data.length}');

                response
                  ..statusCode = HttpStatus.ok
                  ..headers.add('Content-Type', 'application/octet-stream')
                  ..headers.add('Content-Length', data.lengthInBytes.toString())
                  ..headers.add('Access-Control-Allow-Origin', '*')
                  ..add(data);
              } else {
                widget.controller?.logger
                    ?.call('data is empty --------------------------------');
              }
              await response.close();
            }
          case '/favicon.ico':
            // Serve a 404 response for the favicon.ico request.

            final text = utf8.encode("Resource '${request.uri}' not found");

            widget.controller?.logger?.call(
                'favicon is not empty: ${text.isNotEmpty} and length is ${text.length.toString()}');

            response
              ..statusCode = HttpStatus.notFound
              ..headers.add('Content-Type', 'text/plain;charset=UTF-8')
              ..headers.add('Content-Length', text.length.toString())
              ..add(text);
            await response.close();
          default:
            // Handle other requests.

            if (request.uri.isAbsolute) {
              debugPrint('Redirect: ${request.uri}');
              await response.redirect(request.uri);
            } else if (request.uri.hasAbsolutePath) {
              // Some gltf models need other resources from the origin
              final pathSegments = [...url.pathSegments]..removeLast();
              final tryDestination = p.joinAll([
                url.origin,
                ...pathSegments,
                request.uri.path.replaceFirst('/', ''),
              ]);
              debugPrint('Try: $tryDestination');
              await response.redirect(Uri.parse(tryDestination));
            } else {
              debugPrint('404 with ${request.uri}');
              final text = utf8.encode("Resource '${request.uri}' not found");
              response
                ..statusCode = HttpStatus.notFound
                ..headers.add('Content-Type', 'text/plain;charset=UTF-8')
                ..headers.add('Content-Length', text.length.toString())
                ..add(text);
              await response.close();
              break;
            }
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  // Reads an asset file and returns its content as a Uint8List.
  Future<Uint8List?> _readAsset(String path) async {
    // final tempDir = await p_p.getTemporaryDirectory();
    // String tempPath = tempDir.path;
    //
    // final filePath = "$tempPath/$path";
    // print("filePathfilePath=$filePath");
    // final file = File(filePath);
    // if (file.existsSync()) {
    //   return file.readAsBytesSync();
    // } else {
    //   return null;
    // }
    /// 2
    try {
      final code = await rootBundle.load(path);

      return code.buffer.asUint8List();
    } catch (e) {
      widget.controller?.logger?.call('error in _readAsset: $e');
      return null;
    }
  }

  // Reads a file and returns its content as a Uint8List.
  Future<Uint8List> _readFile(final String path) async {
    final file = File(path);

    widget.controller?.logger
        ?.call('_readFile data exist: ${file.existsSync()}');
    return file.readAsBytes();
  }
}
