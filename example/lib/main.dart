import 'package:flutter/material.dart';
import 'package:my_toastify/my_toastify.dart';

import 'examples/basic_examples.dart';
import 'examples/customization_examples.dart';
import 'examples/demo_catalog.dart';
import 'examples/layout_examples.dart';

void main() => runApp(const ToastifyDemoApp());

class ToastifyDemoApp extends StatelessWidget {
  const ToastifyDemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toastify Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        cardTheme: const CardThemeData(margin: EdgeInsets.zero),
      ),
      home: const ToastDemoPage(),
    );
  }
}

class ToastDemoPage extends StatelessWidget {
  const ToastDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sections = <DemoSection>[
      ...buildBasicDemoSections(),
      ...buildLayoutDemoSections(),
      ...buildCustomizationDemoSections(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Toastify Demo'),
        actions: [
          TextButton.icon(
            onPressed: Toastify.dismissAll,
            icon: const Icon(Icons.clear_all),
            label: const Text('Dismiss all'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final section = sections[index];
          return _DemoSectionCard(section: section);
        },
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
