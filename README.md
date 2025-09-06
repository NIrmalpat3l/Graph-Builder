# 🌳 Graph Builder

> A professional Flutter application for creating and managing interactive tree-like graph structures

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

</div>

---

## ✨ Features

<table>
<tr>
<td width="50%">

### 🎯 Core Features
- 📝 **Interactive Node Creation** - Click to select and add child nodes
- 🗑️ **Smart Node Management** - Delete nodes with cascade deletion
- 🌳 **Visual Hierarchy** - Clean tree structure with connecting lines
- 🎯 **Auto-Navigation** - Parent navigation and auto-centering
- 📊 **Depth Control** - Maximum 100 levels with validation

</td>
<td width="50%">

### 🎨 Professional Design
- � **Corporate Dark Theme** - Modern professional interface
- 📱 **Material Design 3** - Latest design principles
- ✨ **Smooth Animations** - Enhanced user experience
- 📐 **Unlimited Canvas** - 20,000×20,000px scrollable area
- 🔢 **Visual Indicators** - Child count badges and selection highlights

</td>
</tr>
</table>

---

## 🚀 Quick Start

### Prerequisites
```bash
Flutter SDK 3.0+
Dart SDK 3.0+
```

### Installation
```bash
# Clone the repository
git clone https://github.com/NIrmalpat3l/Graph-Builder.git
cd Graph-Builder

# Install dependencies
flutter pub get

# Run the application
flutter run
```

### Platform Support
| Platform | Status |
|----------|--------|
| 🖥️ Windows | ✅ Supported |
| � Web | ✅ Supported |
| 📱 Android | ✅ Supported |
| 🍎 iOS | ✅ Supported |
| �️ macOS | ✅ Supported |
| 🐧 Linux | ✅ Supported |

---

## 🎮 How to Use

### 1. Adding Nodes
- **Select a Node**: Tap any node (highlighted in blue)
- **Add Child**: Click "Add Node" in bottom panel
- **Auto-Numbering**: Sequential numbering automatically applied

### 2. Navigation Controls
| Button | Function | Color |
|--------|----------|-------|
| ➕ Add Node | Creates child node | 🟢 Green |
| ⬆️ Go to Parent | Navigate to parent | 🟡 Yellow |
| 🎯 Center View | Focus on root | 🔵 Blue |
| 🔄 Reset Graph | Clear all nodes | 🔴 Red |

### 3. Node Management
- **Delete**: Click red "×" button (cascades to children)
- **Select**: Tap any node to highlight and select
- **Navigate**: Use scroll/pan for large graphs

---


</div>

### 📁 Project Structure
```
lib/
├── 🚀 main.dart                 # App entry point & Material 3 theme
├── 🖥️ graph_builder_screen.dart # Main UI & interactions
├── 🧠 graph_manager.dart        # Business logic & validation
├── 📊 graph_node.dart          # Node data model
└── 🎨 graph_painter.dart       # Connection line renderer
```

### 🔧 Key Components
| Component | Responsibility |
|-----------|----------------|
| **GraphManager** | Node CRUD operations & depth validation |
| **GraphNode** | Immutable node model with relationships |
| **GraphPainter** | Custom painter for curved connections |
| **Positioning Algorithm** | Prevents node overlaps |
| **Unlimited Canvas** | 20K×20K scrollable area |

---

## 🎨 Design System

### Color Palette
```css
Background: #0F172A  /* Dark slate */
Panels:     #1F2937  /* Gray-800 */
Primary:    #6366F1  /* Indigo-500 */
Success:    #10B981  /* Emerald-500 */
Warning:    #EAB308  /* Yellow-500 */
Danger:     #EF4444  /* Red-500 */
```

### UI Specifications
- **Node Size**: 60px circular containers
- **Animations**: Elastic scale transitions
- **Typography**: Material Design 3 text styles
- **Shadows**: Depth-based elevation system

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork** the repository
2. **Create** feature branch (`git checkout -b feature/AmazingFeature`)
3. **Commit** changes (`git commit -m 'Add AmazingFeature'`)
4. **Push** to branch (`git push origin feature/AmazingFeature`)
5. **Open** a Pull Request

---

## 📄 License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### 👤 Author
**Nirmal Patel**  
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/NIrmalpat3l)

---

**Made with ❤️ using Flutter**

</div>

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
