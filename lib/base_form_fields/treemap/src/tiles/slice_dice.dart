import '../tiles/tile.dart';
import '../treenode.dart';

class SliceDice extends Tile {
  @override
  position(
      TreeNode node, double left, double top, double right, double bottom) {
    (node.depth & 1 > 0 ? slice : dice)(node, left, top, right, bottom);
  }
}
