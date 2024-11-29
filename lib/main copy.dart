import 'package:flutter/material.dart';

/// Entrypoint of the application.
void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (e) {
              return Container(
                key: ValueKey(e),
                constraints: const BoxConstraints(minWidth: 48),
                height: 48,
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.primaries[e.hashCode % Colors.primaries.length],
                ),
                child: Center(child: Icon(e, color: Colors.white)),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// Dock of the draggable [items].
class Dock extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [IconData] items to put in this [Dock].
  final List<IconData> items;

  /// Builder building the provided [IconData] item.
  final Widget Function(IconData) builder;

  @override
  State<Dock> createState() => _DockState();
}

/// State of the [Dock] used to manage dragging and dropping.
class _DockState extends State<Dock> {
  /// [IconData] items being manipulated.
  late final List<IconData> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          // The upper part of the screen remains static
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
          // The bottom part of the screen contains the dock
          Container(
            height: 100, // The bottom part for draggable icons
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _items.asMap().entries.map((entry) {
                    final child = widget.builder(entry.value);
                    return Draggable<IconData>(
                      data: entry.value,
                      feedback: Material(
                        color: Colors.transparent,
                        child: Container(
                          height: 48,
                          width: 48,
                          color: Colors
                              .primaries[entry.key % Colors.primaries.length]
                              .withOpacity(0.6),
                          child: Center(
                            child: Icon(entry.value, color: Colors.white),
                          ),
                        ),
                      ),
                      childWhenDragging:
                          Container(), // Remove item when dragging
                      child: DragTarget<IconData>(
                        onAccept: (data) {
                          setState(() {
                            final oldIndex = _items.indexOf(data);
                            final newIndex = entry.key;

                            if (oldIndex != newIndex) {
                              _items.removeAt(oldIndex);
                              _items.insert(newIndex, data);
                            }
                          });
                        },
                        onWillAccept: (data) {
                          print("Data = $data");
                          return true;
                        },
                        onMove: (details) {
                          // print("Checksp ${details.data}");
                        },
                        builder: (context, candidateData, rejectedData) {
                          print("candidateData $candidateData");
                          print("rejectedData $rejectedData");
                          return Container(
                            height: 100,
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: candidateData.isNotEmpty
                                  ? Colors.green.withOpacity(0.2)
                                  : Colors
                                      .transparent, // Show black when hovering
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                candidateData.isNotEmpty
                                    ? SizedBox(
                                        width: 20,
                                      )
                                    : Container(),
                                child,
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
