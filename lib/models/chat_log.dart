class ChatLog {
  final String phoneNumber;
  final String? message;
  final DateTime timestamp;

  ChatLog({
    required this.phoneNumber,
    this.message,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'phoneNumber': phoneNumber,
    'message': message,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatLog.fromJson(Map<String, dynamic> json) => ChatLog(
    phoneNumber: json['phoneNumber'],
    message: json['message'],
    timestamp: DateTime.parse(json['timestamp']),
  );
}