import '../tiles/tile.dart';
import '../treenode.dart';

class Slice extends Tile {
  @override
  position(
      TreeNode node, double left, double top, double right, double bottom) {
    slice(node, left, top, right, bottom);
  }
}
