import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import 'package:html_image/widgets/html_image_widget.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// Application itself.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Demo', home: const HomePage());
  }
}

/// [Widget] displaying the home page consisting of an image the the buttons.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

/// State of a [HomePage].
class _HomePageState extends State<HomePage> {
  final TextEditingController _controller = TextEditingController();
  String _imageUrl = '';
  bool _showOverlayBg = false;

  /// Constant id for the [img] element to identify and update.
  static const _imageId = 'htmlImageId';

  /// Toggle fullscreen based on current state of page
  void _toggleFullscreen() {
    if (web.document.fullscreen) {
      web.document.exitFullscreen();
    } else {
      web.document.documentElement?.requestFullscreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Web Image'),
          ),
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onDoubleTap: _toggleFullscreen,
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: _imageUrl.isEmpty
                                    ? SizedBox.shrink()
                                    : HtmlImageWidget(
                                        imageId: _imageId,
                                        imageUrl: _imageUrl)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration:
                                  const InputDecoration(hintText: 'Image URL'),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Update the img src as html based on input in Textfield
                              setState(() {
                                _imageUrl = _controller.text;
                                final web.Element? located =
                                    web.document.querySelector('#$_imageId');
                                if (located != null) {
                                  (located as web.HTMLImageElement).src =
                                      _imageUrl;
                                }
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                              child: Icon(Icons.arrow_forward),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 64),
                    ],
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: PopupMenuButton<int>(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                height: 36,
                child: Row(
                  children: [
                    const Text(
                      'Enter Fullscreen',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 1,
                height: 36,
                child: Row(
                  children: [
                    const Text(
                      'Exit Fullscreen',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
            offset: Offset(0, -96),
            color: Colors.white,
            elevation: 2,
            position: PopupMenuPosition.over,
            tooltip: '',
            onOpened: () {
              // Show overlay background for popup menu
              setState(() => _showOverlayBg = true);
            },
            onCanceled: () {
              // Handle closing of overlay
              setState(() => _showOverlayBg = false);
            },
            onSelected: (value) {
              // Handle enter or exit of fullscreen based on selected item and current state.
              if (value == 0 && !web.document.fullscreen) {
                web.document.documentElement?.requestFullscreen();
              }
              if (value == 1 && web.document.fullscreen) {
                web.document.exitFullscreen();
              }
              setState(() => _showOverlayBg = false);
            },
            child: FloatingActionButton(
              onPressed: null,
              child: const Icon(Icons.add),
            ),
          ),
        ),
        if (_showOverlayBg)
          GestureDetector(
            onTap: () => setState(() => _showOverlayBg = false),
            child: Container(
              color: Colors.black54,
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
            ),
          ),
      ],
    );
  }
}
