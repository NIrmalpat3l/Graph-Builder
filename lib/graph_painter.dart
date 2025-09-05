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
    final paint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    _drawConnections(canvas, rootNode, paint);
  }

  void _drawConnections(Canvas canvas, GraphNode node, Paint paint) {
    final nodePos = nodePositions[node.id];
    if (nodePos == null) return;

    for (var child in node.children) {
      final childPos = nodePositions[child.id];
      if (childPos != null) {
        // Draw curved line from parent to child
        final path = Path();
        path.moveTo(nodePos.dx, nodePos.dy);
        
        // Create a curved path
        final controlPoint1 = Offset(
          nodePos.dx + (childPos.dx - nodePos.dx) * 0.5,
          nodePos.dy + 20,
        );
        final controlPoint2 = Offset(
          nodePos.dx + (childPos.dx - nodePos.dx) * 0.5,
          childPos.dy - 20,
        );
        
        path.cubicTo(
          controlPoint1.dx, controlPoint1.dy,
          controlPoint2.dx, controlPoint2.dy,
          childPos.dx, childPos.dy,
        );
        
        canvas.drawPath(path, paint);
        
        // Draw arrow at the end
        _drawArrow(canvas, controlPoint2, childPos, paint);
        
        // Recursively draw connections for children
        _drawConnections(canvas, child, paint);
      }
    }
  }

  void _drawArrow(Canvas canvas, Offset start, Offset end, Paint paint) {
    const arrowLength = 8.0;
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
      ..color = paint.color
      ..strokeWidth = paint.strokeWidth
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
