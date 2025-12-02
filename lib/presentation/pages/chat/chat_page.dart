import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../bloc/chat/chat_bloc.dart';
import '../../widgets/chat_message_bubble.dart';
import '../../widgets/voice_wave_animation.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
  
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('सहायक AI'),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _clearChat(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatLoaded) {
                  _scrollToBottom();
                }
              },
              builder: (context, state) {
                if (state is ChatInitial) {
                  return _buildWelcomeView();
                }
                
                if (state is ChatLoading) {
                  return _buildChatView(state);
                }
                
                if (state is ChatLoaded) {
                  return _buildChatView(state);
                }
                
                if (state is ChatError) {
                  return _buildErrorView(state);
                }
                
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
          _buildInputArea(context),
        ],
      ),
    );
  }
  
  Widget _buildWelcomeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Image.asset(
            'assets/images/ai_assistant.png',
            height: 150,
          ),
          const SizedBox(height: 30),
          Text(
            'सहायक AI मा स्वागत छ',
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'म तपाईंको AI सहायक हुँ।\nकसरी मद्दत गर्न सक्छु?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 40),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildQuickPrompt('CV कसरी बनाउने?'),
              _buildQuickPrompt('यो अंग्रेजीमा अनुवाद गर्नुहोस्'),
              _buildQuickPrompt('आजको मौसम'),
              _buildQuickPrompt('रोजगारीका अवसरहरू'),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildChatView(ChatState state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(10),
      itemCount: state.messages.length + (state is ChatLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < state.messages.length) {
          final message = state.messages[index];
          return ChatMessageBubble(
            message: message,
            isUser: message.isUser,
          );
        } else {
          return _buildTypingIndicator();
        }
      },
    );
  }
  
  Widget _buildErrorView(ChatError state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'त्रुटि भयो',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 10),
        Text(state.error),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => context.read<ChatBloc>().add(ClearChat()),
          child: const Text('पुनः प्रयास गर्नुहोस्'),
        ),
      ],
    );
  }
  
  Widget _buildInputArea(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: state.currentLanguage == 'ne' 
                        ? 'सन्देश लेख्नुहोस्...' 
                        : 'Type a message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _sendMessage(context, value.trim());
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              if (state.isListening)
                VoiceWaveAnimation()
              else
                IconButton(
                  icon: const Icon(Icons.mic),
                  onPressed: () => context.read<ChatBloc>().add(StartListening()),
                  tooltip: 'Voice Input',
                ),
              const SizedBox(width: 10),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_textController.text.trim().isNotEmpty) {
                    _sendMessage(context, _textController.text.trim());
                  }
                },
                tooltip: 'Send',
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildQuickPrompt(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        // Handle quick prompt
      },
    );
  }
  
  Widget _buildTypingIndicator() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: Icon(Icons.smart_toy, color: Colors.white),
          ),
          SizedBox(width: 10),
          Text('सहायक लेख्दैछ...'),
        ],
      ),
    );
  }
  
  void _sendMessage(BuildContext context, String message) {
    final state = context.read<ChatBloc>().state;
    context.read<ChatBloc>().add(SendMessage(
      message: message,
      language: state.currentLanguage,
    ));
    _textController.clear();
  }
  
  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('भाषा छान्नुहोस्'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('नेपाली'),
                onTap: () {
                  context.read<ChatBloc>().add(ChangeLanguage('ne'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('English'),
                onTap: () {
                  context.read<ChatBloc>().add(ChangeLanguage('en'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  
  void _clearChat(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('च्याट खाली गर्नुहोस्'),
          content: const Text('के तपाईं निश्चित हुनुहुन्छ?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('रद्द गर्नुहोस्'),
            ),
            TextButton(
              onPressed: () {
                context.read<ChatBloc>().add(ClearChat());
                Navigator.pop(context);
              },
              child: const Text('खाली गर्नुहोस्'),
            ),
          ],
        );
      },
    );
  }
}