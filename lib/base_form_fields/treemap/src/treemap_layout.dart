import 'package:flutter/material.dart';
import 'package:lite_forms/base_form_fields/treemap/src/tiles/squarify.dart';

import 'tiles/tile.dart';
import 'treemap.dart';
import 'treenode.dart';

class TreeMapLayout extends StatelessWidget {
  final List<TreeNode> children;
  final Tile tile;
  final bool round;
  final Duration? duration;

  TreeMapLayout({
    required this.children,
    this.tile = const Squarify(),
    this.round = false,
    this.duration,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var treemap = TreeMap(
          root: TreeNode.node(children: children),
          size: Size(constraints.maxWidth, constraints.maxHeight),
          tile: tile,
        );

        return Stack(
          children: treemap.leaves.fold(
            [],
            (result, node) {
              final child = node.builder != null
                  ? node.builder!(context)
                  : InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                          color: node.options?.color ??
                              Theme.of(context).primaryColor,
                          border: node.options?.border ??
                              Border.all(
                                width: 1,
                                color: Colors.black,
                              ),
                        ),
                        child: node.options?.child,
                      ),
                      onTap: node.options?.onTap,
                    );

              return result
                ..add(
                  this.duration == null
                      ? Positioned(
                          top: node.top,
                          left: node.left,
                          width: node.right - node.left,
                          height: node.bottom - node.top,
                          child: child,
                        )
                      : AnimatedPositioned(
                          top: node.top,
                          left: node.left,
                          width: node.right - node.left,
                          height: node.bottom - node.top,
                          duration: duration!,
                          child: child,
                        ),
                );
            },
          ),
        );
      },
    );
  }
}
