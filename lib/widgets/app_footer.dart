import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // Log or show an error if the URL can't be launched
      debugPrint('Could not launch $urlString');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: () => _launchURL(
                'https://github.com/iamBishalChakraborty/wa-whisper.git'),
            child: Text(
              'Open Source',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                // decoration: TextDecoration.underline, // Removed underline
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.favorite,
              color: Colors.red,
              size: theme.textTheme.bodyMedium?.fontSize,
            ),
          ),
          Text(
            'Ad Free',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
