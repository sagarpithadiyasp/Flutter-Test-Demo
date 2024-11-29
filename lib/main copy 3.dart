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
        appBar: AppBar(title: const Text("Drag & Hover Example")),
        body: const DragHoverImages(),
      ),
    );
  }
}

class DragHoverImages extends StatefulWidget {
  const DragHoverImages({Key? key}) : super(key: key);

  @override
  _DragHoverImagesState createState() => _DragHoverImagesState();
}

class _DragHoverImagesState extends State<DragHoverImages> {
  // List of image URLs
  final List<IconData> _images = [
    Icons.person,
    Icons.message,
    Icons.call,
    Icons.camera,
    Icons.photo,
  ];

  // Tracks the index being hovered
  int? _hoveredIndex;
  bool _moveIcon = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          spacing: 20,
          children: List.generate(
            _images.length,
            (index) {
              return DragTarget<int>(
                onAccept: (draggedIndex) {
                  print("datasss onAccept ${draggedIndex}");
                  setState(() {
                    // Swap the images
                    _moveIcon = false;
                    final draggedImage = _images.removeAt(draggedIndex);
                    _images.insert(index, draggedImage);
                  });
                },
                // onWillAccept: (data) {
                //   print("data = $data");
                //   return true;
                // },
                // onLeave: (data) {
                //   setState(() {
                //     _moveIcon = false;
                //   });
                // },
                onWillAccept: (data) {
                  print("datasss onWillAccept ${data}");
                  return true;
                },
                onMove: (details) {
                  setState(() {
                    _moveIcon = true;
                  });
                  print("datasss onMove ${details.data}");
                },
                onAcceptWithDetails: (details) {
                  print("datasss onAcceptWithDetails ${details.data}");
                },
                onLeave: (data) {
                  print("datasss onLeave ${data}");
                },
                // onWillAcceptWithDetails: (details) {
                //   print("datasss onWillAcceptWithDetails ${details.data}");
                //   return false;
                // },

                builder: (context, candidateData, rejectedData) {
                  return Draggable<int>(
                    data: index,
                    feedback: Material(
                      child: Icon(_images[index], size: 50),
                    ),
                    childWhenDragging: Container(),
                    child: _buildImageContainer(index),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImageContainer(int index) {
    return MouseRegion(
      onEnter: (_) {
        print("onEnter = =$_moveIcon");
        print("datasss _hoveredIndex onEnter ${_hoveredIndex}");
        setState(() {
          _hoveredIndex = index;
        });
      },
      onExit: (_) {
        print("datasss _hoveredIndex onExit ${_hoveredIndex}");
        setState(() {
          _moveIcon = false;
          _hoveredIndex = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 200),
        curve: Curves.ease,
        // width: _hoveredIndex == index ? 50 : 80,
        height: _hoveredIndex == index && !_moveIcon ? 50 : 80,

        // decoration: BoxDecoration(
        //   border: _hoveredIndex == index
        //       ? Border.all(color: Colors.blue, width: 3)
        //       : null,
        // ),
        child: Row(
          children: [
            _hoveredIndex == index && _moveIcon
                ? SizedBox(width: 50)
                : Container(),
            Icon(
              _images[index],
              size: _hoveredIndex == index && !_moveIcon ? 80 : 50,
            ),
          ],
        ),
      ),
    );
  }
}
