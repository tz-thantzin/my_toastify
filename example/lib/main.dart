import 'package:flutter/material.dart';
import 'package:my_toastify/my_toastify.dart';

import 'examples/basic_examples.dart';
import 'examples/customization_examples.dart';
import 'examples/demo_catalog.dart';
import 'examples/layout_examples.dart';
import 'examples/queue_examples.dart';

void main() => runApp(const ToastifyDemoApp());

class ToastifyDemoApp extends StatefulWidget {
  const ToastifyDemoApp({super.key});

  @override
  State<ToastifyDemoApp> createState() => _ToastifyDemoAppState();
}

class _ToastifyDemoAppState extends State<ToastifyDemoApp> {
  final _toastController = ToastifyController(
    maxVisibleToasts: 1,
    queuePolicy: ToastQueuePolicy.queue,
  );

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Toastify Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          cardTheme: const CardThemeData(margin: EdgeInsets.zero),
        ),
        builder: (context, child) => ToastifyHost(
          controller: _toastController,
          child: child ?? const SizedBox.shrink(),
        ),
        home: ToastDemoPage(
          controller: _toastController,
          autoRunQueue: Uri.base.queryParameters['demo'] == 'queue' ||
              Uri.base.queryParameters['demo'] == 'features',
          autoRunFeatures: Uri.base.queryParameters['demo'] == 'features' ||
              Uri.base.queryParameters['demo']?.startsWith('feature-') == true,
          featureStep:
              Uri.base.queryParameters['demo']?.replaceFirst('feature-', ''),
        ),
      );
}

class ToastDemoPage extends StatefulWidget {
  const ToastDemoPage({
    required this.controller,
    required this.autoRunQueue,
    required this.autoRunFeatures,
    this.featureStep,
    super.key,
  });

  final ToastifyController controller;
  final bool autoRunQueue;
  final bool autoRunFeatures;
  final String? featureStep;

  @override
  State<ToastDemoPage> createState() => _ToastDemoPageState();
}

class _ToastDemoPageState extends State<ToastDemoPage> {
  @override
  void initState() {
    super.initState();
    if (widget.autoRunFeatures) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          showV2FeaturePreview(
            widget.controller,
            feature: widget.featureStep,
          );
        }
      });
    } else if (widget.autoRunQueue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) showQueuedUploadUpdates(widget.controller);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sections = <DemoSection>[
      ...buildQueueDemoSections(widget.controller),
      ...buildV2FeatureDemoSections(widget.controller),
      ...buildBasicDemoSections(),
      ...buildLayoutDemoSections(),
      ...buildCustomizationDemoSections(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toastify Demo'),
        actions: [
          TextButton.icon(
            onPressed: widget.controller.dismissAll,
            icon: const Icon(Icons.clear_all),
            label: const Text('Dismiss all'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) => _DemoSectionCard(
          section: sections[index],
        ),
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemCount: sections.length,
      ),
    );
  }
}

class _DemoSectionCard extends StatelessWidget {
  const _DemoSectionCard({required this.section});

  final DemoSection section;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(section.title, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(section.description, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 16),
            ...section.examples.map(
              (example) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _DemoExampleTile(example: example),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoExampleTile extends StatelessWidget {
  const _DemoExampleTile({required this.example});

  final DemoExample example;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(example.title, style: theme.textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(
                        example.description,
                        style: theme.textTheme.bodyMedium,
                      ),
                      if (example.note != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          example.note!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                FilledButton.icon(
                  onPressed: () => example.onRun(context),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Run'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
