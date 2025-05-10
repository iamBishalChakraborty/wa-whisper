import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/chat_log.dart';

class LogItem extends StatelessWidget {
  final ChatLog log;

  const LogItem({super.key, required this.log});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.phone, size: 18, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          log.phoneNumber,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8), // Added for spacing
                Text(
                  DateFormat.yMd().add_jm().format(log.timestamp),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.end,
                  overflow: TextOverflow.fade,
                ),
              ],
            ),
            if (log.message != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withAlpha((255 * 0.3).round()),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  log.message!,
                  style: theme.textTheme.bodyMedium,
                  softWrap: true,
                  maxLines: 4, // Added maxLines
                  overflow: TextOverflow.ellipsis, // Changed to ellipsis
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
