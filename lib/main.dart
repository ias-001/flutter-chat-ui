import 'package:flutter/material.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, dynamic>> messages = [
    {
      'sender': 'Louisana',
      'message': 'Hi how are you?',
      'time': '12:54',
      'isMe': false,
    },
    {
      'sender': 'Louisana',
      'message': 'Feeling ok?',
      'time': '12:55',
      'isMe': false,
    },
    {
      'sender': 'Tommy',
      'message': 'Yes Im good, thanks for asking. Didnt do much. Feeling bit sick after that meal. So just exhausted. Watching Netflix. 🍿',
      'time': '13:20',
      'isMe': true,
    },
    {
      'sender': 'Tommy',
      'message': 'Yes, Im well. Had a long day. Went hiking with some people, it was extremely hot, couldnt be better',
      'time': '12:57',
      'isMe': true,
    },
    {
      'sender': 'Cristofer',
      'message': 'Yes Im good. Thanks for asking. Didnt do much. Feeling bit sick after that meal. So just exhausted. Watching Netflix',
      'time': '13:20',
      'isMe': false,
    },
  ];

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.isNotEmpty) {
      setState(() {
        messages.add({
          'sender': 'Tommy',
          'message': _messageController.text,
          'time': 'Now',
          'isMe': true,
        });
        _messageController.clear();
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E8), // Light cream background
      body: Stack(
        children: [
          // Background image will cover the entire screen, even under the header and input box
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // The header is still inside the SafeArea
                _buildHeader(context),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      return ChatBubble(
                        isMe: message['isMe'],
                        text: message['message'],
                        time: message['time'],
                        sender: message['sender'],
                      );
                    },
                  ),
                ),
                // The text input box is also inside the SafeArea
                ChatInputBox(
                  controller: _messageController,
                  onSend: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      color: Colors.transparent, // Transparent background
      child: Row(
        children: [
          Container(
            width: 60,
            height: 55,
            decoration: BoxDecoration(
              color: const Color(0xFFFCC85F),
              border: Border.all(color: const Color(0xFFA6E9DB), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.chevron_left, color: Color(0xFF1D6861), size: 32),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.73, // 70% of screen width
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFCC85F),
                border: Border.all(color: const Color(0xFFA6E9DB), width: 1.5),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/images.jpeg'),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Tommy’s Group",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.more_vert, color: Colors.black),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  final String time;
  final String sender;

  const ChatBubble({
    super.key,
    required this.isMe,
    required this.text,
    required this.time,
    required this.sender,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFFFFC84A) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: isMe ? const Radius.circular(90) : const Radius.circular(16),
                    topRight: isMe ? const Radius.circular(16) : const Radius.circular(90),
                    bottomLeft: isMe ? const Radius.circular(90) : const Radius.circular(16),
                    bottomRight: isMe ? const Radius.circular(16) : const Radius.circular(90),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isMe)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF2A9D8F), width: 1),
                              shape: BoxShape.circle,
                            ),
                            child: const CircleAvatar(
                              radius: 10,
                              backgroundImage: AssetImage('assets/images.jpeg'),
                              backgroundColor: Colors.transparent,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            sender,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    if (!isMe) const SizedBox(height: 6),
                    Padding(
                      padding: isMe ? const EdgeInsets.only(top: 10) : EdgeInsets.zero, 
                      child: Text(
                        text,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: isMe
                            ? const EdgeInsets.only(left: 0, right: 0) 
                            : const EdgeInsets.only(left: 0, right: 10), 
                        child: Text(
                          time,
                          style: const TextStyle(fontSize: 10, color: Colors.black45),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatInputBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;

  const ChatInputBox({
    super.key,
    required this.controller,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85, // 90% width
          decoration: BoxDecoration(
            color: const Color(0xFFFEF3DC), // Background color
            border: Border.all(color: const Color(0xFF2A9D8F), width: 1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(0),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type a message...',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                  ),
                  // Camera icon at the top
                  const Positioned(
                    top: 0, // Positioned above the input box
                    child: Icon(Icons.camera_alt, color: Color(0xFF2A9D8F), size: 18),
                  ),
                  // Mail icon at the bottom left
                  Positioned(
                    bottom: -15, // Positioned below the input box
                    left: -15, // Positioned to the left
                    child: IconButton(
                      onPressed: onSend,
                      icon: const Icon(Icons.mail_outline, color: Color(0xFF2A9D8F), size: 18),
                    ),
                  ),
                  // Flag icon at the bottom right
                  const Positioned(
                    bottom: 0, // Positioned below the input box
                    right: 0, // Positioned to the right
                    child: Icon(Icons.flag_outlined, color: Color(0xFF688682), size: 18),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
