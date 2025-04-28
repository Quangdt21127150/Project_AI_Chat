class ConversationMessagesResponse {
  final bool hasMore;
  final List<ConversationMessage> items;

  ConversationMessagesResponse({
    required this.hasMore,
    required this.items,
  });

  factory ConversationMessagesResponse.fromJson(Map<String, dynamic> json) {
    return ConversationMessagesResponse(
      hasMore: json['has_more'],
      items: (json['items'] as List)
          .map((item) => ConversationMessage.fromJson(item))
          .toList(),
    );
  }
}

class ConversationMessage {
  final String answer;
  final String createdAt;
  final List<String>? files;
  final String query;

  ConversationMessage({
    required this.answer,
    required this.createdAt,
    this.files,
    required this.query,
  });

  factory ConversationMessage.fromJson(Map<String, dynamic> json) {
    return ConversationMessage(
      answer: json['answer'],
      createdAt: json['createdAt'],
      files: json['files'] != null ? List<String>.from(json['files']) : null,
      query: json['query'],
    );
  }
}