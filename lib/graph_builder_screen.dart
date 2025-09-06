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
    if (!graphManager.canAddChildToSelected()) {
      // Show error message when depth limit reached
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum depth of 100 levels reached!'),
          backgroundColor: Color(0xFFEF4444),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    GraphNode? newNode;
    setState(() {
      try {
        newNode = graphManager.addChildToSelected();
        _calculateNodePositions();
      } catch (e) {
        // Handle depth limit exception
        return;
      }
    });
    
    _animationController.reset();
    _animationController.forward();
    
    // Focus on the newly added node instead of centering on root
    if (newNode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusOnNode(newNode!);
      });
    }
  }

  void _focusOnNode(GraphNode node) {
    final nodePosition = nodePositions[node.id];
    if (nodePosition != null && mounted) {
      try {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;
        
        // Calculate the offset to center the specific node on screen
        final translateX = screenWidth / 2 - nodePosition.dx;
        final translateY = screenHeight / 3 - nodePosition.dy;
        
        _transformationController.value = Matrix4.identity()
          ..translate(translateX, translateY);
      } catch (e) {
        // If MediaQuery fails, don't focus
        print('Could not focus on node: $e');
      }
    }
  }

  void _goToParent() {
    final selectedNode = graphManager.selectedNode;
    if (selectedNode != null && selectedNode.parent != null) {
      setState(() {
        // Deselect current node
        selectedNode.isSelected = false;
        // Select and focus on parent
        selectedNode.parent!.isSelected = true;
        graphManager.selectedNode = selectedNode.parent;
      });
      // Focus the view on the parent node
      _focusOnNode(selectedNode.parent!);
    }
  }

  void _deleteNode(GraphNode node) {
    setState(() {
      graphManager.deleteNode(node);
      _calculateNodePositions();
    });
    
    // Don't auto-center after deleting - let user manually center if needed
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
                  // Child count indicator
                  if (node.children.isNotEmpty)
                    Positioned(
                      bottom: 5,
                      left: 25,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF10B981),
                          border: Border.all(
                            color: const Color(0xFF1F2937),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${node.children.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
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
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF374151),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF4B5563),
          width: 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: accentColor,
            size: 22,
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE5E7EB),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControlPanel() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border.all(
          color: const Color(0xFF374151),
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildControlButton(
            icon: Icons.add,
            label: 'Add Node',
            color: graphManager.canAddChildToSelected() 
                ? const Color(0xFF10B981)
                : const Color(0xFF374151),
            onPressed: graphManager.canAddChildToSelected() ? _addNode : null,
          ),
          _buildControlButton(
            icon: Icons.arrow_upward,
            label: 'Go to Parent',
            color: (graphManager.selectedNode != null && graphManager.selectedNode!.parent != null)
                ? const Color(0xFFEAB308)
                : const Color(0xFF374151),
            onPressed: (graphManager.selectedNode != null && graphManager.selectedNode!.parent != null) 
                ? _goToParent 
                : null,
          ),
          _buildControlButton(
            icon: Icons.center_focus_strong,
            label: 'Center View',
            color: const Color(0xFF6366F1),
            onPressed: _centerOnRootNode,
          ),
          _buildControlButton(
            icon: Icons.refresh,
            label: 'Reset Graph',
            color: const Color(0xFFEF4444),
            onPressed: _resetGraph,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    final isEnabled = onPressed != null;
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isEnabled ? color : const Color(0xFF374151),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isEnabled ? color.withOpacity(0.3) : const Color(0xFF4B5563),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isEnabled ? Colors.white : const Color(0xFF6B7280),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isEnabled ? Colors.white : const Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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
      backgroundColor: const Color(0xFF0F172A), // Even darker background for better separation
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
        elevation: 4, // Add elevation for separation
        shadowColor: const Color(0xFF000000),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      body: Column(
        children: [
          // Professional Info panel - Fixed header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFF1F2937),
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFF374151),
                  width: 2,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
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
                  graphManager.getMaxDepthFormatted(),
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
          // Canvas area - Clearly separated and contained
          Expanded(
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 4, right: 4, top: 4), // No bottom margin for bottom panel
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A), // Darker canvas background
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                border: Border.all(
                  color: const Color(0xFF374151),
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0xFF000000),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  boundaryMargin: EdgeInsets.zero,
                  minScale: 0.1,
                  maxScale: 3.0,
                  constrained: false,
                  panEnabled: true,
                  scaleEnabled: true,
                  clipBehavior: Clip.hardEdge, // Restrict graph to canvas only
                  child: SizedBox(
                    width: 20000, // Very large fixed width for unlimited scrolling
                    height: 20000, // Very large fixed height for unlimited scrolling
                    child: Stack(
                      clipBehavior: Clip.hardEdge, // Prevent overflow outside canvas
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
          ),
          // Bottom control panel
          _buildBottomControlPanel(),
        ],
      ),
    );
  }
}