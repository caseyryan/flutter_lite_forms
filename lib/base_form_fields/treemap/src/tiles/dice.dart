import '../tiles/tile.dart';
import '../treenode.dart';

class Dice extends Tile {
  @override
  position(
    TreeNode node,
    double left,
    double top,
    double right,
    double bottom,
  ) {
    dice(node, left, top, right, bottom);
  }
}
