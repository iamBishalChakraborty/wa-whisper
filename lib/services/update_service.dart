import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import '../widgets/update_dialog.dart'; // To show dialog for completing flexible update

class UpdateService {
  // Check if an update is available and initiate In-App Update
  static Future<void> checkForUpdates(BuildContext context) async {
    if (!context.mounted) return;

    try {
      AppUpdateInfo appUpdateInfo = await InAppUpdate.checkForUpdate();

      if (appUpdateInfo.installStatus == InstallStatus.downloaded) {
        // Corrected: Check installStatus for downloaded state
        // A flexible update has been downloaded and is ready to be installed.
        // Prompt the user to complete the update.
        debugPrint('Flexible update downloaded, prompting user to install.');
        if (context.mounted) {
          // Show a dialog to complete the flexible update.
          // The UpdateDialog itself will call InAppUpdate.completeFlexibleUpdate()
          showDialog<void>(
            context: context,
            barrierDismissible:
                false, // Should not be dismissible if we want to force completion here
            builder: (BuildContext dialogContext) {
              // UpdateDialog will be simplified to not require UpdateInfo
              return const UpdateDialog();
            },
          );
        }
      } else if (appUpdateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        // An update is available on the Play Store.
        if (appUpdateInfo.immediateUpdateAllowed) {
          // Prefer immediate update if allowed (acts like a forced update).
          debugPrint('Immediate update available and allowed, starting...');
          AppUpdateResult immediateResult =
              await InAppUpdate.performImmediateUpdate();
          if (immediateResult == AppUpdateResult.success) {
            debugPrint('Immediate update flow completed successfully.');
            // App will restart.
          } else {
            debugPrint(
                'Immediate update failed or was cancelled by user: $immediateResult');
            if (context.mounted &&
                immediateResult == AppUpdateResult.userDeniedUpdate) {
              // Corrected to userDeniedUpdate
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text(
                  'Update cancelled. Some features might not be available.',
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                )),
              );
            } else if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                  'Immediate update failed: $immediateResult',
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                )),
              );
            }
          }
        } else if (appUpdateInfo.flexibleUpdateAllowed) {
          // Fallback to flexible update if immediate is not allowed but flexible is.
          debugPrint(
              'Flexible update available and allowed, starting download...');
          AppUpdateResult flexibleResult =
              await InAppUpdate.startFlexibleUpdate();
          if (flexibleResult == AppUpdateResult.success) {
            debugPrint('Flexible update download started successfully.');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'A new version is downloading. You will be prompted to install when ready.',
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  duration: Duration(seconds: 5),
                ),
              );
            }
            // The app will continue running.
            // When download completes, checkForUpdates() will find UpdateAvailability.updateDownloaded
            // on a subsequent check, or a listener could be set up.
          } else {
            debugPrint(
                'Flexible update failed to start or was cancelled: $flexibleResult');
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(
                  'Flexible update could not be started: $flexibleResult',
                  softWrap: true,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                )),
              );
            }
          }
        } else {
          debugPrint(
              'Update available but neither immediate nor flexible update type is allowed.');
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                'An update is available, but cannot be installed automatically at this moment.',
                softWrap: true,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )),
            );
          }
        }
      } else if (appUpdateInfo.updateAvailability ==
          UpdateAvailability.updateNotAvailable) {
        debugPrint('No update available from Play Store.');
        // Optionally, show a SnackBar if this check was user-initiated (e.g., from DeveloperScreen)
        // For automatic checks in main.dart, this might be silent.
      } else {
        debugPrint(
            'Play Store update availability status: ${appUpdateInfo.updateAvailability}');
      }
    } catch (e) {
      debugPrint('Error during in-app update check: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Error checking for updates: $e',
            softWrap: true,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          )),
        );
      }
    }
  }
}
