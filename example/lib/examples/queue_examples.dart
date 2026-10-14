import 'package:flutter/material.dart';
import 'package:my_toastify/my_toastify.dart';

import 'demo_catalog.dart';

List<DemoSection> buildQueueDemoSections(ToastifyController controller) => [
      DemoSection(
        title: 'Controller and queues',
        description:
            'Show notifications without a page context and control how a '
            'controller handles bursts.',
        examples: [
          DemoExample(
            title: 'Queue notifications',
            description:
                'Show three updates in order with one toast visible at a time.',
            note: 'The controller is configured with maxVisibleToasts: 1.',
            onRun: (_) => showQueuedUploadUpdates(controller),
          ),
          DemoExample(
            title: 'Dismiss queued updates',
            description:
                'Clear notifications owned by the app-level controller.',
            onRun: (_) => controller.dismissAll(),
          ),
        ],
      ),
    ];

List<DemoSection> buildV2FeatureDemoSections(ToastifyController controller) => [
      DemoSection(
        title: 'v2 notification tools',
        description:
            'Replace duplicate events, reuse visual themes, announce updates '
            'accessibly, and place toasts in corners or at center.',
        examples: [
          DemoExample(
            title: 'Deduplicate a repeated event',
            description:
                'Repeated sync updates with the same key replace the current toast.',
            onRun: (_) => showDeduplicatedSyncUpdates(controller),
          ),
          DemoExample(
            title: 'Apply a shared theme',
            description: 'Use one theme configuration across toast calls.',
            onRun: (_) => showThemedToast(controller),
          ),
          DemoExample(
            title: 'Announce to screen readers',
            description: 'Provide a clear label for live toast announcements.',
            onRun: (_) => showAccessibleToast(controller),
          ),
          DemoExample(
            title: 'Place a toast in the top-right corner',
            description: 'Pin a compact notification to a screen corner.',
            onRun: (_) => controller.show(
              title: 'Corner position',
              message: 'This toast is pinned to the top-right corner.',
              type: ToastType.info,
              style: ToastStyle.minimal,
              position: ToastPosition.topRight,
              duration: const Duration(seconds: 2),
            ),
          ),
          DemoExample(
            title: 'Center a toast',
            description:
                'Show an important update at the center of the screen.',
            onRun: (_) => controller.show(
              title: 'Centered update',
              message: 'This notification appears in the center.',
              type: ToastType.success,
              style: ToastStyle.minimal,
              position: ToastPosition.center,
              duration: const Duration(seconds: 2),
            ),
          ),
        ],
      ),
    ];

void showQueuedUploadUpdates(ToastifyController controller) {
  controller.show(
    title: 'Upload started',
    message: 'Your photos are being uploaded.',
    type: ToastType.info,
    duration: const Duration(seconds: 2),
  );
  controller.show(
    title: 'Halfway there',
    message: 'Your upload is about halfway complete.',
    type: ToastType.warning,
    duration: const Duration(seconds: 2),
  );
  controller.show(
    title: 'Upload complete',
    message: 'All photos are ready to view.',
    type: ToastType.success,
    duration: const Duration(seconds: 2),
  );
}

void showDeduplicatedSyncUpdates(ToastifyController controller) {
  for (var count = 1; count <= 3; count++) {
    controller.show(
      title: 'Syncing',
      message: '$count background sync tasks are running.',
      type: ToastType.info,
      deduplicationKey: 'background-sync',
      duration: const Duration(seconds: 2),
    );
  }
}

void showThemedToast(ToastifyController controller) {
  controller.show(
    title: 'Theme applied',
    message: 'This toast uses shared visual tokens.',
    type: ToastType.success,
    theme: const ToastifyThemeData(
      successColor: Color(0xFF286D65),
      surfaceColor: Color(0xFFF0FAF7),
      foregroundColor: Color(0xFF153D38),
      borderRadius: BorderRadius.all(Radius.circular(18)),
      boxShadow: [
        BoxShadow(
          color: Color(0x33286D65),
          blurRadius: 18,
          offset: Offset(0, 6),
        ),
      ],
    ),
    style: ToastStyle.minimal,
    duration: const Duration(seconds: 2),
  );
}

void showAccessibleToast(ToastifyController controller) {
  controller.show(
    title: 'Payment received',
    message: 'Your receipt is ready to view.',
    type: ToastType.success,
    semanticLabel: 'Payment received. Your receipt is ready to view.',
    announceToScreenReader: true,
    duration: const Duration(seconds: 2),
  );
}

void showV2FeaturePreview(ToastifyController controller, {String? feature}) {
  if (feature == 'dedupe') {
    showDeduplicatedSyncUpdates(controller);
  } else if (feature == 'theme') {
    showThemedToast(controller);
  } else if (feature == 'accessibility') {
    showAccessibleToast(controller);
  } else if (feature == 'corner') {
    controller.show(
      title: 'Corner position',
      message: 'This toast is pinned to the top-right corner.',
      type: ToastType.info,
      style: ToastStyle.minimal,
      position: ToastPosition.topRight,
      duration: const Duration(seconds: 2),
    );
  } else if (feature == 'center') {
    controller.show(
      title: 'Centered update',
      message: 'This notification appears in the center.',
      type: ToastType.success,
      style: ToastStyle.minimal,
      position: ToastPosition.center,
      duration: const Duration(seconds: 2),
    );
  } else {
    showDeduplicatedSyncUpdates(controller);
    showThemedToast(controller);
    showAccessibleToast(controller);
    showV2FeaturePreview(controller, feature: 'corner');
    showV2FeaturePreview(controller, feature: 'center');
  }
}
