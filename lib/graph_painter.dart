import 'package:flutter/material.dart';
import 'dart:math';
import 'graph_node.dart';

class GraphPainter extends CustomPainter {
  final Map<String, Offset> nodePositions;
  final GraphNode rootNode;

  GraphPainter({
    required this.nodePositions,
    required this.rootNode,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawConnections(canvas, rootNode, 0);
  }

  void _drawConnections(Canvas canvas, GraphNode node, int level) {
    final nodePos = nodePositions[node.id];
    if (nodePos == null) return;

    for (var child in node.children) {
      final childPos = nodePositions[child.id];
      if (childPos != null) {
        _drawGradientConnection(canvas, nodePos, childPos, level);
        
        // Recursively draw connections for children
        _drawConnections(canvas, child, level + 1);
      }
    }
  }

  void _drawGradientConnection(Canvas canvas, Offset start, Offset end, int level) {
    // Professional corporate colors for connections
    final colors = [
      [const Color(0xFF6366F1), const Color(0xFF4F46E5)], // Indigo
      [const Color(0xFF10B981), const Color(0xFF059669)], // Emerald
      [const Color(0xFFF59E0B), const Color(0xFFD97706)], // Amber
      [const Color(0xFFEF4444), const Color(0xFFDC2626)], // Red
      [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)], // Violet
    ];
    
    final colorPair = colors[level % colors.length];
    
    // Create curved path
    final path = Path();
    path.moveTo(start.dx, start.dy);
    
    final controlPoint1 = Offset(
      start.dx + (end.dx - start.dx) * 0.5,
      start.dy + 25,
    );
    final controlPoint2 = Offset(
      start.dx + (end.dx - start.dx) * 0.5,
      end.dy - 25,
    );
    
    path.cubicTo(
      controlPoint1.dx, controlPoint1.dy,
      controlPoint2.dx, controlPoint2.dy,
      end.dx, end.dy,
    );
    
    // Create gradient paint
    final paint = Paint()
      ..shader = LinearGradient(
        colors: colorPair,
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromPoints(start, end))
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    canvas.drawPath(path, paint);
    
    // Draw arrow at the end
    _drawGradientArrow(canvas, controlPoint2, end, colorPair[1]);
  }

  void _drawGradientArrow(Canvas canvas, Offset start, Offset end, Color color) {
    const arrowLength = 10.0;
    const arrowAngle = 0.5;
    
    final direction = (end - start).direction;
    final arrowPoint1 = Offset(
      end.dx - arrowLength * cos(direction - arrowAngle),
      end.dy - arrowLength * sin(direction - arrowAngle),
    );
    final arrowPoint2 = Offset(
      end.dx - arrowLength * cos(direction + arrowAngle),
      end.dy - arrowLength * sin(direction + arrowAngle),
    );
    
    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    
    final arrowPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
      ..close();
    
    canvas.drawPath(arrowPath, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
