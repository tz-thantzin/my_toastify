# my_toastify
[![pub package](https://img.shields.io/pub/v/my_toastify.svg)](https://pub.dev/packages/my_toastify) &nbsp;
[![GitHub license](https://img.shields.io/github/license/tz-thantzin/my_toastify)](https://github.com/tz-thantzin/my_toastify/blob/main/LICENSE) &nbsp;
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20a%20Coffee-donate-yellow.svg)](https://buymeacoffee.com/devthantziq)

A beautiful, customizable **toast notification system** for Flutter.  
Supports banners, snackbars, custom icons, actions, and multiple stacking positions.

---
<img src="display/toastify.gif" alt="Toastify Demo" width="400" />

---
## 🚀 Features
- Overlay-based toast notifications
- Top or bottom stacking
- Two styles: **snackBar** & **banner**
- Optional width + alignment controls for web and desktop layouts
- Custom icons, actions, and colors
- Auto-dismiss with animation
- Multiple toasts at once
- Swipe-to-dismiss gesture
- Customize toast animation

---

## 📦 Installation
```bash
$ flutter pub add my_toastify
```

---

## 🧠 API Reference

### ToastDetails

| Property          | Type             | Default               | Description                              |
|-------------------|------------------|-----------------------|------------------------------------------|
| toastId           | String           | Unique ID generated   | Toast identifier for dismissing by ID    |
| message           | String           | —                     | Message text displayed in toast          |
| title             | String?          | null                  | Optional title above message             |
| type              | ToastType        | ToastType.info        | Defines color/icon scheme                |
| position          | ToastPosition    | ToastPosition.bottom  | Where toast appears                      |
| style             | ToastStyle       | ToastStyle.snackBar   | Toast UI layout                          |
| titleTextStyle    | TextStyle?       | textTheme.titleMedium | Custom title style                       |
| messageTextStyle  | TextStyle?       | textTheme.bodyMedium  | Custom message style                     |
| leading           | Widget?          | null                  | Optional icon widget                     |
| action            | Widget?          | null                  | Optional action button                   |
| backgroundColor   | Color?           | null                  | Override default color                   |
| borderColor       | Color?           | null                  | Adds custom border                       |
| boxShadow         | List<BoxShadow>? | null                  | Shadow customization                     |
| widthFactor       | double?          | null                  | Fraction of available width to occupy    |
| maxWidth          | double?          | null                  | Maximum toast width                      |
| horizontalAlignment | ToastHorizontalAlignment | stretch       | Horizontal placement within overlay      |
| duration          | Duration         | 3 seconds             | Auto dismiss time                        |
| onDismiss         | VoidCallback?    | null                  | Callback when toast is dismissed         |
| isAutoDismissible | bool             | true                  | Set false to prevent automatic dismissal |
| animationDuration | Duration         | 500ms                 | Duration of entrance/exit animation      |
| appearCurve       | Curve            | Curves.easeOutBack    | Curve for show animation                 |
| dismissCurve      | Curve            | Curves.easeIn         | Curve for dismiss animation              |


---

## 💡 Example Usage

```dart
import 'package:flutter/material.dart';
import 'package:toastify/my_toastify.dart';

void main() {
  runApp(const ToastifyDemo());
}

class ToastifyDemo extends StatelessWidget {
  const ToastifyDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Toastify Example')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Toastify.show(
                context,
                title: 'Success',
                message: 'Profile updated successfully!',
                type: ToastType.success,
                position: ToastPosition.top,
                style: ToastStyle.banner,
              );
            },
            child: const Text('Show Toast'),
          ),
        ),
      ),
    );
  }
}
```

---

## ⚙️ Advanced Usage Examples

### ✅ With Leading Icon

```dart
Toastify.show(
  context,
  title: 'Upload Complete',
  message: 'Your photo has been uploaded successfully.',
  type: ToastType.success,
  position: ToastPosition.bottom,
  style: ToastStyle.snackBar,
  leading: const Icon(Icons.check_circle, color: Colors.white),
);
```

---

### 🌫️ With Shadow

```dart
Toastify.show(
  context,
  title: 'File Saved',
  message: 'Document saved to local storage.',
  type: ToastType.success,
  position: ToastPosition.bottom,
  style: ToastStyle.snackBar,
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ],
);
```

---

### 🪄 With Action Button

```dart
Toastify.show(
  context,
  title: 'Undo Action',
  message: 'File deleted successfully.',
  type: ToastType.success,
  position: ToastPosition.bottom,
  style: ToastStyle.snackBar,
  action: TextButton(
    onPressed: () {
      debugPrint('Undo pressed');
    },
    child: const Text('Undo', style: TextStyle(color: Colors.white)),
  ),
);
```

---

### 💬 Without Title

```dart
Toastify.show(
  context,
  message: 'Settings have been updated.',
  type: ToastType.info,
  position: ToastPosition.bottom,
  style: ToastStyle.snackBar,
);
```

---

### 🔔 With onDismiss Callback

```dart
Toastify.show(
  context,
  title: 'Info',
  message: 'This toast will print when dismissed.',
  type: ToastType.info,
  onDismiss: () {
    debugPrint('Toast was dismissed!');
  },
);
```

---

### ⏹️ Non-Auto-Dismiss Toast with Action and dismissById

```dart
late final String toastId;
toastId = Toastify.show(
    context,
    title: 'Upload File',
    message: 'Uploading in progress...',
    type: ToastType.info,
    position: ToastPosition.bottom,
    style: ToastStyle.snackBar,
    isAutoDismissible: false,
    action: TextButton(
        onPressed: () {
            Toastify.dismissById(toastId);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Upload canceled")),
            );
        },
        child: const Text('CANCEL', style: TextStyle(color: Colors.white)),
    ),
);
```

---

### 🌐 Half-width bottom-right banner on web

```dart
Toastify.show(
  context,
  title: 'Web Layout',
  message: 'Half-width banner pinned to the bottom-right on web.',
  type: ToastType.info,
  position: ToastPosition.bottom,
  style: ToastStyle.banner,
  widthFactor: kIsWeb ? 0.5 : null,
  horizontalAlignment: kIsWeb
      ? ToastHorizontalAlignment.end
      : ToastHorizontalAlignment.stretch,
);
```

---

### 🎞️ Animation Control Examples (v1.1.0)
### Smooth Fade Animation

```dart
Toastify.show(
    context,
    title: "Smooth Animation",
    message: "Custom fade-in and fade-out animation.",
    type: ToastType.success,
    appearCurve: Curves.easeOut,
    dismissCurve: Curves.easeIn,
    animationDuration: const Duration(milliseconds: 300),
);
```

### Bounce-In Entrance

```dart
Toastify.show(
    context,
    title: "Bounce In",
    message: "This toast uses a bounce entrance.",
    type: ToastType.info,
    appearCurve: Curves.bounceOut,
    dismissCurve: Curves.easeInExpo,
    animationDuration: const Duration(milliseconds: 450),
);
```

---
## ❤️ Author
Created by **Thant Zin**

* GitHub Home: [https://github.com/tz-thantzin](https://github.com/tz-thantzin)
* Repository: [https://github.com/tz-thantzin/my_toastify](https://github.com/tz-thantzin/my_toastify)

Copyright (©️) 2025 __Thant Zin__
