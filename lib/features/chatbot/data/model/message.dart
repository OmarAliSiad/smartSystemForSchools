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
}