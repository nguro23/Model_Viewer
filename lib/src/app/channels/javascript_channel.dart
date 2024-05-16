import 'package:flutter/material.dart'; // Import the Flutter material design package
import 'package:webview_flutter/webview_flutter.dart'; // Import the WebView package for embedding web content

class JavascriptChannel {
  // Declare a new class named JavascriptChannel
  const JavascriptChannel(this.name,
      {required this.onMessageReceived}); // Constructor with two parameters: name and onMessageReceived

  final String name; // Declare a final variable to hold the name of the channel
  final ValueChanged<JavaScriptMessage>
      onMessageReceived; // Declare a final variable for the callback function to handle messages
}
