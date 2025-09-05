# Graph Builder Pro

A professional Flutter application for creating and managing interactive tree-like graphs with nodes.

## Features

### Core Functionality
- **Interactive Node Creation**: Click to select nodes and add children with auto-incrementing numbers
- **Node Management**: Delete any node (except root) with cascade deletion of children
- **Visual Hierarchy**: Clean, professional tree structure with curved connecting lines
- **Auto-Centering**: Automatic view centering on the root node with smooth animations

### Professional Design
- **Corporate Dark Theme**: Modern dark UI with professional color palette
- **Material Design 3**: Latest Material Design principles for consistency
- **Smooth Animations**: Subtle scale animations for enhanced user experience
- **Responsive Layout**: Adapts to different screen sizes and orientations

## Technical Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point and theme configuration
├── graph_builder_screen.dart # Main UI and interaction logic
├── graph_manager.dart        # Business logic for graph operations
├── graph_node.dart          # Node data model
└── graph_painter.dart       # Custom painter for node connections
```

### Key Components
- **GraphManager**: Handles node creation, deletion, and selection logic
- **GraphNode**: Immutable node model with parent-child relationships
- **GraphPainter**: Custom painter for rendering curved connection lines
- **Professional UI**: Clean, corporate-style interface with Material Design

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK
- IDE with Flutter support (VS Code, Android Studio, or IntelliJ)

### Installation
1. Clone or download the project
2. Navigate to the project directory
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run
   ```

### Building for Production
```bash
# For Android
flutter build apk

# For iOS
flutter build ios

# For Web
flutter build web
```

## Usage Guide

### Basic Operations
1. **Select a Node**: Tap any node to select it (highlighted in blue)
2. **Add Child Node**: Select a parent node, then tap the green '+' button
3. **Delete Node**: Tap the red 'X' button on any node (except root)
4. **Center View**: Tap the center focus button to return to root view
5. **Reset Graph**: Tap the red refresh button to start over

### Professional Features
- **Auto-numbering**: New nodes automatically receive incrementing numbers
- **Cascade Deletion**: Deleting a node removes all its descendants
- **Smart Positioning**: Nodes are positioned using optimal tree layout algorithms
- **Professional Animations**: Smooth transitions enhance user experience

## Technical Details

### Architecture Patterns
- **State Management**: StatefulWidget with proper lifecycle management
- **Separation of Concerns**: Business logic separated from UI components
- **Immutable Data Models**: Thread-safe node structures
- **Custom Painting**: Hardware-accelerated graphics for connections

### Color Palette
- **Primary**: Indigo (#6366F1)
- **Success**: Emerald (#10B981)
- **Danger**: Red (#EF4444)
- **Background**: Dark Gray (#111827)
- **Surface**: Darker Gray (#1F2937)

### Animation System
- **Scale Animations**: Subtle zoom effects on node creation
- **Smooth Transitions**: Fluid state changes
- **Performance Optimized**: Hardware-accelerated animations

## Dependencies

### Flutter Packages
- `flutter/material.dart` - Material Design components
- `flutter/services.dart` - System UI overlay styles

### Development Tools
- Flutter SDK
- Dart SDK
- Material Design 3 theme system

## Browser Compatibility

When running on web, the application supports:
- Chrome (recommended)
- Firefox
- Safari
- Edge

## Performance Considerations

- **Efficient Rendering**: Custom painters optimize drawing performance
- **Memory Management**: Proper widget disposal and cleanup
- **Animation Performance**: Hardware acceleration for smooth animations
- **Responsive Design**: Adapts to various screen sizes

## Contributing

This project follows professional Flutter development practices:
- Clean code architecture
- Proper documentation
- Performance optimization
- Material Design guidelines

## License

This project is created for educational and professional demonstration purposes.

## Version History

- **v1.0.0**: Initial release with core functionality
- **v2.0.0**: Enhanced UI with animations and improved UX
- **v3.0.0**: Professional redesign with corporate dark theme

---

**Graph Builder Pro** - Professional tree visualization made simple.
