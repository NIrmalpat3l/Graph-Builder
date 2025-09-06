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
    
    // Check depth restriction (maximum 100 levels)
    int currentDepth = _getNodeDepth(selectedNode!);
    if (currentDepth >= 100) {
      // Return a dummy node to indicate failure - caller should check depth
      throw Exception('Maximum depth of 100 reached');
    }
    
    final newNode = GraphNode(
      id: _nextNodeId.toString(),
      label: _nextNodeId.toString(),
    );
    
    selectedNode!.addChild(newNode);
    _nextNodeId++;
    
    return newNode;
  }
  
  int _getNodeDepth(GraphNode node) {
    if (node == rootNode) return 1;
    
    // Find the depth by traversing from root
    return _findDepthFromRoot(rootNode, node, 1);
  }
  
  int _findDepthFromRoot(GraphNode current, GraphNode target, int currentDepth) {
    if (current == target) return currentDepth;
    
    for (var child in current.children) {
      int childDepth = _findDepthFromRoot(child, target, currentDepth + 1);
      if (childDepth != -1) return childDepth;
    }
    
    return -1; // Not found
  }
  
  bool canAddChildToSelected() {
    if (selectedNode == null) return false;
    return _getNodeDepth(selectedNode!) < 100;
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
  
  String getMaxDepthFormatted() {
    int currentDepth = rootNode.getDepth();
    return '$currentDepth/100';
  }
}
