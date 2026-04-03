import 'package:flutter/material.dart';
import 'package:my_toastify/my_toastify.dart';

import 'demo_catalog.dart';

List<DemoSection> buildCustomizationDemoSections() {
  return [
    DemoSection(
      title: 'Customization',
      description:
          'Examples for richer visuals, custom actions and controlled dismissal.',
      examples: [
        DemoExample(
          title: 'Custom leading icon',
          description: 'Swap the default icon for domain-specific feedback.',
          onRun: (context) {
            Toastify.show(
              context,
              title: 'Download started',
              message: 'Your report is being prepared for offline viewing.',
              type: ToastType.info,
              position: ToastPosition.bottom,
              style: ToastStyle.snackBar,
              leading: const Icon(
                Icons.cloud_download_outlined,
                color: Colors.white,
                size: 28,
              ),
              duration: const Duration(seconds: 4),
            );
          },
        ),
        DemoExample(
          title: 'Banner with action',
          description: 'Ideal for update prompts or decision-based flows.',
          onRun: (context) {
            Toastify.show(
              context,
              title: 'Update available',
              message: 'A new version is ready to install.',
              type: ToastType.info,
              position: ToastPosition.top,
              style: ToastStyle.banner,
              leading: const Icon(
                Icons.system_update_alt_outlined,
                color: Colors.white,
              ),
              action: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Update started...')),
                  );
                },
                child: const Text(
                  'UPDATE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              duration: const Duration(seconds: 6),
            );
          },
        ),
        DemoExample(
          title: 'Border + shadow styling',
          description: 'Demonstrates visual customization without changing layout.',
          onRun: (context) {
            Toastify.show(
              context,
              title: 'Styled surface',
              message: 'This toast uses an outline and a softer elevated shadow.',
              type: ToastType.success,
              position: ToastPosition.top,
              style: ToastStyle.snackBar,
              borderColor: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.28),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
              ],
              duration: const Duration(seconds: 4),
            );
          },
        ),
        DemoExample(
          title: 'Persistent toast with cancel action',
          description:
              'Keeps the toast visible until the user takes action or you dismiss it programmatically.',
          onRun: (context) {
            late final String toastId;
            toastId = Toastify.show(
              context,
              title: 'Upload in progress',
              message: 'Large file upload is running in the background.',
              type: ToastType.info,
              position: ToastPosition.bottom,
              style: ToastStyle.snackBar,
              isAutoDismissible: false,
              action: TextButton(
                onPressed: () {
                  Toastify.dismissById(toastId);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Upload canceled')),
                  );
                },
                child: const Text(
                  'CANCEL',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          },
        ),
      ],
    ),
  ];
}
