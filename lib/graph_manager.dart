import 'graph_node.dart';

class GraphManager {
  late GraphNode rootNode;
  GraphNode? selectedNode;
  int _nextNodeId = 2; // Start from 2 since root is 1

  GraphManager() {
    rootNode = GraphNode(id: '1', label: '1', isSelected: true);
    selectedNode = rootNode;
  }

  String getNextNodeLabel() {
    return _nextNodeId.toString();
  }

  GraphNode addChildToSelected() {
    if (selectedNode == null) return rootNode;
    
    final newNode = GraphNode(
      id: _nextNodeId.toString(),
      label: _nextNodeId.toString(),
    );
    
    selectedNode!.addChild(newNode);
    _nextNodeId++;
    
    return newNode;
  }

  void selectNode(GraphNode node) {
    // Deselect all nodes first
    _deselectAllNodes(rootNode);
    
    // Select the new node
    node.isSelected = true;
    selectedNode = node;
  }

  void _deselectAllNodes(GraphNode node) {
    node.isSelected = false;
    for (var child in node.children) {
      _deselectAllNodes(child);
    }
  }

  bool deleteNode(GraphNode nodeToDelete) {
    if (nodeToDelete == rootNode) {
      // If deleting root, create a new root
      rootNode = GraphNode(id: '1', label: '1', isSelected: true);
      selectedNode = rootNode;
      _nextNodeId = 2;
      return true;
    }

    final parentNode = nodeToDelete.parent;
    if (parentNode != null) {
      // Remove from parent and delete all children
      nodeToDelete.removeAllChildren();
      parentNode.removeChild(nodeToDelete);
      
      // If the deleted node was selected, select its parent
      if (selectedNode == nodeToDelete) {
        selectNode(parentNode);
      }
      
      return true;
    }
    
    return false;
  }

  List<GraphNode> getAllNodes() {
    List<GraphNode> allNodes = [rootNode];
    allNodes.addAll(rootNode.getAllDescendants());
    return allNodes;
  }

  int getTotalNodeCount() {
    return getAllNodes().length;
  }

  int getMaxDepth() {
    return rootNode.getDepth();
  }
}
