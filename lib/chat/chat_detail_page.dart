import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class ChatMessage {
  final String text;
  final bool isUserMessage;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUserMessage,
    required this.timestamp,
  });
}

class CallRecord {
  final String id;
  final String doctorName;
  final String callType;
  final DateTime timestamp;
  final String durationInfo;
  final String? recordingUrl;

  CallRecord({
    required this.id,
    required this.doctorName,
    required this.callType,
    required this.timestamp,
    required this.durationInfo,
    this.recordingUrl,
  });
}

class ChatDetailPage extends StatefulWidget {
  final String chatId;
  final String doctorName;
  final String doctorImageUrl;
  final bool isDoctorOnline;

  const ChatDetailPage({
    super.key,
    required this.chatId,
    required this.doctorName,
    required this.doctorImageUrl,
    required this.isDoctorOnline,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final Map<List<String>, String> _autoReplies = {
    ['dada', 'perut', 'sendawa', 'sakit']: "Kemungkinan Anda mengalami gejala GERD. Sebaiknya periksakan diri ke dokter untuk diagnosis yang lebih akurat...",
    ['pusing', 'demam', 'flu']: "Gejala pusing, demam, dan flu bisa disebabkan oleh banyak hal. Pastikan Anda cukup istirahat dan minum banyak air...",
    ['terima kasih', 'makasih', 'oke dok', 'baik dok']: "Sama-sama! Semoga lekas sembuh.",
    ['halo', 'pagi', 'siang', 'sore', 'malam', 'hi']: "Halo! Ada yang bisa saya bantu terkait keluhan kesehatan Anda?",
  };

  final List<CallRecord> _callRecords = [
    CallRecord(
      id: "call1",
      doctorName: "dr. Mutiara Puspita Sp. KG",
      callType: "Panggilan Suara",
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
      durationInfo: "Panggilan suara selama 30 menit telah direkam",
      recordingUrl: "dummy_url_1"
    ),
    CallRecord(
      id: "call2",
      doctorName: "dr. Mutiara Puspita Sp. KG",
      callType: "Panggilan Video",
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
      durationInfo: "Panggilan video selama 15 menit telah direkam",
      recordingUrl: "dummy_url_2"
    ),
  ];

  String? _currentlyPlayingCallId;
  bool _isAudioPlaying = false;
  Timer? _audioPlaybackTimer;
  double _audioPlaybackProgress = 0.0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _addBotMessage("Halo! Ada yang bisa saya bantu terkait keluhan kesehatan Anda?");
  }

   void _addBotMessage(String text) {
     WidgetsBinding.instance.addPostFrameCallback((_) {
      if(mounted){
        setState(() {
          _messages.insert(0, ChatMessage(text: text, isUserMessage: false, timestamp: DateTime.now()));
        });
        _scrollToBottom();
      }
    });
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;
    _textController.clear();

    setState(() {
      _messages.insert(0, ChatMessage(text: text, isUserMessage: true, timestamp: DateTime.now()));
    });
    _scrollToBottom();

    String userMessageLower = text.toLowerCase();
    String? reply;

    for (var keywords in _autoReplies.keys) {
      bool match = keywords.any((keyword) => userMessageLower.contains(keyword.toLowerCase()));
      if (match) {
        reply = _autoReplies[keywords];
        break;
      }
    }

    if (reply != null) {
      Timer(const Duration(milliseconds: 800), () => _addBotMessage(reply!));
    } else {
       Timer(const Duration(milliseconds: 800), () => _addBotMessage("Mohon maaf, untuk saat ini saya belum bisa merespons. Mungkin Anda bisa menjelaskan lebih detail?"));
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  void _toggleAudioPlayback(String callId) {
    if (_isAudioPlaying && _currentlyPlayingCallId == callId) {
      _pauseAudio();
    } else {
      _playAudio(callId);
    }
  }

  void _playAudio(String callId) {
    _stopAudio();
    setState(() {
      _currentlyPlayingCallId = callId;
      _isAudioPlaying = true;
      _audioPlaybackProgress = 0.0;
    });

    _audioPlaybackTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_audioPlaybackProgress < 1.0) {
        if (mounted) {
          setState(() {
            _audioPlaybackProgress += 0.01;
          });
        }
      } else {
        _stopAudio();
      }
    });
  }

  void _pauseAudio() {
    _audioPlaybackTimer?.cancel();
    if (mounted) {
      setState(() {
        _isAudioPlaying = false;
      });
    }
  }

  void _stopAudio() {
    _audioPlaybackTimer?.cancel();
    if (mounted) {
      setState(() {
        _isAudioPlaying = false;
        _audioPlaybackProgress = 0.0;
        _currentlyPlayingCallId = null;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _textController.dispose();
    _scrollController.dispose();
    _audioPlaybackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal.shade800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(widget.doctorImageUrl),
              onBackgroundImageError: (_, __) {},
              backgroundColor: Colors.grey[200],
              child: widget.doctorImageUrl.isEmpty || !widget.doctorImageUrl.startsWith('http')
                ? Icon(Icons.person, size: 18, color: Colors.grey[400])
                : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.doctorName,
                style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.bold, fontSize: 17),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.teal.shade700,
          labelColor: Colors.teal.shade800,
          unselectedLabelColor: Colors.grey[600],
          labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          tabs: const [
            Tab(text: "Riwayat Pesan"),
            Tab(text: "Riwayat Panggilan"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChatMessagesView(theme),
          _buildCallHistoryView(theme),
        ],
      ),
    );
  }

  Widget _buildChatMessagesView(ThemeData theme) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            reverse: true,
            padding: const EdgeInsets.all(16.0),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return _buildChatMessageBubble(message, theme);
            },
          ),
        ),
        _buildChatInputArea(theme),
      ],
    );
  }

  Widget _buildChatMessageBubble(ChatMessage message, ThemeData theme) {
    final bool isUser = message.isUserMessage;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isUser ? Colors.teal.shade400 : Colors.white;
    final textColor = isUser ? Colors.white : Colors.black87;
    final borderRadius = isUser
        ? const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16))
        : const BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16));

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
            boxShadow: [if (!isUser) BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: const Offset(0, 1))]
          ),
          child: Text(message.text, style: TextStyle(fontSize: 15, color: textColor)),
        ),
         Padding(
           padding: EdgeInsets.only(
             right: isUser ? 4.0 : 0,
             left: !isUser ? 4.0 : 0,
             bottom: 8.0
            ),
           child: Text(DateFormat('HH:mm').format(message.timestamp), style: TextStyle(fontSize: 10, color: Colors.grey[500])),
         ),
      ],
    );
  }

  Widget _buildChatInputArea(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(offset: const Offset(0, -1), blurRadius: 4, color: Colors.grey.withOpacity(0.15))]),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmitted,
              decoration: InputDecoration(
                hintText: "Ketik pesan...",
                hintStyle: TextStyle(color: Colors.grey[500]),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(25.0), borderSide: BorderSide.none),
              ),
              minLines: 1, maxLines: 5, textInputAction: TextInputAction.send,
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            mini: true, onPressed: () => _handleSubmitted(_textController.text),
            backgroundColor: theme.primaryColor, elevation: 1,
            child: const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildCallHistoryView(ThemeData theme) {
    if (_callRecords.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.call_missed_outgoing, size: 70, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text("Belum ada riwayat panggilan", style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _callRecords.length,
      itemBuilder: (context, index) {
        final record = _callRecords[index];
        bool isThisAudioPlaying = _isAudioPlaying && _currentlyPlayingCallId == record.id;

        return Card(
          margin: const EdgeInsets.only(bottom: 12.0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          elevation: 2,
          color: Colors.teal.shade50.withOpacity(0.6),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(DateFormat('d MMMM yyyy', 'id_ID').format(record.timestamp), style: TextStyle(fontSize: 13, color: Colors.grey[700], fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(widget.doctorImageUrl),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(record.doctorName, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal.shade900)),
                          Text(record.callType, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                          Text("Hari ini, Pukul ${DateFormat('HH:mm').format(record.timestamp)}", style: TextStyle(fontSize: 12, color: Colors.grey[500])),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(record.durationInfo, style: TextStyle(fontSize: 14, color: Colors.grey[800])),
                const SizedBox(height: 12),
                if (record.recordingUrl != null)
                  isThisAudioPlaying && _audioPlaybackProgress > 0
                      ? _buildAudioPlayerControls(record, theme)
                      : SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            icon: Icon(Icons.play_circle_outline, color: Colors.teal.shade700),
                            label: Text("Putar Rekaman Suara", style: TextStyle(color: Colors.teal.shade700, fontWeight: FontWeight.w600)),
                            onPressed: () => _playAudio(record.id),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              side: BorderSide(color: Colors.teal.shade300),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                            ),
                          ),
                        ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAudioPlayerControls(CallRecord record, ThemeData theme) {
    return Column(
      children: [
        Container(
          height: 40,
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: List.generate(30, (index) {
              final barHeight = (index % 5 == 0 ? 30 : 15) + ( ( (index * 7) %15) * (_audioPlaybackProgress * 0.8 + 0.2) ) ;
              return Expanded(
                child: Container(
                  height: barHeight * ( ( (index * 3 + (_audioPlaybackProgress * 100).toInt()) %5)/5 * 0.5 + 0.5),
                  width: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 1.5),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade300.withOpacity(0.5 + (_audioPlaybackProgress * 0.5) ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
        LinearProgressIndicator(
          value: _audioPlaybackProgress,
          backgroundColor: Colors.teal.shade100,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade600),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(_isAudioPlaying ? Icons.pause_circle_outline : Icons.play_circle_outline, size: 20),
              label: Text(_isAudioPlaying ? "Jeda" : "Lanjut"),
              onPressed: () => _toggleAudioPlayback(record.id),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton(
              onPressed: _stopAudio,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade400),
                foregroundColor: Colors.grey.shade700,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text("Berhenti"),
            ),
          ],
        ),
      ],
    );
  }
}
