import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../di/form_engine_locator.dart';
import '../../models/field_option.dart';
import '../../theme/form_engine_theme.dart';

/// Shows a modal dropdown panel anchored directly below [anchorKey].
abstract final class FormEngineDropdownOverlay {
  static _DropdownOverlayLayerState? _activeState;

  static Future<void> dismissActive() async {
    await _activeState?._close();
  }

  static Future<void> show({
    required GlobalKey anchorKey,
    required List<FieldOption> options,
    required dynamic selectedValue,
    required ValueChanged<dynamic> onSelected,
    required VoidCallback onDismissed,
  }) async {
    final anchorContext = anchorKey.currentContext;
    if (anchorContext == null) return;

    final renderBox = anchorContext.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final overlay = Overlay.of(anchorContext, rootOverlay: true);
    final theme = FormEngineLocator.theme;
    final mediaQuery = MediaQuery.of(anchorContext);
    final screenSize = mediaQuery.size;

    await dismissActive();

    final anchorOffset = renderBox.localToGlobal(Offset.zero);
    final anchorSize = renderBox.size;

    const horizontalPadding = 8.0;
    const verticalGap = 2.0;
    const itemHeight = 48.0;
    const maxMenuHeight = 280.0;

    final left = anchorOffset.dx.clamp(
      horizontalPadding,
      screenSize.width - anchorSize.width - horizontalPadding,
    );
    final anchorRect =
        Rect.fromLTWH(left, anchorOffset.dy, anchorSize.width, anchorSize.height);
    final menuTop = anchorRect.bottom + verticalGap;
    final availableBelow =
        screenSize.height - menuTop - mediaQuery.padding.bottom - 16;
    final menuHeight = math.min(
      maxMenuHeight,
      math.min(availableBelow, options.length * itemHeight + 2),
    );
    final menuRect =
        Rect.fromLTWH(anchorRect.left, menuTop, anchorRect.width, menuHeight);

    final completer = Completer<void>();
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (overlayContext) {
        return _DropdownOverlayLayer(
          theme: theme,
          anchorRect: anchorRect,
          menuRect: menuRect,
          options: options,
          selectedValue: selectedValue,
          onAttach: (state) => _activeState = state,
          onDetach: () {
            if (_activeState != null) _activeState = null;
          },
          onSelected: onSelected,
          onDismissed: () {
            onDismissed();
            if (!completer.isCompleted) completer.complete();
          },
          onRemove: () => entry.remove(),
        );
      },
    );

    overlay.insert(entry);
    return completer.future;
  }
}

class _DropdownOverlayLayer extends StatefulWidget {
  const _DropdownOverlayLayer({
    required this.theme,
    required this.anchorRect,
    required this.menuRect,
    required this.options,
    required this.selectedValue,
    required this.onAttach,
    required this.onDetach,
    required this.onSelected,
    required this.onDismissed,
    required this.onRemove,
  });

  final FormEngineTheme theme;
  final Rect anchorRect;
  final Rect menuRect;
  final List<FieldOption> options;
  final dynamic selectedValue;
  final ValueChanged<_DropdownOverlayLayerState> onAttach;
  final VoidCallback onDetach;
  final ValueChanged<dynamic> onSelected;
  final VoidCallback onDismissed;
  final VoidCallback onRemove;

  @override
  State<_DropdownOverlayLayer> createState() => _DropdownOverlayLayerState();
}

class _DropdownOverlayLayerState extends State<_DropdownOverlayLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _expandAnimation;
  var _isClosing = false;
  var _didClose = false;

  @override
  void initState() {
    super.initState();
    widget.onAttach(this);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 240),
      reverseDuration: const Duration(milliseconds: 180),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    widget.onDetach();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _close({dynamic selected}) async {
    if (_isClosing || _didClose) return;
    _isClosing = true;
    await _controller.reverse();
    if (!mounted) return;
    _didClose = true;
    widget.onRemove();
    if (selected != null) {
      widget.onSelected(selected);
    }
    widget.onDismissed();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) _close();
        },
        child: Stack(
        fit: StackFit.expand,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: GestureDetector(
              onTap: _close,
              behavior: HitTestBehavior.opaque,
              child: CustomPaint(
                painter: _ScrimWithCutoutPainter(
                  cutout: widget.menuRect,
                  color: widget.theme.overlayScrimColor,
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),
          Positioned.fromRect(
            rect: widget.menuRect,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Align(
                alignment: Alignment.topCenter,
                child: SizeTransition(
                  axisAlignment: -1,
                  sizeFactor: _expandAnimation,
                  child: _DropdownMenuPanel(
                    theme: widget.theme,
                    options: widget.options,
                    selectedValue: widget.selectedValue,
                    onSelected: (value) => _close(selected: value),
                  ),
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }
}

class _ScrimWithCutoutPainter extends CustomPainter {
  _ScrimWithCutoutPainter({
    required this.cutout,
    required this.color,
  });

  final Rect cutout;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final screen = Offset.zero & size;
    final path = Path()
      ..addRect(screen)
      ..addRect(cutout);
    path.fillType = PathFillType.evenOdd;
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_ScrimWithCutoutPainter oldDelegate) {
    return oldDelegate.cutout != cutout || oldDelegate.color != color;
  }
}

class _DropdownMenuPanel extends StatelessWidget {
  const _DropdownMenuPanel({
    required this.theme,
    required this.options,
    required this.selectedValue,
    required this.onSelected,
  });

  final FormEngineTheme theme;
  final List<FieldOption> options;
  final dynamic selectedValue;
  final ValueChanged<dynamic> onSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.surfaceColor,
          borderRadius: theme.borderRadius,
          border: Border.all(color: theme.borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.14),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: theme.borderRadius,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: options.length,
            itemBuilder: (context, index) {
              final option = options[index];
              final isSelected = option.value == selectedValue;

              return InkWell(
                onTap: () => onSelected(option.value),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  color: isSelected
                      ? theme.primaryColor.withOpacity(0.08)
                      : null,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option.label,
                          style: TextStyle(
                            fontFamily: theme.fontFamily,
                            fontSize: theme.fontSizeBody,
                            color: isSelected
                                ? theme.primaryColor
                                : theme.onSurfaceColor,
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (isSelected)
                        Icon(
                          Icons.check,
                          size: 18,
                          color: theme.primaryColor,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
