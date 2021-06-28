import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double _kHandleSize = 22.0;

const double _kToolbarScreenPadding = 8.0;
const double _kToolbarHeight = 44.0;
const double _kToolbarContentDistanceBelow = 16.0;
const double _kToolbarContentDistance = 8.0;

class _TextSelectionToolbar extends StatelessWidget {
  const _TextSelectionToolbar({
    required this.actions,
    required this.text,
  });

  final List<Widget> actions;
  final String text;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return Container(width: 0.0, height: 0.0);
    }

    return Material(
      elevation: 1.0,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: _SelectedTextProvider(
          text: text,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: actions,
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      ),
    );
  }
}

class _TextSelectionToolbarLayout extends SingleChildLayoutDelegate {
  _TextSelectionToolbarLayout(
      this.screenSize, this.globalEditableRegion, this.position);

  final Size screenSize;
  final Rect globalEditableRegion;
  final Offset position;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return constraints.loosen();
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final Offset globalPosition = globalEditableRegion.topLeft + position;

    double x = globalPosition.dx - childSize.width / 2.0;
    double y = globalPosition.dy - childSize.height;

    if (x < _kToolbarScreenPadding)
      x = _kToolbarScreenPadding;
    else if (x + childSize.width > screenSize.width - _kToolbarScreenPadding)
      x = screenSize.width - childSize.width - _kToolbarScreenPadding;

    if (y < _kToolbarScreenPadding)
      y = _kToolbarScreenPadding;
    else if (y + childSize.height > screenSize.height - _kToolbarScreenPadding)
      y = screenSize.height - childSize.height - _kToolbarScreenPadding;

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_TextSelectionToolbarLayout oldDelegate) {
    return position != oldDelegate.position;
  }
}

class _TextSelectionHandlePainter extends CustomPainter {
  _TextSelectionHandlePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color;
    final double radius = size.width / 2.0;
    canvas.drawCircle(Offset(radius, radius), radius, paint);
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, radius, radius), paint);
  }

  @override
  bool shouldRepaint(_TextSelectionHandlePainter oldPainter) {
    return color != oldPainter.color;
  }
}

class CustomTextSelectionControls extends TextSelectionControls {
  final List<ActionButton> actions;

  CustomTextSelectionControls({required this.actions});
  @override
  Size getHandleSize(double textLineHeight) =>
      const Size(_kHandleSize, _kHandleSize);

  @override
  Widget buildToolbar(
      BuildContext context,
      Rect globalEditableRegion,
      double textLineHeight,
      Offset position,
      List<TextSelectionPoint> endpoints,
      TextSelectionDelegate delegate,
      ClipboardStatusNotifier clipboardStatus,
      Offset? lastSecondaryTapDownPosition) {
    assert(debugCheckHasMediaQuery(context));
    assert(debugCheckHasMaterialLocalizations(context));

    final TextSelectionPoint startTextSelectionPoint = endpoints[0];
    final double toolbarHeightNeeded = MediaQuery.of(context).padding.top +
        _kToolbarScreenPadding +
        _kToolbarHeight +
        _kToolbarContentDistance;
    final double availableHeight =
        globalEditableRegion.top + endpoints.first.point.dy - textLineHeight;
    final bool fitsAbove = toolbarHeightNeeded <= availableHeight;
    final double y = fitsAbove
        ? startTextSelectionPoint.point.dy -
            _kToolbarContentDistance -
            textLineHeight
        : startTextSelectionPoint.point.dy +
            _kToolbarHeight +
            _kToolbarContentDistanceBelow;
    final Offset preciseMidpoint = Offset(position.dx, y);
    final selectedText = delegate.textEditingValue.selection
        .textInside(delegate.textEditingValue.text);
    return ConstrainedBox(
      constraints: BoxConstraints.tight(globalEditableRegion.size),
      child: CustomSingleChildLayout(
        delegate: _TextSelectionToolbarLayout(
          MediaQuery.of(context).size,
          globalEditableRegion,
          preciseMidpoint,
        ),
        child: _TextSelectionToolbar(
          text: selectedText,
          actions: actions,
        ),
      ),
    );
  }

  @override
  Widget buildHandle(
      BuildContext context, TextSelectionHandleType type, double textHeight) {
    final Widget handle = SizedBox(
      width: _kHandleSize,
      height: _kHandleSize,
      child: CustomPaint(
        painter: _TextSelectionHandlePainter(
            color: Theme.of(context).textSelectionHandleColor),
      ),
    );

    switch (type) {
      case TextSelectionHandleType.left:
        return Transform.rotate(
          angle: math.pi / 2.0,
          child: handle,
        );
      case TextSelectionHandleType.right:
        return handle;
      case TextSelectionHandleType.collapsed:
        return Transform.rotate(
          angle: math.pi / 4.0,
          child: handle,
        );
    }
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    switch (type) {
      case TextSelectionHandleType.left:
        return const Offset(_kHandleSize, 0);
      case TextSelectionHandleType.right:
        return Offset.zero;
      default:
        return const Offset(_kHandleSize / 2, -4);
    }
  }

  @override
  bool canSelectAll(TextSelectionDelegate delegate) {
    final TextEditingValue value = delegate.textEditingValue;
    return delegate.selectAllEnabled &&
        value.text.isNotEmpty &&
        !(value.selection.start == 0 &&
            value.selection.end == value.text.length);
  }
}

class ActionButton extends StatelessWidget {
  final String label;
  final void Function(String text)? onTap;

  const ActionButton({
    required this.label,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap != null
          ? () {
              onTap!.call(_SelectedTextProvider.of(context).text);
            }
          : null,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(label),
      ),
    );
  }
}

class _SelectedTextProvider extends StatelessWidget {
  final Widget child;
  final String text;

  const _SelectedTextProvider({
    required this.text,
    required this.child,
  });

  factory _SelectedTextProvider.of(BuildContext context) =>
      context.findAncestorWidgetOfExactType<_SelectedTextProvider>()!;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
