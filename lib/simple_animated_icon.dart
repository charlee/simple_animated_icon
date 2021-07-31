import 'dart:math' as math;

import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';

enum Transitions {
  rotate_cw,
  rotate_ccw,
  zoom_in,
  slide_in_left,
  slide_in_right,
}

class SimpleAnimatedIcon extends StatelessWidget {
  const SimpleAnimatedIcon({
    Key? key,
    required this.startIcon,
    required this.endIcon,
    required this.progress,
    this.color,
    this.size,
    this.semanticLabel,
    this.textDirection,
    this.transitions = const [Transitions.rotate_cw],
  })  : super(key: key);

  /// The animation progress for the animated icon.
  ///
  /// The value is clamped to be between 0 and 1.
  ///
  /// This determines the actual frame that is displayed.
  final Animation<double> progress;

  /// The transformations when transitioning from `startIcon` to `endIcon`.
  ///
  /// The value should be an iterable of `Transitions` values.
  /// Multiple transforms are combined from left to right.
  final Iterable<Transitions> transitions;

  /// The color to use when drawing the icon.
  ///
  /// Defaults to the current icon theme color, if any.
  final Color? color;

  /// The size of the icon in logical pixels.
  ///
  /// Icons occupy a square with width and height equal to size.
  ///
  /// Defaults to the current icon theme size.
  final double? size;

  /// The icon to display. startIcon and endIcon can be any valid material icons.
  final IconData startIcon;
  final IconData endIcon;

  /// Semantic label for the icon.
  ///
  /// Announced in accessibility modes (e.g TalkBack/VoiceOver).
  /// This label does not show in the UI.
  final String? semanticLabel;

  /// The text direction to use for rendering the icon.
  ///
  /// If this is null, the ambient `Directionality` is used instead.
  ///
  /// If the text direction is `TextDirection.rtl`, the icon will be mirrored
  /// horizontally (e.g back arrow will point right).
  final TextDirection? textDirection;

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final double iconSize = size ?? iconTheme.size ?? 10.0 ;
    final TextDirection textDirection =
        this.textDirection ?? Directionality.of(context);
    final double iconOpacity = iconTheme.opacity ?? 0.5;
    Color iconColor = color ?? iconTheme.color ?? Colors.white ;
    if (iconOpacity != 1.0)
      iconColor = iconColor.withOpacity(iconColor.opacity * iconOpacity);

    final double clampedProgress = progress.value.clamp(0.0, 1.0) as double;

    return Semantics(
      label: semanticLabel,
      child: _SimpleAnimatedIcon(
        startIcon: startIcon,
        endIcon: endIcon,
        size: iconSize,
        color: iconColor,
        progress: clampedProgress,
        transitions: transitions,
      ),
    );
  }
}

class _SimpleAnimatedIcon extends StatelessWidget {
  const _SimpleAnimatedIcon({
    Key? key,
    required this.startIcon,
    required this.endIcon,
    required this.size,
    required this.color,
    required this.progress,
    required this.transitions,
  }) : super(key: key);

  final IconData startIcon;
  final IconData endIcon;
  final double size;
  final Color color;
  final double progress;
  final Iterable<Transitions> transitions;

  @override
  Widget build(BuildContext context) {
    var moveOrigin = Matrix4.translationValues(-size / 2, -size / 2, 0.0);
    var revertOrigin = Matrix4.translationValues(size / 2, size / 2, 0.0);

    var t1 = [moveOrigin];
    var t2 = [moveOrigin];

    transitions.forEach((transition) {
      switch (transition) {
        case Transitions.rotate_cw:
          t1.add(Matrix4.rotationZ(progress * math.pi));
          t2.add(Matrix4.rotationZ((progress - 1.0) * math.pi));
          break;
        case Transitions.rotate_ccw:
          t1.add(Matrix4.rotationZ(-progress * math.pi));
          t2.add(Matrix4.rotationZ((1.0 - progress) * math.pi));
          break;
        case Transitions.zoom_in:
          t1.add(
              Matrix4.identity().scaled(1.0 - progress, 1.0 - progress, 1.0));
          t2.add(Matrix4.identity().scaled(progress, progress, 1.0));
          break;
        case Transitions.slide_in_left:
          t1.add(Matrix4.translationValues(2.0 * progress * size, 0.0, 0.0));
          t2.add(Matrix4.translationValues(
              2.0 * (progress - 1.0) * size, 0.0, 0.0));
          break;
        case Transitions.slide_in_right:
          t1.add(Matrix4.translationValues(-2.0 * progress * size, 0.0, 0.0));
          t2.add(Matrix4.translationValues(
              -2.0 * (progress - 1.0) * size, 0.0, 0.0));
          break;
        default:
          break;
      }
    });

    t1.add(revertOrigin);
    t2.add(revertOrigin);

    var transform1 = t1.reversed.reduce((value, element) => value * element);
    var transform2 = t2.reversed.reduce((value, element) => value * element);

    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 1.0 - progress,
          child: Transform(
            transform: transform1,
            child: Icon(startIcon, size: size, color: color),
          ),
        ),
        Opacity(
          opacity: progress,
          child: Transform(
            transform: transform2,
            child: Icon(endIcon, size: size, color: color),
          ),
        ),
      ],
    );
  }
}