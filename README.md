# simple_animated_icon

An implementation of the "Simple" transitions for the [animated icons defined in Material Design](https://material.io/design/iconography/animated-icons.html#transitions).

## Getting Started

This package provided a `SimpleAnimatedIcon` widget that can be used to animate between any two material icons.
It is compatible with the built-in `AnimatedIcon`, so it can be used wherever `AnimatedIcon` or `Icon` is used.

To use `SimpleAnimatedIcon`, first add `simple_animated_icon` to the `pubspec.yaml`:

```yaml
dependencies:
  simple_animated_icon: ^1.0.0
```

Then import the package in your app:

```dart
import 'package:simple_animated_icon/simple_animated_icon.dart';
```

Next, prepare an `AnimationController` and an animated number to indicate the animation progress:

```dart
_animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
_progress = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
```

In your `build` method, create the animated icon by providing the start and end icons, and the `_progress`:

```dart
@override
Widget build(BuildContext context) {
  return YourWidget(
    ...
    child: SimpleAnimatedIcon(
      startIcon: Icons.add,
      endIcon: Icons.close,
      progress: _progress,
    ),
  );
}
```

Finally, start or reverse the animation via the controller:
```dart
if (_isOpened) {
  _animationController.reverse();
} else {
  _animationController.forward();
}
```

See the example project for more details.


## Design Goal

The design goal of `SimpleAnimatedIcon` is to provide an alternative of the built-in `AnimatedIcon` in Flutter.
so it has the same interface as `AnimatedIcon` and can be used wherever `AnimatedIcon` or `Icon` is used.
The example project showed two use cases with `FloatingActionButton` and `IconButton`,
but it can be used in other widgets too.

Due to the above goal, `SimpleAnimatedIcon` only accepts one single animation control parameter `progress`,
leaving everything else to the consumers. This gives the consumers maximum flexibility.


