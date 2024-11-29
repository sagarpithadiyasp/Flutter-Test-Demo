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
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: Center(
                  child: Text(
                    'Rest of the Screen (No Dragging)',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
            Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(10),
                child: const DragHoverImages()),
          ],
        ),
      ),
    );
  }
}

class DragHoverImages extends StatefulWidget {
  const DragHoverImages({Key? key}) : super(key: key);

  @override
  _DragHoverImagesState createState() => _DragHoverImagesState();
}

class _DragHoverImagesState extends State<DragHoverImages>
    with TickerProviderStateMixin {
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
        child: Card(
          color: Colors.grey[300],
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0, left: 20),
            child: Wrap(
              spacing: 20,
              children: List.generate(
                _images.length,
                (index) {
                  return DragTarget<int>(
                    onAccept: (draggedIndex) {
                      print("log onAccept ${draggedIndex}");
                      setState(() {
                        // _moveIcon = false;
                        final draggedImage = _images.removeAt(draggedIndex);
                        _images.insert(index, draggedImage);
                      });
                    },
                    onMove: (details) {
                      // setState(() {
                      //   _moveIcon = true;
                      // });
                      // print("datasss onMove ${details.data}");
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Draggable<int>(
                        data: index,
                        onDragStarted: () {
                          print("datasss onDragStarted");
                          setState(() {
                            _moveIcon = true;
                          });
                        },
                        onDraggableCanceled: (velocity, offset) {
                          print("datasss onDraggableCanceled");
                          setState(() {
                            _moveIcon = false;
                            _hoveredIndex = null;
                          });
                        },
                        onDragEnd: (details) {
                          setState(() {
                            _moveIcon = false;
                          });
                        },
                        feedback: Icon(
                          _images[index],
                          size: 50,
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
        ),
      ),
    );
  }

  Widget _buildImageContainer(int index) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          _moveIcon = false;
          _hoveredIndex = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: _hoveredIndex == index && !_moveIcon ? 50 : 80,
        child: Row(
          children: [
            _hoveredIndex == index && _moveIcon
                ? SizedBox(width: 50)
                : Container(),
            Icon(
              _images[index],
              size: 50,
            ),
          ],
        ),
      ),
    );
  }
}
