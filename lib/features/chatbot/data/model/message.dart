class Message {
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final String? imageUrl;
  final String? filePath;

  Message({
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.imageUrl,
    this.filePath,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      isUser: json['isUser'],
      timestamp: DateTime.parse(json['timestamp']),
      imageUrl: json['imageUrl'],
      filePath: json['filePath'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'imageUrl': imageUrl,
      'filePath': filePath,
    };
  }
}
