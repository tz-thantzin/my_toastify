import 'package:flutter/material.dart';
import 'package:my_toastify/my_toastify.dart';

void main() => runApp(const ToastifyDemoApp());

class ToastifyDemoApp extends StatelessWidget {
  const ToastifyDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastify Demo',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const ToastDemoPage(),
    );
  }
}

class ToastDemoPage extends StatelessWidget {
  const ToastDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Toastify Demo')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ Basic Toast (Top Snackbar)
              ElevatedButton(
                onPressed: () {
                  Toastify.show(
                    context,
                    title: "Success",
                    message: "Data saved successfully!",
                    type: .success,
                    position: .top,
                    style: .snackBarStyle,
                    duration: const Duration(seconds: 3),
                    onDismiss: () {
                      debugPrint("Toast dismissed!");
                    },
                  );
                },
                child: const Text("Show Top Snackbar Toast"),
              ),

              const SizedBox(height: 20),

              // ✅ Basic Toast (Bottom Snackbar)
              ElevatedButton(
                onPressed: () {
                  Toastify.show(
                    context,
                    title: "Failed",
                    message: "Failed to save data!",
                    type: .error,
                    position: .bottom,
                    style: .snackBarStyle,
                    duration: const Duration(seconds: 3),
                  );
                },
                child: const Text("Show Bottom Snackbar Toast"),
              ),

              const SizedBox(height: 20),

              // ✅ Banner-style bottom toast
              ElevatedButton(
                onPressed: () {
                  Toastify.show(
                    context,
                    message: "New message received",
                    type: .info,
                    position: .bottom,
                    style: .bannerStyle,
                  );
                },
                child: const Text("Show Banner Toast at Bottom"),
              ),

              const SizedBox(height: 20),

              // ✅ Banner-style top toast
              ElevatedButton(
                onPressed: () {
                  Toastify.show(
                    context,
                    message: "New message received",
                    type: .info,
                    position: .top,
                    style: .bannerStyle,
                  );
                },
                child: const Text("Show Banner Toast on Top"),
              ),

              const Divider(height: 40, thickness: 1),

              // ✅ Toast with custom leading icon
              ElevatedButton(
                onPressed: () {
                  Toastify.show(
                    context,
                    title: "Download",
                    message: "Your file has started downloading",
                    type: .info,
                    position: .bottom,
                    style: .snackBarStyle,
                    leading: const Icon(
                      Icons.cloud_download_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    duration: const Duration(seconds: 4),
                  );
                },
                child: const Text("Show Toast with Custom Leading Icon"),
              ),

              const SizedBox(height: 20),

              // ✅ Toast with action button
              ElevatedButton(
                onPressed: () {
                  Toastify.show(
                    context,
                    title: "Undo Delete",
                    message: "Your file was deleted.",
                    type: .warning,
                    position: .bottom,
                    style: .snackBarStyle,
                    action: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Undo Clicked")),
                        );
                      },
                      child: const Text(
                        "UNDO",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    duration: const Duration(seconds: 5),
                  );
                },
                child: const Text("Show Toast with Action Button"),
              ),

              const SizedBox(height: 20),

              // ✅ Toast with custom leading + action together
              ElevatedButton(
                onPressed: () {
                  Toastify.show(
                    context,
                    title: "Update Available",
                    message: "A new version is ready to install.",
                    type: .info,
                    position: .top,
                    style: .bannerStyle,
                    leading: const Icon(
                      Icons.system_update_alt_outlined,
                      color: Colors.white,
                    ),
                    action: TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Update started...")),
                        );
                      },
                      child: const Text(
                        "UPDATE",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    duration: const Duration(seconds: 6),
                  );
                },
                child: const Text("Show Toast with Leading + Action"),
              ),

              const Divider(height: 40, thickness: 1),

              // ✅ Toast with custom border color
              ElevatedButton(
                onPressed: () {
                  Toastify.show(
                    context,
                    title: "Custom Border",
                    message: "This toast has a white border outline.",
                    type: .info,
                    position: .bottom,
                    style: .snackBarStyle,
                    borderColor: Colors.white,
                    duration: const Duration(seconds: 4),
                  );
                },
                child: const Text("Show Toast with Border Color"),
              ),

              const SizedBox(height: 20),

              // ✅ Toast with custom shadow
              ElevatedButton(
                onPressed: () {
                  Toastify.show(
                    context,
                    title: "Custom Shadow",
                    message: "This toast has a custom soft shadow.",
                    type: .success,
                    position: .top,
                    style: .snackBarStyle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 20,
                        spreadRadius: 4,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    duration: const Duration(seconds: 4),
                  );
                },
                child: const Text("Show Toast with Custom Shadow"),
              ),

              const Divider(height: 40, thickness: 1),
              // ✅ Toast without auto-dismiss and cancelable via action button
              ElevatedButton(
                onPressed: () {
                  late final String toastId;
                  // Show toast without auto-dismiss
                  toastId = Toastify.show(
                    context,
                    title: "Upload File",
                    message: "Uploading in progress...",
                    type: .info,
                    position: .bottom,
                    style: .snackBarStyle,
                    isAutoDismissible: false,
                    action: TextButton(
                      onPressed: () {
                        // Dismiss this toast by its ID
                        Toastify.dismissById(toastId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Upload canceled")),
                        );
                      },
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                child: const Text("Show Non-Auto-Dismiss Toast with Action"),
              ),

              const SizedBox(height: 20),

              // ✅ Toast without auto-dismiss and cancelable via action button
              ElevatedButton(
                onPressed: () {
                  late final String toastId;
                  // Show toast without auto-dismiss
                  toastId = Toastify.show(
                    context,
                    title: "Upload File",
                    message: "Uploading in progress...",
                    type: .info,
                    position: .top,
                    style: .bannerStyle,
                    isAutoDismissible: false,
                    action: TextButton(
                      onPressed: () {
                        // Dismiss this toast by its ID
                        Toastify.dismissById(toastId);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Upload canceled")),
                        );
                      },
                      child: const Text(
                        "CANCEL",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Show Non-Auto-Dismiss Banner Toast with Action",
                ),
              ),

              const Divider(height: 40, thickness: 1),

              // ❌ Message shorter than 5 chars
              ElevatedButton(
                onPressed: () {
                  try {
                    Toastify.show(
                      context,
                      message: "Hi", // Only 2 characters -> triggers exception
                      type: .info,
                      position: .bottom,
                      style: .snackBarStyle,
                    );
                  } catch (e) {
                    debugPrint("Exception:: ${e.toString()}");
                    if (e is ToastifyException) {
                      debugPrint("Toastify error caught:: ${e.message}");

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error: ${e.message}"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      rethrow;
                    }
                  }
                },
                child: const Text("Show Invalid Message (Length < 5)"),
              ),

              const Divider(height: 40, thickness: 1),

              ElevatedButton(
                onPressed: () {
                  Toastify.show(
                    context,
                    title: "Animated",
                    message: "Custom animation applied!",
                    type: .info,
                    position: .bottom,
                    style: .snackBarStyle,
                    appearCurve: Curves.decelerate,
                    dismissCurve: Curves.easeInCubic,
                    animationDuration: const Duration(milliseconds: 500),
                  );
                },
                child: const Text("Show Animated Toast"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
