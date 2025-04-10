import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin BlockComponentWidget on Widget {
  Node get node;
  BlockComponentConfiguration get configuration;
  BlockComponentActionBuilder? get actionBuilder;
  bool get showActions;
}

class BlockComponentStatelessWidget extends StatelessWidget
    implements BlockComponentWidget {
  const BlockComponentStatelessWidget({
    super.key,
    required this.node,
    required this.configuration,
    this.showActions = false,
    this.actionBuilder,
  });

  @override
  final Node node;
  @override
  final BlockComponentConfiguration configuration;
  @override
  final BlockComponentActionBuilder? actionBuilder;
  @override
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class BlockComponentStatefulWidget extends StatefulWidget
    implements BlockComponentWidget {
  const BlockComponentStatefulWidget({
    super.key,
    required this.node,
    required this.configuration,
    this.showActions = false,
    this.actionBuilder,
  });

  @override
  final Node node;
  @override
  final BlockComponentConfiguration configuration;
  @override
  final BlockComponentActionBuilder? actionBuilder;
  @override
  final bool showActions;

  @override
  State<BlockComponentStatefulWidget> createState() =>
      _BlockComponentStatefulWidgetState();
}

class _BlockComponentStatefulWidgetState
    extends State<BlockComponentStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

mixin NestedBlockComponentStatefulWidgetMixin<
        T extends BlockComponentStatefulWidget>
    on State<T>, BlockComponentBackgroundColorMixin {
  late final editorState = Provider.of<EditorState>(context, listen: false);

  EdgeInsets get indentPadding;

  double? cachedLeft;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final left = node.selectable?.getBlockRect().left;
      if (cachedLeft != left) {
        setState(() => cachedLeft = left);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return node.children.isEmpty
        ? buildComponent(context)
        : buildComponentWithChildren(context);
  }

  Widget buildComponentWithChildren(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          left: cachedLeft,
          child: Container(
            color: backgroundColor,
          ),
        ),
        NestedListWidget(
          indentPadding: indentPadding,
          child: buildComponent(context),
          children: editorState.renderer.buildList(
            context,
            widget.node.children,
          ),
        )
      ],
    );
  }

  Widget buildComponent(BuildContext context);
}
