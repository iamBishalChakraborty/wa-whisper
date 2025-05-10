import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/chat_log.dart';
import '../services/storage_service.dart';
import '../services/database_service.dart';
import '../widgets/phone_input.dart';
import '../widgets/log_item.dart';
import 'logs_screen.dart';
import 'developer_screen.dart';
// import 'contact_screen.dart'; // Removed ContactScreen import
import '../widgets/app_footer.dart'; // Import AppFooter

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StorageService _storage;
  String _phone = '';
  final _messageController = TextEditingController();
  List<ChatLog> _recentLogs = [];

  @override
  void initState() {
    super.initState();
    _initStorage();
  }

  Future<void> _initStorage() async {
    _storage = StorageService(DatabaseService());
    _loadRecentLogs();
  }

  Future<void> _loadRecentLogs() async {
    final logs = await _storage.getLogs();
    setState(() {
      _recentLogs = logs.take(5).toList();
    });
  }

  Future<void> _startChat() async {
    if (_phone.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
          'Please enter a phone number',
          softWrap: true,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        )),
      );
      return;
    }

    try {
      final message = _messageController.text;
      final cleanPhone = _phone.replaceAll(RegExp(r'[^0-9+]'), '');

      final log = ChatLog(
        phoneNumber: cleanPhone,
        message: message.isNotEmpty ? message : null,
        timestamp: DateTime.now(),
      );

      await _storage.saveLog(log);
      _loadRecentLogs();

      final url = Uri.parse(
        'https://wa.me/${cleanPhone.replaceAll('+', '')}?text=${Uri.encodeComponent(message)}',
      );

      if (!mounted) return;
      if (!await canLaunchUrl(url)) {
        throw Exception('Could not launch WhatsApp');
      }

      await launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'Error starting chat: ${e.toString()}',
          softWrap: true,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WA Whisper'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'logs':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LogsScreen()),
                  ).then((_) => _loadRecentLogs());
                  break;
                case 'developer':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DeveloperScreen()),
                  );
                  break;
                // case 'contact': // Removed ContactScreen navigation
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (_) => const ContactScreen()),
                //   );
                //   break;
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'logs', child: Text('View Logs')),
              const PopupMenuItem(value: 'developer', child: Text('Developer')),
              // const PopupMenuItem(value: 'contact', child: Text('Contact')), // Removed Contact PopupMenuItem
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Start a new conversation',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  softWrap: true,
                ),
              ),

              // Input section
              Card(
                elevation: 0,
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withAlpha((255 * 0.3).round()),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PhoneInput(onPhoneChanged: (phone) => _phone = phone),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _messageController,
                        decoration: const InputDecoration(
                          hintText: 'Message (Optional)',
                          prefixIcon: Icon(Icons.message_outlined),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _startChat,
                        icon: const Icon(Icons.send),
                        label: const Text('Start Chat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Recent chats section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Chats',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    softWrap: true,
                  ),
                  if (_recentLogs.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const LogsScreen()),
                        ).then((_) => _loadRecentLogs());
                      },
                      icon: const Icon(Icons.history, size: 18),
                      label: const Text('View All'),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              Expanded(
                child: (_recentLogs.isEmpty // Added parentheses around ternary
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.history_outlined,
                              size: 64,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withAlpha((255 * 0.5).round()),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No recent chats',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _recentLogs.length,
                        itemBuilder: (context, index) =>
                            LogItem(log: _recentLogs[index]),
                      )), // Added parentheses around ternary
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppFooter(), // Add AppFooter here
    );
  }
}
