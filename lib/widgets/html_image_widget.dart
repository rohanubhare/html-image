import 'package:flutter/widgets.dart';
import 'dart:ui_web' as ui;
import 'package:web/web.dart' as web;

class HtmlImageWidget extends StatelessWidget {
  /// Registers a viewFactory function for HTML `img` viewType and
  /// adds it to the widget tree.
  HtmlImageWidget({
    super.key,
    required this.imageId,
    required this.imageUrl,
  }) {
    /// Register [img] viewType function as being created by the given [viewFactory]
    /// and set default image attributes.
    ui.platformViewRegistry.registerViewFactory('htmlimageview', (int viewId) {
      var element = web.HTMLImageElement();
      element.id = imageId;
      element.src = imageUrl;
      element.style.height = '100%';
      element.style.width = '100%';
      element.style.objectFit = 'contain';
      return element;
    });
  }

  /// Image Id to identify and update the [img] element in HTML
  final String imageId;

  /// Image source to load image in src attribute of [img]
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    /// Attach the registered viewType to widget tree as an html object
    return HtmlElementView(viewType: 'htmlimageview');
  }
}
