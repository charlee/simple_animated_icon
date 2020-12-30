import 'package:flutter/material.dart';
import 'package:simple_animated_icon/simple_animated_icon.dart';

void main() {
  runApp(MyApp());
}

/// Example for animated FAB.
class AnimatedFab extends StatefulWidget {
  @override
  _AnimatedFabState createState() => _AnimatedFabState();
}

class _AnimatedFabState extends State<AnimatedFab>
    with SingleTickerProviderStateMixin {
  bool _isOpened = false;
  AnimationController _animationController;
  Animation<Color> _color;
  Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            // call `build` on animation progress
            setState(() {});
          });

    var curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.0, 1.0, curve: Curves.easeOut),
    );

    _progress = Tween<double>(begin: 0.0, end: 1.0).animate(curve);
    _color = ColorTween(begin: Colors.blue, end: Colors.red).animate(curve);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (_isOpened) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    setState(() {
      _isOpened = !_isOpened;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: animate,
      backgroundColor: _color.value,
      child: SimpleAnimatedIcon(
        // startIcon, endIcon, and progress are required
        startIcon: Icons.add,
        endIcon: Icons.close,
        progress: _progress,
        // use default transition
        // transitions: [Transitions.rotate_cw],
      ),
    );
  }
}

/// Example for animated icon button.
class AnimatedIconButton extends StatefulWidget {
  @override
  _AnimatedIconButtonState createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton>
    with SingleTickerProviderStateMixin {
  bool _isOpened = false;
  AnimationController _animationController;
  Animation<double> _progress;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300))
          ..addListener(() {
            // call `build` on animation progress
            setState(() {});
          });

    _progress =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void animate() {
    if (_isOpened) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    setState(() {
      _isOpened = !_isOpened;
    });
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: animate,
        iconSize: 48.0,
        icon: SimpleAnimatedIcon(
          color: Colors.black,
          // customize icon color
          size: 48.0,
          // customize icon size
          startIcon: Icons.search,
          endIcon: Icons.mail,
          progress: _progress,

          // Multiple transitions are applied from left to right.
          // The order is important especially `slide_in_*` transitions are involved.
          // In this example, if `slide_in_left` is applied before `zoom_in`,
          // the slide in effect will be scaled by zoom_in as well, leading to unexpected effect.
          transitions: [
            Transitions.zoom_in,
            Transitions.slide_in_left
          ],
        ));
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Animated Icon Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Simple Animated Icon Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedIconButton(),
          ],
        ),
      ),
      floatingActionButton: AnimatedFab(),
    );
  }
}
