import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  late final GenerativeModel _model;
  late final ChatSession _chat;

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-2.0-flash', // <-- use the model you mentioned
      apiKey:
          'AIzaSyBhIWlu2GPLL-3ce3Jq3fg7NyRk0d3tWNw', // Replace with your API key
    );
    _chat = _model.startChat();

    // Preload model with behavior instructions
    _chat.sendMessage(
      Content.text(
        'You are a helpful assistant that responds in short, polite sentences. '
        'Always answer in bullet points unless asked otherwise.',
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text;
    _messageController.clear();

    setState(() {
      _messages.add(ChatMessage(text: userMessage, isUser: true));
      _messages.add(
        ChatMessage(text: '...', isUser: false),
      ); // 👈 Temporary loading msg
    });

    try {
      final response = await _chat.sendMessage(Content.text(userMessage));
      setState(() {
        _messages.removeLast(); // remove '...'
        _messages.add(
          ChatMessage(
            text: response.text ?? 'No response from AI',
            isUser: false,
          ),
        );
      });
    } catch (e) {
      setState(() {
        _messages.removeLast(); // remove '...'
        _messages.add(
          ChatMessage(text: 'Error: ${e.toString()}', isUser: false),
        );
      });
    }
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isLoading = message.text == '...';

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child:
          isLoading
              ? Center(
                child: const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
              : Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: message.isUser ? Colors.blue : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  message.text,
                  style: TextStyle(
                    color: message.isUser ? Colors.white : Colors.black,
                  ),
                ),
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini AI Chat'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildMessageBubble(_messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(24)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send),
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
