import 'package:flutter/material.dart';
import '../widgets/app_footer.dart'; // Import AppFooter

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Developer')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App info card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.chat_outlined,
                          color: colorScheme.onPrimary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WA Whisper',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Version: 1.0.0',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Update section removed as requested.
              // const SizedBox(height: 24), // Removed associated SizedBox

              // Developer info
              Text(
                'Developer',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                color: colorScheme.surfaceContainerHighest
                    .withAlpha((255 * 0.3).round()),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: Icon(Icons.person, color: colorScheme.primary),
                        title: const Text(
                          'Bishal Chakraborty',
                          overflow: TextOverflow.ellipsis,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                      ListTile(
                        leading: Icon(Icons.email, color: colorScheme.primary),
                        title: const Text(
                          'cbishal6@gmail.com',
                          overflow: TextOverflow.ellipsis,
                        ),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),
              Center(
                child: Text(
                  '© ${DateTime.now().year} All rights reserved',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppFooter(), // Add AppFooter here
    );
  }
}
