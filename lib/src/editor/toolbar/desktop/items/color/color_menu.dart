import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

void showColorMenu(
  BuildContext context,
  EditorState editorState,
  Selection selection, {
  String? currentColorHex,
  List<ColorOption>? textColorOptions,
  List<ColorOption>? highlightColorOptions,
  required bool isTextColor,
}) {
  // Since link format is only available for single line selection,
  // the first rect(also the only rect) is used as the starting reference point for the [overlay] position
  final rect = editorState.selectionRects().first;
  OverlayEntry? overlay;

  // should abstract this logic to a method
  // ----
  final left = rect.left + 10;
  double? top;
  double? bottom;
  final offset = rect.center;
  final editorOffset = editorState.renderBox!.localToGlobal(Offset.zero);
  final editorHeight = editorState.renderBox!.size.height;
  final threshold = editorOffset.dy + editorHeight - 200;
  if (offset.dy > threshold) {
    bottom = editorOffset.dy + editorHeight - rect.top - 5;
  } else {
    top = rect.bottom + 5;
  }
  // ----

  void dismissOverlay() {
    overlay?.remove();
    overlay = null;
  }

  overlay = FullScreenOverlayEntry(
    top: top,
    bottom: bottom,
    left: left,
    builder: (context) {
      return ColorPicker(
        isTextColor: isTextColor,
        editorState: editorState,
        selectedColorHex: currentColorHex,
        colorOptions: isTextColor
            ? textColorOptions ?? generateTextColorOptions()
            : highlightColorOptions ?? generateHighlightColorOptions(),
        onSubmittedColorHex: (color) {
          isTextColor
              ? formatFontColor(
                  editorState,
                  color,
                )
              : formatHighlightColor(
                  editorState,
                  color,
                );
          dismissOverlay();
        },
        onDismiss: dismissOverlay,
      );
    },
  ).build();
  Overlay.of(context).insert(overlay!);
}
