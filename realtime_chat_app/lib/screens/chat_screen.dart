
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/chat_message.dart';
import '../services/chat_service.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService chatService = ChatService();
  final TextEditingController messageController =
      TextEditingController();

  final String currentUser = 'Saniya';

  bool isSending = false;

  Future<void> sendMessage() async {
    final text = messageController.text.trim();

    if (text.isEmpty || isSending) {
      return;
    }

    setState(() {
      isSending = true;
    });

    messageController.clear();

    try {
      await chatService.sendMessage(
        sender: currentUser,
        text: text,
      );
    } catch (error) {
      if (!mounted) return;

      messageController.text = text;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send message: $error'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSending = false;
        });
      }
    }
  }

  Future<void> editMessage(ChatMessage message) async {
    final controller = TextEditingController(
      text: message.text,
    );

    final newText = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Edit Message'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Enter new message',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  controller.text.trim(),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    controller.dispose();

    if (newText == null ||
        newText.trim().isEmpty ||
        newText.trim() == message.text) {
      return;
    }

    try {
      await chatService.editMessage(
        id: message.id,
        newText: newText,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message updated successfully.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to edit message: $error'),
        ),
      );
    }
  }

  Future<void> deleteMessage(ChatMessage message) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Message'),
          content: const Text(
            'Are you sure you want to delete this message?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await chatService.deleteMessage(message.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Message deleted successfully.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete message: $error'),
        ),
      );
    }
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Real-Time Chat'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // Real-time messages.
          Expanded(
            child: StreamBuilder<List<ChatMessage>>(
              stream: chatService.getMessages(),

              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'Unable to load messages. '
                      'Please check your connection '
                      'and Firestore configuration.',
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                if (snapshot.connectionState ==
                        ConnectionState.waiting &&
                    !snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No messages yet. Start chatting!',
                      style: TextStyle(fontSize: 16),
                    ),
                  );
                }

                final chatMessages = snapshot.data!;

                return ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(12),
                  itemCount: chatMessages.length,

                  itemBuilder: (context, index) {
                    final message = chatMessages[index];

                    final isMine =
                        message.sender == currentUser;

                    return Align(
                      alignment: isMine
                          ? Alignment.centerRight
                          : Alignment.centerLeft,

                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth:
                              MediaQuery.of(context).size.width *
                                  0.78,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 5,
                        ),

                        child: Card(
                          color: isMine
                              ? Colors.deepPurple.shade100
                              : Colors.grey.shade200,

                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),

                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,

                              children: [
                                Text(
                                  message.sender,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  message.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (message.createdAt != null)
                                      Text(
                                        TimeOfDay.fromDateTime(
                                          message.createdAt!
                                              .toDate(),
                                        ).format(context),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Colors.black54,
                                        ),
                                      ),

                                    if (isMine) ...[
                                      const SizedBox(width: 8),

                                      IconButton(
                                        visualDensity:
                                            VisualDensity.compact,
                                        tooltip: 'Edit message',
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 18,
                                        ),
                                        onPressed: () =>
                                            editMessage(message),
                                      ),

                                      IconButton(
                                        visualDensity:
                                            VisualDensity.compact,
                                        tooltip: 'Delete message',
                                        icon: const Icon(
                                          Icons.delete,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                        onPressed: () =>
                                            deleteMessage(message),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // Message input area.
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.all(10),
              color: Colors.grey.shade100,

              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      textCapitalization:
                          TextCapitalization.sentences,
                      minLines: 1,
                      maxLines: 4,

                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(25),
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                      ),

                      onSubmitted: (_) => sendMessage(),
                    ),
                  ),

                  const SizedBox(width: 8),

                  IconButton.filled(
                    onPressed: isSending ? null : sendMessage,
                    icon: isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}