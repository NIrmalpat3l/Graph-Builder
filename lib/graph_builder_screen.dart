import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    
    // Initialize animation controllers
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    // Initialize animations
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    // Start animations
    _animationController.forward();
    
    // Calculate initial positions immediately
    _calculateNodePositions();
    
    // Delay the centering to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
    if (nodePositions.isNotEmpty && mounted) {
      try {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        
        // Calculate the center of all nodes for better centering
        double minX = double.infinity;
        double maxX = double.negativeInfinity;
        double minY = double.infinity;
        double maxY = double.negativeInfinity;
        
        for (final pos in nodePositions.values) {
          minX = minX < pos.dx ? minX : pos.dx;
          maxX = maxX > pos.dx ? maxX : pos.dx;
          minY = minY < pos.dy ? minY : pos.dy;
          maxY = maxY > pos.dy ? maxY : pos.dy;
        }
        
        // Calculate the center of the bounding box
        final centerX = (minX + maxX) / 2;
        final centerY = (minY + maxY) / 2;
        
        // Calculate the offset to center the graph on screen
        // Since our canvas is 20000px, we need to offset from that coordinate system
        final translateX = screenWidth / 2 - centerX;
        final translateY = screenHeight / 3 - centerY;
        
        _transformationController.value = Matrix4.identity()
          ..translate(translateX, translateY);
      } catch (e) {
        // If MediaQuery fails, use default centering
        _transformationController.value = Matrix4.identity()
          ..translate(-9500.0, -100.0); // Rough center for large canvas
      }
    }
  }

  void _calculateNodePositions() {
    nodePositions.clear();
    _positionNodesBFS();
    
    // Ensure root node is always positioned
    if (!nodePositions.containsKey(graphManager.rootNode.id)) {
      nodePositions[graphManager.rootNode.id] = const Offset(10000.0, 300.0); // Center of large canvas
    }
  }

  void _positionNodesBFS() {
    const double startY = 300.0;
    const double startX = 10000.0; // Center of the 20000px wide canvas
    
    // Use hierarchical positioning instead of breadth-first
    _positionNodeHierarchically(graphManager.rootNode, startX, startY);
  }
  
  void _positionNodeHierarchically(GraphNode node, double parentX, double parentY) {
    // Position the current node
    nodePositions[node.id] = Offset(parentX, parentY);
    
    // If this node has children, position them below it
    if (node.children.isNotEmpty) {
      const double verticalSpacing = 120.0;
      final childY = parentY + verticalSpacing;
      
      // Calculate required width for each child's subtree
      List<double> subtreeWidths = [];
      for (var child in node.children) {
        subtreeWidths.add(_calculateSubtreeWidth(child));
      }
      
      // Calculate positions to avoid overlaps
      List<double> childPositions = _calculateNonOverlappingPositions(
        parentX, 
        subtreeWidths,
        node.children.length
      );
      
      // Position each child at calculated position
      for (int i = 0; i < node.children.length; i++) {
        _positionNodeHierarchically(node.children[i], childPositions[i], childY);
      }
    }
  }
  
  double _calculateSubtreeWidth(GraphNode node) {
    if (node.children.isEmpty) {
      return 160.0; // Increased base width for single nodes
    }
    
    // Calculate total width needed for all children
    double totalChildWidth = 0;
    for (var child in node.children) {
      totalChildWidth += _calculateSubtreeWidth(child);
    }
    
    // Add spacing between children subtrees
    double spacingWidth = (node.children.length - 1) * 80.0; // Increased spacing between subtrees
    
    // Return the maximum of: single node width OR total children width
    double calculatedWidth = totalChildWidth + spacingWidth;
    return calculatedWidth > 160.0 ? calculatedWidth : 160.0;
  }
  
  List<double> _calculateNonOverlappingPositions(double parentX, List<double> subtreeWidths, int childCount) {
    List<double> positions = [];
    
    if (childCount == 1) {
      // Single child: position directly below parent
      positions.add(parentX);
    } else {
      // Calculate total width needed
      double totalWidth = subtreeWidths.reduce((a, b) => a + b);
      
      // Start from the leftmost position
      double currentX = parentX - totalWidth / 2;
      
      // Position each child
      for (int i = 0; i < childCount; i++) {
        // Place child at center of its allocated width
        positions.add(currentX + subtreeWidths[i] / 2);
        // Move to next position
        currentX += subtreeWidths[i];
      }
    }
    
    return positions;
  }

  void _addNode() {
    setState(() {
      graphManager.addChildToSelected();
      _calculateNodePositions();
    });
    
    _animationController.reset();
    _animationController.forward();
    
    // Auto-center view after adding node
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerOnRootNode();
    });
  }

  void _deleteNode(GraphNode node) {
    setState(() {
      graphManager.deleteNode(node);
      _calculateNodePositions();
    });
    
    // Auto-center view after deleting node
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerOnRootNode();
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
      left: position.dx - 35, // Increased padding to accommodate delete button
      top: position.dy - 35,  // Increased padding to accommodate delete button
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          final isSelected = node.isSelected;
          
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: SizedBox(
              width: 70, // Increased container size
              height: 70,
              child: Stack(
                children: [
                  // Main node widget
                  Positioned(
                    left: 5,
                    top: 5,
                    child: GestureDetector(
                      onTap: () => _selectNode(node),
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected 
                              ? const Color(0xFF6366F1)
                              : const Color(0xFF374151),
                          border: Border.all(
                            color: isSelected 
                                ? const Color(0xFF4F46E5)
                                : const Color(0xFF4B5563),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected 
                                  ? const Color(0xFF6366F1).withOpacity(0.3)
                                  : const Color(0xFF000000).withOpacity(0.2),
                              blurRadius: isSelected ? 12 : 6,
                              offset: const Offset(0, 4),
                              spreadRadius: isSelected ? 1 : 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            node.label,
                            style: TextStyle(
                              color: isSelected 
                                  ? Colors.white 
                                  : const Color(0xFFE5E7EB),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Professional delete button - now positioned within the larger container
                  if (node != graphManager.rootNode)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _deleteNode(node),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFEF4444),
                            border: Border.all(
                              color: const Color(0xFF1F2937),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFEF4444).withOpacity(0.3),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfessionalInfoCard(String value, String label, IconData icon, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF374151),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF4B5563),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: accentColor,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        toolbarHeight: 48, // Make AppBar smaller
        title: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: const Color(0xFF6366F1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.hub,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Graph Builder Pro',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1F2937),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: [
          // Professional Info panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFF1F2937),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF374151),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildProfessionalInfoCard(
                  '${graphManager.getTotalNodeCount()}',
                  'Total Nodes',
                  Icons.account_tree_outlined,
                  const Color(0xFF6366F1),
                ),
                _buildProfessionalInfoCard(
                  '${graphManager.getMaxDepth()}',
                  'Depth Level',
                  Icons.layers_outlined,
                  const Color(0xFF10B981),
                ),
                _buildProfessionalInfoCard(
                  graphManager.selectedNode?.label ?? 'None',
                  'Selected',
                  Icons.radio_button_checked_outlined,
                  const Color(0xFFF59E0B),
                ),
              ],
            ),
          ),
          // Enhanced Graph area
          Expanded(
            child: Container(
              width: double.infinity,
              color: const Color(0xFF111827), // Professional dark background
              child: InteractiveViewer(
                transformationController: _transformationController,
                boundaryMargin: EdgeInsets.zero,
                minScale: 0.1,
                maxScale: 3.0,
                constrained: false,
                panEnabled: true,
                scaleEnabled: true,
                clipBehavior: Clip.none,
                // Create unlimited canvas by making it extremely large
                child: SizedBox(
                  width: 20000, // Very large fixed width for unlimited scrolling
                  height: 20000, // Very large fixed height for unlimited scrolling
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // Draw connections
                      CustomPaint(
                        size: const Size(20000, 20000), // Match the large canvas size
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
          // Professional Add Node Button
          FloatingActionButton(
            onPressed: graphManager.selectedNode != null ? _addNode : null,
            backgroundColor: graphManager.selectedNode != null 
                ? const Color(0xFF10B981)
                : const Color(0xFF374151),
            foregroundColor: graphManager.selectedNode != null 
                ? Colors.white 
                : const Color(0xFF6B7280),
            elevation: graphManager.selectedNode != null ? 6 : 2,
            heroTag: 'add',
            child: const Icon(Icons.add, size: 28),
          ),
          const SizedBox(height: 16),
          // Professional Center View Button
          FloatingActionButton(
            onPressed: _centerOnRootNode,
            backgroundColor: const Color(0xFF6366F1),
            foregroundColor: Colors.white,
            elevation: 6,
            heroTag: 'center',
            child: const Icon(Icons.center_focus_strong, size: 28),
          ),
          const SizedBox(height: 16),
          // Professional Reset Button
          FloatingActionButton(
            onPressed: _resetGraph,
            backgroundColor: const Color(0xFFEF4444),
            foregroundColor: Colors.white,
            elevation: 6,
            heroTag: 'reset',
            child: const Icon(Icons.refresh, size: 28),
          ),
        ],
      ),
    );
  }
}