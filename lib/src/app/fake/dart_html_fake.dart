// Defines a class for HTML elements, providing a dynamic style getter and a method to set inner HTML.
class HtmlHtmlElement {
  dynamic get style => null;

  // Sets the inner HTML of the element, optionally using a NodeValidator.
  void setInnerHtml(String html, {NodeValidator? validator}) {}
}

// A builder class for creating NodeValidators with various permissions.
class NodeValidatorBuilder extends NodeValidator {
  // Constructor for creating a common NodeValidatorBuilder.
  NodeValidatorBuilder.common();

  // Adds a custom NodeValidator to this builder.
  void add(NodeValidator validator) {}

  // Allows custom elements with specific attributes and URI policies.
  void allowCustomElement(
    String tagName, {
    UriPolicy? uriPolicy,
    Iterable<String>? attributes,
    Iterable<String>? uriAttributes,
  }) {}

  // Allows specific elements with given attributes and URI policies.
  void allowElement(
    String tagName, {
    UriPolicy? uriPolicy,
    Iterable<String>? attributes,
    Iterable<String>? uriAttributes,
  }) {}

  // Allows HTML5 elements, optionally using a URI policy.
  void allowHtml5({UriPolicy? uriPolicy}) {}

  // Allows image elements, optionally using a URI policy.
  void allowImages([UriPolicy? uriPolicy]) {}

  // Allows inline styles, optionally for a specific tag.
  void allowInlineStyles({String? tagName}) {}

  // Allows navigation elements, optionally using a URI policy.
  void allowNavigation([UriPolicy? uriPolicy]) {}

  // Determines if a specific attribute is allowed for an element.
  @override
  bool allowsAttribute(Element element, String attributeName, String value) {
    return true;
  }

  // Determines if a specific element is allowed.
  @override
  bool allowsElement(Element element) {
    return true;
  }

  // Allows SVG elements.
  void allowSvg() {}

  // Allows custom tag extensions with specific attributes and URI policies.
  void allowTagExtension(
    String tagName,
    String baseName, {
    UriPolicy? uriPolicy,
    Iterable<String>? attributes,
    Iterable<String>? uriAttributes,
  }) {}

  // Allows template elements.
  void allowTemplating() {}

  // Allows text elements.
  void allowTextElements() {}
}

// An abstract class representing an HTML element.
abstract class Element {}

// An abstract class for validating HTML nodes, providing methods to check element and attribute permissions.
abstract class NodeValidator {
  bool allowsAttribute(Element element, String attributeName, String value);

  bool allowsElement(Element element);
}

// An abstract class representing a URI policy, providing a method to check if a URI is allowed.
abstract class UriPolicy {
  bool allowsUri(String uri);
}
