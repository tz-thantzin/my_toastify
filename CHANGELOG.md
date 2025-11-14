## 0.0.1
### 🚀 Initial Release
- Introduced **Toastify**, a customizable toast notification system for Flutter.
- Added support for:
    - Overlay-based toasts with stacking and animations.
    - **Two layouts** — `snackBarStyle` and `bannerStyle`.
    - **Toast directions**: top or bottom.
    - **Toast types**: info, success, warning, error.
    - **Custom leading icons** and **action buttons**.
    - **Shadow**, **border**, and **background color** customization.
    - Swipe-to-dismiss gesture.
    - Multiple toasts displayed simultaneously.
  
## 0.0.2
- Modify Readme.md

## 0.0.3
- Modify Readme.md

## 1.0.0
### ✨ Major Update
- Added **onDismiss** callback to handle actions when a toast is dismissed.
- Introduced **isAutoDismissible** flag to control automatically disappear.
- Added manual dismissal methods:
  - **dismissById(id)** — dismiss a specific toast by its unique ID. 
  - **dismissFirst()** — dismiss the first toast in the queue. 
  - **dismissLast()** — dismiss the most recently added toast.