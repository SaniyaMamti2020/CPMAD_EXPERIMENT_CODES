import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_message.dart';

class ChatService {
  final CollectionReference<Map<String, dynamic>> messages =
      FirebaseFirestore.instance.collection('messages');

  // Read messages in real time.
  Stream<List<ChatMessage>> getMessages() {
    return messages
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => ChatMessage.fromFirestore(doc))
          .toList();
    });
  }

  // Add a new message.
  Future<void> sendMessage({
    required String sender,
    required String text,
  }) async {
    final messageText = text.trim();

    if (messageText.isEmpty) {
      return;
    }

    await messages.add({
      'sender': sender.trim(),
      'text': messageText,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Edit an existing message.
  Future<void> editMessage({
    required String id,
    required String newText,
  }) async {
    final messageText = newText.trim();

    if (messageText.isEmpty) {
      throw ArgumentError('Message cannot be empty.');
    }

    await messages.doc(id).update({
      'text': messageText,
      'editedAt': FieldValue.serverTimestamp(),
    });
  }

  // Delete a message.
  Future<void> deleteMessage(String id) async {
    await messages.doc(id).delete();
  }
}