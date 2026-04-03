import 'package:flutter/foundation.dart';
import 'package:my_toastify/my_toastify.dart';

import 'demo_catalog.dart';

List<DemoSection> buildLayoutDemoSections() {
  return [
    DemoSection(
      title: 'Layout controls',
      description:
          'Examples focused on width, max width and horizontal placement.',
      examples: [
        DemoExample(
          title: 'Bottom-right half-width banner',
          description:
              'Great for desktop and web layouts where a full-width banner feels too heavy.',
          note: 'Uses widthFactor: 0.5 and horizontalAlignment.end.',
          onRun: (context) {
            Toastify.show(
              context,
              title: 'Web layout',
              message: 'Half-width banner pinned to the bottom-right corner.',
              type: ToastType.info,
              position: ToastPosition.bottom,
              style: ToastStyle.banner,
              widthFactor: kIsWeb ? 0.5 : null,
              horizontalAlignment: kIsWeb
                  ? ToastHorizontalAlignment.end
                  : ToastHorizontalAlignment.stretch,
            );
          },
        ),
        DemoExample(
          title: 'Centered 60% banner',
          description:
              'A balanced promotional or announcement layout on large screens.',
          note: 'Pairs widthFactor with center alignment.',
          onRun: (context) {
            Toastify.show(
              context,
              title: 'Release note',
              message: 'Version 2.1 is now available for all beta users.',
              type: ToastType.success,
              position: ToastPosition.top,
              style: ToastStyle.banner,
              widthFactor: 0.6,
              horizontalAlignment: ToastHorizontalAlignment.center,
            );
          },
        ),
        DemoExample(
          title: 'Right-aligned snackbar with max width',
          description:
              'Lets desktop toasts stay readable without stretching too wide.',
          note: 'Uses maxWidth instead of a fractional width.',
          onRun: (context) {
            Toastify.show(
              context,
              title: 'Queued',
              message: 'Your export job has been added to the processing queue.',
              type: ToastType.info,
              position: ToastPosition.bottom,
              style: ToastStyle.snackBar,
              maxWidth: 420,
              horizontalAlignment: ToastHorizontalAlignment.end,
            );
          },
        ),
      ],
    ),
  ];
}
