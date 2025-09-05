import 'package:flutter/material.dart';
import 'graph_node.dart';
import 'graph_manager.dart';
import 'graph_painter.dart';

class GraphBuilderScreen extends StatefulWidget {
  const GraphBuilderScreen({super.key});

  @override
  State<GraphBuilderScreen> createState() => _GraphBuilderScreenState();
}

class _GraphBuilderScreenState extends State<GraphBuilderScreen>
    with TickerProviderStateMixin {
  late GraphManager graphManager;
  final Map<String, Offset> nodePositions = {};
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  final TransformationController _transformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    graphManager = GraphManager();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    _animationController.forward();
    
    // Delay the calculation to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateNodePositions();
      _centerOnRootNode();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _centerOnRootNode() {
    if (nodePositions.isNotEmpty) {
      final rootPos = nodePositions[graphManager.rootNode.id];
      if (rootPos != null) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        
        // Calculate the offset to center the root node
        final translateX = screenWidth / 2 - rootPos.dx;
        final translateY = screenHeight / 4 - rootPos.dy;
        
        _transformationController.value = Matrix4.identity()
          ..translate(translateX, translateY);
      }
    }
  }

  void _calculateNodePositions() {
    nodePositions.clear();
    _positionNodesBFS();
  }

  void _positionNodesBFS() {
    const double nodeHeight = 100.0;
    const double nodeSpacing = 120.0;
    const double startY = 150.0;
    
    // Center the root node on the screen
    final screenWidth = MediaQuery.of(context).size.width;
    final startX = screenWidth;
    
    // Use breadth-first search to position nodes level by level
    Map<int, List<GraphNode>> levelNodes = {};
    _assignLevels(graphManager.rootNode, 0, levelNodes);
    
    // Position nodes level by level
    for (int level in levelNodes.keys) {
      final nodes = levelNodes[level]!;
      final levelY = startY + level * nodeHeight;
      
      if (nodes.length == 1) {
        // Single node - center it
        nodePositions[nodes[0].id] = Offset(startX, levelY);
      } else {
        // Multiple nodes - spread them out
        final totalWidth = (nodes.length - 1) * nodeSpacing;
        final leftmostX = startX - totalWidth / 2;
        
        for (int i = 0; i < nodes.length; i++) {
          final nodeX = leftmostX + i * nodeSpacing;
          nodePositions[nodes[i].id] = Offset(nodeX, levelY);
        }
      }
    }
  }
  
  void _assignLevels(GraphNode node, int level, Map<int, List<GraphNode>> levelNodes) {
    if (!levelNodes.containsKey(level)) {
      levelNodes[level] = [];
    }
    levelNodes[level]!.add(node);
    
    for (var child in node.children) {
      _assignLevels(child, level + 1, levelNodes);
    }
  }

  void _addNode() {
    setState(() {
      graphManager.addChildToSelected();
      _calculateNodePositions();
    });
    
    _animationController.reset();
    _animationController.forward();
  }

  void _deleteNode(GraphNode node) {
    setState(() {
      graphManager.deleteNode(node);
      _calculateNodePositions();
    });
  }

  void _selectNode(GraphNode node) {
    setState(() {
      graphManager.selectNode(node);
    });
  }

  void _resetGraph() {
    setState(() {
      graphManager = GraphManager();
      _calculateNodePositions();
    });
    
    // Center on root node after reset
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerOnRootNode();
    });
  }

  Widget _buildNodeWidget(GraphNode node) {
    final position = nodePositions[node.id];
    if (position == null) return const SizedBox.shrink();

    return Positioned(
      left: position.dx - 25,
      top: position.dy - 25,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: GestureDetector(
              onTap: () => _selectNode(node),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: node.isSelected ? Colors.blue : Colors.white,
                  border: Border.all(
                    color: node.isSelected ? Colors.blue.shade700 : Colors.grey,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        node.label,
                        style: TextStyle(
                          color: node.isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (node != graphManager.rootNode)
                      Positioned(
                        top: -8,
                        right: -8,
                        child: GestureDetector(
                          onTap: () => _deleteNode(node),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.shade600,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Widget> _buildAllNodes(GraphNode node) {
    List<Widget> widgets = [_buildNodeWidget(node)];
    for (var child in node.children) {
      widgets.addAll(_buildAllNodes(child));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph Builder'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Info panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.grey.shade100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      '${graphManager.getTotalNodeCount()}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Text('Total Nodes'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      '${graphManager.getMaxDepth()}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const Text('Max Depth'),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      graphManager.selectedNode?.label ?? 'None',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const Text('Selected'),
                  ],
                ),
              ],
            ),
          ),
          // Graph area
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.grey.shade50,
              child: InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: const EdgeInsets.all(50),
                minScale: 0.1,
                maxScale: 3.0,
                constrained: false,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 3,
                  height: MediaQuery.of(context).size.height * 3,
                  child: Stack(
                    children: [
                      // Draw connections
                      CustomPaint(
                        size: Size(
                          MediaQuery.of(context).size.width * 3,
                          MediaQuery.of(context).size.height * 3,
                        ),
                        painter: GraphPainter(
                          nodePositions: nodePositions,
                          rootNode: graphManager.rootNode,
                        ),
                      ),
                      // Draw nodes
                      ..._buildAllNodes(graphManager.rootNode),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _addNode,
            backgroundColor: Colors.green,
            heroTag: 'add',
            child: const Icon(Icons.add, color: Colors.white),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _resetGraph,
            backgroundColor: Colors.red,
            heroTag: 'reset',
            child: const Icon(Icons.refresh, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
