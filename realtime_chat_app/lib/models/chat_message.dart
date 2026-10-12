
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String sender;
  final String text;
  final Timestamp? createdAt;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.text,
    this.createdAt,
  });

  factory ChatMessage.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? {};

    return ChatMessage(
      id: document.id,
      sender: data['sender'] as String? ?? 'Unknown',
      text: data['text'] as String? ?? '',
      createdAt: data['createdAt'] as Timestamp?,
    );
  }
}