import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_toastify/my_toastify.dart';

import 'demo_catalog.dart';

List<DemoSection> buildBasicDemoSections() {
  return [
    DemoSection(
      title: 'Foundations',
      description:
          'Core toast patterns that cover the most common app feedback states.',
      examples: [
        DemoExample(
          title: 'Top success snackbar',
          description: 'A compact success toast pinned to the top edge.',
          onRun: (context) {
            Toastify.show(
              context,
              title: 'Success',
              message: 'Data saved successfully.',
              type: ToastType.success,
              position: ToastPosition.top,
              style: ToastStyle.snackBar,
              duration: const Duration(seconds: 3),
              onDismiss: () => debugPrint('Top success snackbar dismissed.'),
            );
          },
        ),
        DemoExample(
          title: 'Bottom error snackbar',
          description: 'Good for destructive or blocking failures.',
          onRun: (context) {
            Toastify.show(
              context,
              title: 'Save failed',
              message: 'We could not save your latest changes.',
              type: ToastType.error,
              position: ToastPosition.bottom,
              style: ToastStyle.snackBar,
            );
          },
        ),
        DemoExample(
          title: 'Top info banner',
          description: 'Useful for announcements that should feel broader.',
          onRun: (context) {
            Toastify.show(
              context,
              title: 'System notice',
              message: 'Scheduled maintenance starts in 15 minutes.',
              type: ToastType.info,
              position: ToastPosition.top,
              style: ToastStyle.banner,
            );
          },
        ),
        DemoExample(
          title: 'Bottom warning banner',
          description: 'A stronger visual cue for attention-worthy updates.',
          onRun: (context) {
            Toastify.show(
              context,
              title: 'Connection unstable',
              message: 'Some actions may retry automatically in the background.',
              type: ToastType.warning,
              position: ToastPosition.bottom,
              style: ToastStyle.banner,
            );
          },
        ),
      ],
    ),
  ];
}
