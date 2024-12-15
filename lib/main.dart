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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Drag and Drop'),
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
  bool _isAccepted = true;
  Offset? _dragOffset;
  Offset? _dragTargetOffset;
  String _dragTargetStatus = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('DragTarget\n$_dragTargetStatus ${_dragTargetOffset ?? ''}'),
                Row(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        CheckboxListTile(
                            title: Text('Accept Drag'),
                            value: _isAccepted,
                            onChanged: (value) {
                              setState(() => _isAccepted = value!);
                            }),
                        _dragTarget(accept: _isAccepted),
                      ],
                    )),
                  ],
                ),
                SizedBox(height: 80),
                Text('Draggable${_dragOffset ?? ''}'),
                Row(
                  children: [
                    _draggable(context),
                    SizedBox(width: 16),
                    _logPressDraggable(context),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _dragTarget({required bool accept}) => DragTarget(
        onMove: (details) {
          setState(() {
            _dragTargetStatus = 'onMove';
            _dragTargetOffset = details.offset;
          });
        },
        onLeave: (details) {
          setState(() {
            _dragTargetStatus = 'onLeave: $details';
          });
        },
        onWillAcceptWithDetails: (details) {
          print('onWillAcceptWithDetails: ${details.data}');
          return accept;
        },
        onAcceptWithDetails: (details) {
          print('onAcceptWithDetails: ${details.data}');
        },
        builder: (BuildContext context, List<Object?> candidateData,
            List<dynamic> rejectedData) {
          if (candidateData.isNotEmpty) {
            final data = candidateData.join(', ');
            return Container(
              width: double.infinity,
              height: 200,
              color: Theme.of(context).colorScheme.secondary,
              child: Center(child: Text('DragTarget Accepted\n$data')),
            );
          } else if (rejectedData.isNotEmpty) {
            final data = rejectedData.join(', ');
            return Container(
              width: double.infinity,
              height: 200,
              color: Theme.of(context).colorScheme.error,
              child: Center(child: Text('DragTarget Rejected\n$data')),
            );
          } else {
            return Container(
              height: 200,
              color: Theme.of(context).colorScheme.primary,
              child: Center(child: Text('DragTarget')),
            );
          }
        },
      );

  Widget _draggable(BuildContext context) => Draggable(
        data: 'Draggable Data',
        dragAnchorStrategy: (draggable, context, position) {
          final RenderBox renderObject =
              context.findRenderObject()! as RenderBox;
          final anchorPosition = renderObject.globalToLocal(position);
          print('position: $position , anchorPosition $anchorPosition');
          return anchorPosition;
        },
        onDragStarted: () {
          print('onDragStarted');
        },
        onDragUpdate: (details) {
          setState(() {
            _dragOffset = details.localPosition;
          });
        },
        onDragEnd: (details) {
          setState(() {
            _resetData();
          });
        },
        onDragCompleted: () {
          print(
              'onDragCompleted 는 DragTarget 에서 onAcceptWithDetails 가 호출된 후에 호출됩니다.');
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          print('onDraggableCanceled 는 onDragCompleted 발생하지 않은 경우에 호출됩니다.');
        },
        // feedbackOffset: DragTarget 에 접근 하는 상대 좌표
        feedbackOffset: Offset(0, 0),
        feedback: Container(
          width: 100,
          height: 100,
          color: Colors.green.shade200,
          child: Center(
              child: Text(
            'Draggable',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          )),
        ),
        childWhenDragging: Container(
          width: 100,
          height: 100,
          color: Colors.green,
          child: Center(
              child: Text(
            'childWhenDragging',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          )),
        ),
        child: Container(
          width: 100,
          height: 100,
          color: Colors.green,
          child: Center(
              child: Text(
            'Draggable',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          )),
        ),
      );

  void _resetData() {
    _dragOffset = null;
    _dragTargetOffset = null;
    _dragTargetStatus = '';
  }

  Widget _logPressDraggable(BuildContext context) => LongPressDraggable(
        data: 'LongPressDraggable Data',
        feedback: Container(
          width: 200,
          height: 100,
          color: Colors.orange.shade200,
          child: Center(
              child: Text(
            'LongPressDraggable',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          )),
        ),
        child: Container(
          width: 200,
          height: 100,
          color: Colors.orange,
          child: Center(
              child: Text(
            'LongPressDraggable',
            style: Theme.of(context).textTheme.titleSmall,
            textAlign: TextAlign.center,
          )),
        ),
      );
}
