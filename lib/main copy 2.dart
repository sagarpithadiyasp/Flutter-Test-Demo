import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text("Hover Focus Example")),
        body: const HoverImages(),
      ),
    );
  }
}

class HoverImages extends StatefulWidget {
  const HoverImages({Key? key}) : super(key: key);

  @override
  _HoverImagesState createState() => _HoverImagesState();
}

class _HoverImagesState extends State<HoverImages> {
  // To track hovered images
  final Set<int> _hoveredIndices = {};

  @override
  Widget build(BuildContext context) {
    final List<IconData> images = [
      Icons.person,
      Icons.message,
      Icons.call,
      Icons.camera,
      Icons.photo,
    ];

    return Center(
      child: Wrap(
        spacing: 20,
        children: List.generate(
          images.length,
          (index) => MouseRegion(
            onEnter: (_) {
              setState(() {
                _hoveredIndices.add(index);
              });
            },
            onExit: (_) {
              setState(() {
                _hoveredIndices.remove(index);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
              width: _hoveredIndices.contains(index) ? 60 : 80,
              height: _hoveredIndices.contains(index) ? 60 : 80,
              child: Icon(images[index], size: 50),
            ),
          ),
        ),
      ),
    );
  }
}
