class Message {
  Message({
    required this.content,
    required this.date,
    required this.isSentByMe,
    required this.state,
  });

  Message.fromJson(Map<String, Object?> json)
      : this(
          content: json['content']! as String,
          date: json['date']! as DateTime,
          isSentByMe: json['isSentByMe']! as bool,
          state: json['state']! as bool,
        );

  final String content;
  final DateTime date;
  final bool isSentByMe;
  final bool state;

  Map<String, Object?> toJson() {
    return {
      'content': content,
      'date': date,
      "isSentByMe": isSentByMe,
      "state": state,
    };
  }
}
