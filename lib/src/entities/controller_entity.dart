import 'package:webview_flutter/webview_flutter.dart';

/// Entity class to manage a controller for a WebView.
class ControllerEntity {
  String id; // The identifier for the controller entity.
  WebViewController?
      webViewController; // The WebViewController associated with this entity.

  /// Constructor to initialize the controller entity with an ID and an optional WebViewController.
  ///
  /// [id] is a required parameter that sets the identifier for the controller entity.
  /// [webViewController] is an optional parameter that sets the WebViewController for this entity.
  ControllerEntity({required this.id, this.webViewController});
}
