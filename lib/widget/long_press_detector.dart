import 'package:flutter/material.dart';

typedef void GestureLongPressWithTapDetailsCallback(
    TapDownDetails tapDownDetails);

/// Flutter's [GestureDetector] does not tap location to the GestureLongPressCallback.
/// This class does.
class LongPressDetector extends StatelessWidget {
  LongPressDetector({this.onLongPress, this.child});

  final GestureLongPressWithTapDetailsCallback onLongPress;
  final Widget child;

  // This is cheating. The tracker is final but the details are not ;)
  final TapDownDetailsTracker _detailsTracker = new TapDownDetailsTracker();

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTapDown: (TapDownDetails details) {
        _detailsTracker.tapDownDetails = details;
      },
      onLongPress: () => onLongPress(_detailsTracker.tapDownDetails),
      child: child
    );
  }
}

class TapDownDetailsTracker {
  TapDownDetails tapDownDetails;
}
