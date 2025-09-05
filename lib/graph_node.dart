class GraphNode {
  final String id;
  final String label;
  final List<GraphNode> children;
  GraphNode? parent;
  bool isSelected;

  GraphNode({
    required this.id,
    required this.label,
    this.parent,
    this.isSelected = false,
  }) : children = [];

  void addChild(GraphNode child) {
    child.parent = this;
    children.add(child);
  }

  void removeChild(GraphNode child) {
    children.remove(child);
    child.parent = null;
  }

  void removeAllChildren() {
    for (var child in children) {
      child.removeAllChildren(); // Recursively remove all descendants
      child.parent = null;
    }
    children.clear();
  }

  List<GraphNode> getAllDescendants() {
    List<GraphNode> descendants = [];
    for (var child in children) {
      descendants.add(child);
      descendants.addAll(child.getAllDescendants());
    }
    return descendants;
  }

  int getDepth() {
    if (children.isEmpty) return 0;
    return children.map((child) => child.getDepth()).reduce((a, b) => a > b ? a : b) + 1;
  }

  @override
  String toString() {
    return 'GraphNode(id: $id, label: $label, children: ${children.length})';
  }
}
