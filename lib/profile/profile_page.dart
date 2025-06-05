import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'account_info_page.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get currentUser => _auth.currentUser;
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      if (Navigator.canPop(context)) {
         Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal keluar: ${e.toString()}")),
      );
    }
  }
}


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseService _firebaseService = FirebaseService();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = _firebaseService.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String displayName = _currentUser?.displayName ?? _currentUser?.email?.split('@').first ?? "Pengguna MedEase";
    String email = _currentUser?.email ?? "email@example.com";
    String photoUrl = _currentUser?.photoURL ?? "https://placehold.co/100x100/E0F7FA/00796B?text=${displayName.isNotEmpty ? displayName[0].toUpperCase() : 'P'}";


    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal.shade800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Profil",
          style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildProfileHeader(theme, photoUrl, displayName, email),
          _buildProfileMenuItem(
            theme,
            icon: Icons.account_circle_outlined,
            text: "Informasi Akun",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountInfoPage(
                  initialName: displayName,
                  initialPhoneNumber: _currentUser?.phoneNumber ?? "0812-1810-1790",
                  initialEmail: email,
                )),
              );
            },
          ),
          _buildProfileMenuItem(
            theme,
            icon: Icons.quiz_outlined,
            text: "FAQs",
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Halaman FAQs belum tersedia"), duration: Duration(seconds: 1)),
              );
            },
          ),
          _buildProfileMenuItem(
            theme,
            icon: Icons.info_outline,
            text: "Tentang Kami",
            onTap: () {
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Halaman Tentang Kami belum tersedia"), duration: Duration(seconds: 1)),
              );
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: OutlinedButton(
              onPressed: () async {
                await _firebaseService.signOut(context);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.red.shade300),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: Text("Keluar Akun", style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600)),
            ),
          ),
           const SizedBox(height: 30),

        ],
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, String photoUrl, String displayName, String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      decoration: BoxDecoration(
        color: Colors.teal.shade300.withOpacity(0.8),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                backgroundImage: NetworkImage(photoUrl),
                onBackgroundImageError: (exception, stackTrace) {
                },
                child: photoUrl.contains("placehold.co")
                    ? Text(
                        displayName.isNotEmpty ? displayName[0].toUpperCase() : 'P',
                        style: TextStyle(fontSize: 40, color: Colors.teal.shade700, fontWeight: FontWeight.bold),
                      )
                    : null,
              ),
              Container(
                decoration: BoxDecoration(
                  color: theme.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2)
                ),
                padding: const EdgeInsets.all(4),
                child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(
            displayName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          Text(
            email,
            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.9)),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHeaderActionItem(theme, Icons.calendar_today_outlined, "Buat Janji"),
              _buildHeaderActionItem(theme, Icons.chat_bubble_outline, "Konsultasi"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeaderActionItem(ThemeData theme, IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12)
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 13)),
      ],
    );
  }

  Widget _buildProfileMenuItem(ThemeData theme, {required IconData icon, required String text, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: theme.primaryColorDark),
        title: Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[500]),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      ),
    );
  }
}
