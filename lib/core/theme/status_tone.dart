import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Background + foreground pair used by status chips.
@immutable
class StatusTone {
  const StatusTone(this.background, this.foreground);

  final Color background;
  final Color foreground;

  StatusTone lerp(StatusTone other, double t) => StatusTone(
    Color.lerp(background, other.background, t)!,
    Color.lerp(foreground, other.foreground, t)!,
  );
}
