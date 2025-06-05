import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String notificationDateString = "Hari ini - 15 April 2025";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          "Notifikasi",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            notificationDateString,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16.0),
          _buildNotificationItem(
            context,
            icon: Icons.calendar_today,
            iconColor: Colors.blue.shade700,
            title:
                "Anda memiliki janji temu dengan Dr. Dewi hari ini pada pukul 13.00.",
            timeAgo: "Baru Saja",
            timeColor: Colors.blue.shade700,
          ),
          const Divider(height: 1, indent: 56, endIndent: 16),
          _buildNotificationItem(
            context,
            icon: Icons.person_outline,
            iconColor: Colors.green.shade700,
            title:
                "Lengkapi profil agar kami dapat menyinkronisasikan apa yang terbaik untukmu!",
            timeAgo: "1 Menit Lalu",
            timeColor: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String timeAgo,
    Color? timeColor, 
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(width: 16.0), 
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[850],
                    height: 1.4, 
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  timeAgo,
                  style: TextStyle(
                    fontSize: 12,
                    color: timeColor ?? Colors.grey[600],
                    fontWeight: (timeAgo == "Baru Saja") ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}