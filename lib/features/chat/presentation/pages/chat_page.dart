import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String? seller; // теперь nullable, можно не передавать

  const ChatPage({super.key, this.seller});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': _controller.text.trim(),
        'isMe': true,
      });
      _controller.clear();
    });

    // имитация ответа продавца (если есть)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        final sellerName = widget.seller ?? 'Продавец';
        _messages.add({
          'text': 'Привет! Я — $sellerName, в чём вопрос?',
          'isMe': false,
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.seller != null ? 'Чат с ${widget.seller}' : 'Чат';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message['isMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: message['isMe']
                          ? Colors.blueAccent.withOpacity(0.8)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color: message['isMe'] ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.grey.shade100,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Введите сообщение...',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
