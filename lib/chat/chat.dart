import 'package:flutter/material.dart';
import 'chat_detail_page.dart';

class ChatListItem {
  final String chatId;
  final String doctorName;
  final String doctorSpecialty;
  final String lastMessage;
  final String timestamp;
  final String doctorImageUrl;
  final bool isOnline;

  ChatListItem({
    required this.chatId,
    required this.doctorName,
    this.doctorSpecialty = "",
    required this.lastMessage,
    required this.timestamp,
    required this.doctorImageUrl,
    this.isOnline = false,
  });
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<ChatListItem> _chatListItems = [
    ChatListItem(
      chatId: "doc123",
      doctorName: "Dr. Mutiara Puspita Sp. KG",
      lastMessage: "Baik, Terima Kasih dok. Saya aka...",
      timestamp: "Hari Ini, 13:10",
      doctorImageUrl: "https://marketplace.canva.com/zlZtI/MAD8TNzlZtI/1/tl/canva-happy-female-doctor-MAD8TNzlZtI.jpg",
      isOnline: true,
    ),
    ChatListItem(
      chatId: "doc456",
      doctorName: "Dr. Tirta Mandira Hudhi",
      lastMessage: "Terima Kasih dok, saya akan mulai...",
      timestamp: "20 Apr, 12:15",
      doctorImageUrl: "https://asset.kompas.com/crops/qbQrm0Mb6rfVLacf_87XrhzzzLQ=/0x2:1080x722/750x500/data/photo/2021/08/27/61282e8267e24.jpg",
    ),
    ChatListItem(
      chatId: "doc789",
      doctorName: "Dr. Budi Santoso Sp.THT-KL",
      lastMessage: "Untuk keluhan tersebut, sebaiknya...",
      timestamp: "19 Apr, 09:30",
      doctorImageUrl: "https://placehold.co/80x80/F1F8E9/33691E?text=Dr.B",
      isOnline: true,
    ),
    ChatListItem(
      chatId: "doc101",
      doctorName: "dr. Citra Ayu M.Psi., Psikolog",
      lastMessage: "Sama-sama, semoga lekas membaik.",
      timestamp: "15 Apr, 17:45",
      doctorImageUrl: "https://placehold.co/80x80/FCE4EC/880E4F?text=Dr.C",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Pesan",
          style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: _chatListItems.isEmpty
          ? _buildEmptyChatView(theme)
          : ListView.separated(
              itemCount: _chatListItems.length,
              itemBuilder: (context, index) {
                return _buildChatListItem(_chatListItems[index], theme);
              },
              separatorBuilder: (context, index) => Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[200],
                indent: 80,
              ),
            ),
    );
  }

  Widget _buildEmptyChatView(ThemeData theme) {
    return Center(
      child: Padding( // Tambahkan padding
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "Belum ada pesan",
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              "Mulai konsultasi dengan dokter untuk melihat pesan Anda di sini.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatListItem(ChatListItem item, ThemeData theme) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(item.doctorImageUrl),
            onBackgroundImageError: (_, __) {},
            backgroundColor: Colors.grey[200],
             child: item.doctorImageUrl.isEmpty || !item.doctorImageUrl.startsWith('http')
                ? Icon(Icons.person, size: 28, color: Colors.grey[400])
                : null,
          ),
          if (item.isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade700,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(
        item.doctorName,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textTheme.bodyLarge?.color),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        item.lastMessage,
        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        item.timestamp,
        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatDetailPage(
              chatId: item.chatId,
              doctorName: item.doctorName,
              doctorImageUrl: item.doctorImageUrl,
              isDoctorOnline: item.isOnline,
            ),
          ),
        );
      },
    );
  }
}
