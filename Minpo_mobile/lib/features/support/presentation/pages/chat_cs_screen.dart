import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:jbr_mimpo/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class ChatCsScreen extends StatefulWidget {
  const ChatCsScreen({super.key});

  @override
  State<ChatCsScreen> createState() => _ChatCsScreenState();
}

class _ChatCsScreenState extends State<ChatCsScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isAgentTyping = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'isMe': false,
      'text': 'Halo! Selamat datang di layanan Support JBR. Saya Minpo, asisten virtual Anda. Ada yang bisa saya bantu hari ini?',
      'time': '09:41 AM',
    },
    {
      'isMe': true,
      'text': 'Halo Minpo, saya ingin bertanya tentang status koneksi saya yang sering terputus.',
      'time': '09:42 AM',
    },
    {
      'isMe': false,
      'text': 'Mohon maaf atas ketidaknyamanannya. Untuk membantu pengecekan, silakan pilih topik yang paling sesuai atau masukkan ID Pelanggan Anda.',
      'time': '09:42 AM',
    },
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'isMe': true,
        'text': _messageController.text,
        'time': 'Just now',
      });
      _messageController.clear();
      _isAgentTyping = true;
    });
    
    _scrollToBottom();
    
    // Simulate agent response
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isAgentTyping = false;
          _messages.add({
            'isMe': false,
            'text': 'Baik, tim teknis kami akan segera melakukan pengecekan atas kendala yang Anda alami. Mohon persiapkan perangkat Anda.',
            'time': 'Just now',
          });
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
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
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        backgroundColor: AppColors.bgLight,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: CachedNetworkImageProvider('https://lh3.googleusercontent.com/aida-public/AB6AXuBrAR_C7vUB5u6deg_FwTxbouUNa5SyCG7eeXn58veViH_LFvxbwz9MFSue6VXsDkfP5FGSq9flo7ZYpauKa0GzVwYSMH3RkH3OJ7MelMKN-Cd2-4oZKcnMkXVdLo0pi9GojBD1QRKtP-NoCOSaK6jB0xe31vI-sgMDJFTO3S40PvpuBb5yQtSTY11EbtihcyRaZymP8Z98UvhUieseAoN6hjfS9-jyJFVvKTmcrKf4zOnma51ihbg2tuRZpPF6G9hqy3G9CVuwk5l8'),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CS JBR Minpo',
                  style: GoogleFonts.sora(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                Text(
                  'Online',
                  style: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green, letterSpacing: 1),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.contact_support_rounded, color: AppColors.primary)),
        ],
      ),
      body: Column(
        children: [
          // 1. Chat Canvas
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: _messages.length + (_isAgentTyping ? 3 : 2), // +1 header, +1 chips/typing
              itemBuilder: (context, index) {
                if (index == 0) {
                   return Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 24),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                      child: Text('HARI INI', style: GoogleFonts.jetBrainsMono(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                    ),
                  );
                }

                if (index <= _messages.length) {
                  final msg = _messages[index - 1]; // Fix index offset
                  return _buildChatBubble(msg['isMe'], msg['text'], msg['time']);
                }

                // After messages
                if (_isAgentTyping && index == _messages.length + 1) {
                  return _buildTypingIndicator();
                }

                if (!_isAgentTyping && index == _messages.length + 1) {
                  return _buildQuickReplyChips();
                }

                if (_isAgentTyping && index == _messages.length + 2) {
                   return _buildQuickReplyChips();
                }
                
                return const SizedBox.shrink();
              },
            ),
          ),

          // 2. Input Area
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(bool isMe, String text, String time) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isMe ? 20 : 0),
                  bottomRight: Radius.circular(isMe ? 0 : 20),
                ),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Text(
                text,
                style: GoogleFonts.dmSans(fontSize: 14, color: isMe ? Colors.white : AppColors.textPrimary, height: 1.5),
              ),
            ),
            const SizedBox(height: 6),
            Text(time, style: GoogleFonts.jetBrainsMono(fontSize: 9, color: Colors.grey)),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(0),
            const SizedBox(width: 4),
            _buildDot(1),
            const SizedBox(width: 4),
            _buildDot(2),
          ],
        ),
      ),
    ).animate().fadeIn();
  }

  Widget _buildDot(int index) {
    return Container(
      width: 6,
      height: 6,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
    ).animate(onPlay: (controller) => controller.repeat())
     .slideY(
       begin: 0,
       end: -0.5,
       duration: 300.ms,
       curve: Curves.easeInOut,
       delay: (index * 150).ms,
     )
     .then(duration: 300.ms)
     .slideY(begin: -0.5, end: 0, curve: Curves.easeInOut);
  }

  Widget _buildQuickReplyChips() {
    final chips = ['Cek Tagihan', 'Wifi Bermasalah', 'Upgrade Speed', 'Lainnya'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: chips.map((chip) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: ActionChip(
              onPressed: () {
                _messageController.text = chip;
                _sendMessage();
              },
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              label: Text(chip, style: GoogleFonts.sora(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ),
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(color: AppColors.bgLight, borderRadius: BorderRadius.circular(20)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline_rounded, color: Colors.grey)),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: 5,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Tulis pesan...',
                        hintStyle: GoogleFonts.dmSans(fontSize: 14, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.sentiment_satisfied_alt_rounded, color: Colors.grey)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4)),
                ],
              ),
              child: const Center(child: Icon(Icons.send_rounded, color: Colors.white, size: 20)),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).shimmer(duration: 3.seconds),
        ],
      ),
    );
  }
}
