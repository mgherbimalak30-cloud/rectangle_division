
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class RectangleData {
  Rect rectangle;
  Color color;

  RectangleData({
    required this.rectangle,
    required this.color,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Random random = Random();

  List<RectangleData> rectangles = [];

  Color? selectedColor;
  bool useGradient = true;
  bool showBorders = true;
  double borderWidth = 1;

  Color randomColor() {
    if (selectedColor == null) {
      return Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      );
    }

    if (!useGradient) {
      return selectedColor!;
    }

    return Color.lerp(
      selectedColor!,
      Colors.white,
      random.nextDouble(),
    )!;
  }

  void divideRectangle(int index) {
    final rectangle = rectangles[index].rectangle;

    final left = rectangle.left;
    final top = rectangle.top;
    final width = rectangle.width;
    final height = rectangle.height;

    if (width > height) {
      final newWidth = width / 2;

      rectangles[index] = RectangleData(
        rectangle: Rect.fromLTWH(
          left,
          top,
          newWidth,
          height,
        ),
        color: randomColor(),
      );

      rectangles.add(
        RectangleData(
          rectangle: Rect.fromLTWH(
            left + newWidth,
            top,
            newWidth,
            height,
          ),
          color: randomColor(),
        ),
      );
    } else {
      final newHeight = height / 2;

      rectangles[index] = RectangleData(
        rectangle: Rect.fromLTWH(
          left,
          top,
          width,
          newHeight,
        ),
        color: randomColor(),
      );

      rectangles.add(
        RectangleData(
          rectangle: Rect.fromLTWH(
            left,
            top + newHeight,
            width,
            newHeight,
          ),
          color: randomColor(),
        ),
      );
    }

    setState(() {});
  }

  void resetRectangles(Size size) {
    setState(() {
      rectangles.clear();

      rectangles.add(
        RectangleData(
          rectangle: Rect.fromLTWH(
            0,
            0,
            size.width,
            size.height,
          ),
          color: randomColor(),
        ),
      );
    });
  }

  void chooseColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Choisir une couleur'),
          content: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _colorButton(null),
              _colorButton(Colors.blue),
              _colorButton(Colors.red),
              _colorButton(Colors.green),
              _colorButton(Colors.orange),
              _colorButton(Colors.purple),
              _colorButton(Colors.pink),
              _colorButton(Colors.teal),
              _colorButton(Colors.yellow),
              _colorButton(Colors.black),
            ],
          ),
        );
      },
    );
  }

  Widget _colorButton(Color? color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = color;
        });

        Navigator.pop(context);
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey,
          ),
        ),
        child: color == null
            ? const Icon(
                Icons.shuffle,
                size: 22,
              )
            : null,
      ),
    );
  }

  String colorName() {
    if (selectedColor == null) {
      return 'Aléatoire';
    }

    if (selectedColor == Colors.blue) {
      return 'Bleu';
    }

    if (selectedColor == Colors.red) {
      return 'Rouge';
    }

    if (selectedColor == Colors.green) {
      return 'Vert';
    }

    if (selectedColor == Colors.orange) {
      return 'Orange';
    }

    if (selectedColor == Colors.purple) {
      return 'Violet';
    }

    if (selectedColor == Colors.pink) {
      return 'Rose';
    }

    if (selectedColor == Colors.teal) {
      return 'Turquoise';
    }

    if (selectedColor == Colors.yellow) {
      return 'Jaune';
    }

    if (selectedColor == Colors.black) {
      return 'Noir';
    }

    return 'Couleur';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rectangles (${rectangles.length})',
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text(
                'Configuration',
                style: TextStyle(
                  fontSize: 24,
                ),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Couleur'),
              subtitle: Text(colorName()),
              onTap: chooseColor,
            ),

            SwitchListTile(
              secondary: const Icon(Icons.gradient),
              title: const Text('Dégradé'),
              value: useGradient,
              onChanged: (value) {
                setState(() {
                  useGradient = value;
                });
              },
            ),

            SwitchListTile(
              secondary: const Icon(Icons.border_all),
              title: const Text('Afficher les bordures'),
              value: showBorders,
              onChanged: (value) {
                setState(() {
                  showBorders = value;
                });
              },
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                0,
              ),
              child: Text(
                'Largeur de la bordure',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            Slider(
              value: borderWidth,
              min: 0,
              max: 5,
              divisions: 5,
              label: borderWidth.toString(),
              onChanged: showBorders
                  ? (value) {
                      setState(() {
                        borderWidth = value;
                      });
                    }
                  : null,
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Réinitialiser'),
              onTap: () {
                final size = MediaQuery.of(context).size;

                resetRectangles(
                  Size(
                    size.width,
                    size.height - kToolbarHeight,
                  ),
                );

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          if (rectangles.isEmpty) {
            rectangles.add(
              RectangleData(
                rectangle: Rect.fromLTWH(
                  0,
                  0,
                  constraints.maxWidth,
                  constraints.maxHeight,
                ),
                color: randomColor(),
              ),
            );
          }

          return Stack(
            children: [
              for (int i = 0; i < rectangles.length; i++)
                Positioned(
                  left: rectangles[i].rectangle.left,
                  top: rectangles[i].rectangle.top,
                  width: rectangles[i].rectangle.width,
                  height: rectangles[i].rectangle.height,
                  child: GestureDetector(
                    onTap: () {
                      divideRectangle(i);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: rectangles[i].color,
                        border: showBorders
                            ? Border.all(
                                color: Colors.white,
                                width: borderWidth,
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
