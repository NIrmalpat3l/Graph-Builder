# Graph Builder

A Flutter app for creating and navigating tree-like graphs of nodes with an intuitive UI.

## Features

- **Root Node**: App starts with a single root node labeled "1"
- **Add Nodes**: Add child nodes to the currently selected node with incrementing numbers
- **Node Selection**: Tap any node to select it (highlighted in blue)
- **Node Deletion**: Delete nodes with a red X button (deletes all child nodes recursively)
- **Visual Hierarchy**: Clear tree visualization with curved connecting lines and arrows
- **Smooth Animations**: Elastic animations when adding new nodes
- **Information Panel**: Shows total nodes, max depth, and currently selected node
- **Scrollable Canvas**: Pan and scroll to navigate large graphs
- **Reset Function**: Reset the entire graph back to the initial state

## How to Use

1. **Adding Nodes**: 
   - Select a node by tapping on it (it will turn blue)
   - Press the green "+" floating action button to add a child node
   - New nodes are automatically numbered sequentially

2. **Deleting Nodes**:
   - Tap the red X button on any node (except root) to delete it
   - Deleting a node removes all its children recursively
   - The root node cannot be deleted directly

3. **Navigation**:
   - Scroll horizontally and vertically to navigate large graphs
   - The canvas expands as needed to accommodate growing trees

4. **Reset**:
   - Press the red refresh button to reset the entire graph

## Technical Details

- **Maximum Depth**: Supports up to 100 levels of nodes
- **Responsive UI**: Adapts to different screen sizes
- **Performance**: Efficient rendering and memory management
- **Smooth UX**: Animated transitions and intuitive controls

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── graph_builder_screen.dart # Main UI screen
├── graph_manager.dart        # Business logic for graph operations
├── graph_node.dart          # Node data model
└── graph_painter.dart       # Custom painter for connections
```

## Getting Started

This project requires Flutter to be installed. For installation instructions, visit [Flutter's official documentation](https://docs.flutter.dev/get-started/install).

### Running the App

1. Ensure Flutter is installed and configured
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the app

### Building

- **Android**: `flutter build apk`
- **iOS**: `flutter build ios`
- **Web**: `flutter build web`

## Architecture

The app follows a clean architecture pattern:

- **GraphNode**: Data model representing individual nodes
- **GraphManager**: Handles all graph operations and state management
- **GraphPainter**: Custom painter for drawing connections between nodes
- **GraphBuilderScreen**: Main UI with interactive elements

## Future Enhancements

- Save/load graph configurations
- Different node shapes and colors
- Zoom functionality
- Export graph as image
- Undo/redo operations
- Node labeling customization
