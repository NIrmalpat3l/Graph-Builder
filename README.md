# Graph Builder

A professional Flutter application for creating and managing interactive tree-like graph structures with nodes.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

## 🚀 Features

### Core Functionality
- **📝 Interactive Node Creation**: Click to select nodes and add children with auto-incrementing numbers
- **🗑️ Smart Node Management**: Delete any node (except root) with cascade deletion of children
- **🌳 Visual Hierarchy**: Clean tree structure with curved connecting lines and arrows
- **🎯 Auto-Navigation**: Automatic view centering and parent navigation
- **📊 Depth Management**: Maximum 100 levels with validation and visual feedback

### Professional Design
- **🎨 Corporate Dark Theme**: Modern dark UI with professional color palette (#0F172A background)
- **📱 Material Design 3**: Latest Material Design principles for consistency
- **✨ Smooth Animations**: Subtle scale animations for enhanced user experience
- **📐 Responsive Layout**: Adapts to different screen sizes with unlimited canvas (20,000px)

### Advanced Features
- **🔢 Child Count Indicators**: Visual badges showing number of children for each node
- **🎛️ Bottom Control Panel**: Professional control buttons with clear labels
- **⬆️ Parent Navigation**: Quick navigation to parent nodes with "Go to Parent" button
- **🎯 Smart Focus**: Intelligent view focusing with manual control override
- **📏 Depth Restrictions**: Built-in validation preventing trees deeper than 100 levels

## 🎮 How to Use

### Adding Nodes
1. **Select a Node**: Tap any node to select it (highlighted in blue)
2. **Add Child**: Click "Add Node" button in the bottom panel
3. **Auto-Numbering**: New nodes are automatically numbered sequentially

### Navigation
- **Go to Parent**: Use the yellow "Go to Parent" button to navigate up the tree
- **Center View**: Blue "Center View" button centers on the root node
- **Manual Navigation**: Pan and scroll to explore large graphs

### Node Management
- **Delete Nodes**: Click the red "×" button on any node (except root)
- **Reset Graph**: Red "Reset Graph" button resets to initial state
- **View Info**: Info panel shows current depth, total nodes, and selection

## 🛠️ Technical Architecture

### Project Structure
```
lib/
├── main.dart                 # App entry point and Material 3 theme
├── graph_builder_screen.dart # Main UI, interactions, and animations
├── graph_manager.dart        # Business logic and depth validation
├── graph_node.dart          # Node data model with parent-child relationships
└── graph_painter.dart       # Custom painter for curved connection lines
```

### Key Components
- **GraphManager**: Handles node CRUD operations with depth validation
- **GraphNode**: Immutable node model with hierarchical relationships
- **GraphPainter**: Custom painter for professional connection rendering
- **Hierarchical Positioning**: Algorithm preventing node overlaps
- **Unlimited Canvas**: 20,000×20,000px scrollable area with hard clipping

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0+)
- Dart SDK (3.0+)
- Any Flutter-supported platform (Windows, macOS, Linux, Web, Mobile)

### Installation
1. **Clone the repository**
   ```bash
   git clone https://github.com/NIrmalpat3l/Graph-Builder.git
   cd Graph-Builder
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Platform Support
- ✅ Windows Desktop
- ✅ Web (Chrome, Firefox, Edge)
- ✅ Android
- ✅ iOS
- ✅ macOS
- ✅ Linux

## 🎨 Design System

### Color Palette
- **Background**: `#0F172A` (Dark slate)
- **Panels**: `#1F2937` (Gray-800)
- **Primary**: `#6366F1` (Indigo-500)
- **Success**: `#10B981` (Emerald-500)
- **Warning**: `#EAB308` (Yellow-500)
- **Danger**: `#EF4444` (Red-500)

### UI Components
- **Nodes**: 60px circular containers with depth-based shadows
- **Connections**: Curved lines with directional arrows
- **Controls**: Bottom panel with labeled professional buttons
- **Indicators**: Child count badges and selection highlights

## 📱 Screenshots

*Add screenshots of your app here showing the graph interface, node management, and control panel*

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Nirmal Patel**
- GitHub: [@NIrmalpat3l](https://github.com/NIrmalpat3l)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design team for the design system
- Community contributors and feedback

---

**Made with ❤️ using Flutter**
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
