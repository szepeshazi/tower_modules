import 'package:flutter/material.dart';

/// A declarative overlay widget that hides the underlying imperative Flutter Overlay implementation.
/// It's important to note that the overlay will only be inserted into the widget tree on the next animation frame.
/// This is by design - in order to position the overlay relative to its parent, the parent needs to be laid out first.
/// So the overlay can't be displayed in the same build cycle as its parent.
class OverlayWidget extends StatefulWidget {
  const OverlayWidget({
    super.key,
    required this.child,
    this.parentKey,
    this.relativeOffset = Offset.zero,
    this.onDisplay,
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  // The widget to be displayed in the overlay
  final Widget child;

  // Relative offset to the parent's position
  final Offset relativeOffset;

  // Optional absolute left position on screen
  // If not null, will override the relative offset dx value
  final double? left;

  // Optional absolute top position on screen
  // If not null, will override the relative offset dy value
  final double? top;

  // Optional absolute right position on screen
  // If not null, will override the relative offset dx value
  final double? right;

  // Optional absolute bottom position on screen
  // If not null, will override the relative offset dy value
  final double? bottom;

  // The parent widget for this overlay
  // Used for relative overlay position calculation, if provided
  final GlobalKey? parentKey;

  // Once the overlay is inserted into the Overlay stack, this callback will be invoked
  final VoidCallback? onDisplay;

  @override
  State<OverlayWidget> createState() => _OverlayWidgetState();
}

class _OverlayWidgetState extends State<OverlayWidget> {
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _createOverlay());
    // This is just a placeholder, so the build method is valid and returns a widget
    // The actual overlay will be added to the tree on the next animation frame
    return const SizedBox.shrink();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  /// Adds the overlay entry to the Overlay stack
  void _createOverlay() {
    // Due to postFrameCallback, it is possible that the widget was already destroyed,
    // so we need to check mounted state before actually inserting the overlay
    if (!mounted) {
      return;
    }
    _overlayEntry?.remove();
    var targetOffset = widget.relativeOffset;
    if (widget.parentKey != null) {
      final renderBox = widget.parentKey!.currentContext?.findRenderObject();
      if (renderBox is RenderBox) {
        final position = renderBox.localToGlobal(Offset.zero);
        targetOffset = position + targetOffset;
      }
    }
    _overlayEntry = _overlayEntryBuilder(targetOffset);
    Overlay.of(context).insert(_overlayEntry!);
    widget.onDisplay?.call();
  }

  /// Positions the overlay entry
  OverlayEntry _overlayEntryBuilder(Offset offset) {
    return OverlayEntry(
      builder: (context) {
        return PositionedDirectional(
          start: (widget.left == null && widget.right == null)
              ? offset.dx
              : widget.left,
          top: (widget.top == null && widget.bottom == null)
              ? offset.dy
              : widget.top,
          end: widget.right,
          bottom: widget.bottom,
          child: widget.child,
        );
      },
    );
  }
}
