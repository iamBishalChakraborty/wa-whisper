import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter/material.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Install Update'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'A new version has been downloaded and is ready to install.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tap "Install Now" to apply the update. The app will restart.',
            ),
          ],
        ),
      ),
      actions: [
        // Removed "Later" button to encourage immediate completion of downloaded update.
        // If "Later" is desired, ensure robust handling for re-prompting.
        ElevatedButton(
          onPressed: () async {
            try {
              // completeFlexibleUpdate returns Future<void>.
              // If successful, the app restarts. If it fails, it throws.
              await InAppUpdate.completeFlexibleUpdate();
              // If the code reaches here, it means the app didn't restart and no error was thrown.
              // This state is unlikely if the plugin works as expected (restarting on success).
              // However, to be safe, we can pop the dialog if it's still mounted.
              debugPrint(
                  'completeFlexibleUpdate called. App should restart if successful.');
              if (context.mounted) {
                // Pop dialog if it's somehow still there after the call and no restart/exception
                Navigator.of(context).pop();
              }
            } catch (e) {
              debugPrint('Error during completeFlexibleUpdate: $e');
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error installing update: $e'),
                  ),
                );
                // Pop the dialog on error
                Navigator.of(context).pop();
              }
            }
            // Do not pop here if successful, as app should restart.
            // If it failed/cancelled and not mounted, nothing to do.
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          child: const Text('Install Now'),
        ),
      ],
    );
  }
}

// The showUpdateDialog helper function is removed as UpdateService
// now calls showDialog directly with this simplified UpdateDialog.
