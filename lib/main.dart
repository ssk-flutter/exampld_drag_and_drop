import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DragTarget(
              builder: (BuildContext context, List<Object?> candidateData,
                  List<dynamic> rejectedData) {
                return Container(
                  width: double.infinity,
                  height: 200,
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(child: Text('DragTaget')),
                );
              },
            ),
            Row(
              children: [
                Draggable(
                  data: 'Draggable',
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.green,
                    child: Center(child: Text('Draggable')),
                  ),
                  feedback: Container(
                    width: 100,
                    height: 100,
                    color: Colors.green,
                    child: Center(
                        child: Text(
                      'Draggable Feedback',
                      style: Theme.of(context).textTheme.titleSmall,
                    )),
                  ),
                ),
                LongPressDraggable(
                  data: 'LongPressDraggable',
                  child: Container(
                    width: 200,
                    height: 100,
                    color: Colors.orange,
                    child: Center(child: Text('LongPressDraggable')),
                  ),
                  feedback: Container(
                    width: 200,
                    height: 100,
                    color: Colors.orange,
                    child: Center(
                        child: Text('LongPressDraggable Feedback',
                            style: Theme.of(context).textTheme.titleSmall)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
