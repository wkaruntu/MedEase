import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medease/doctor_consultation/doctor_detail_page.dart';
import 'apotek/apotek.dart';
import 'riwayat/riwayat.dart';
import 'chat/chat.dart';
import 'profile/profile_page.dart';
import 'notification_page.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Berhasil keluar"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal keluar: ${e.toString()}"), backgroundColor: Colors.red),
        );
      }
    }
  }

  Stream<List<Map<String, dynamic>>> getDoctorsStream() {
    return _firestore.collection('doctors').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();
  User? _currentUser;
  int _selectedIndex = 0;
  String? _selectedDoctorCategory = "Dokter Gigi";
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUser = _firebaseService.currentUser;
    _searchController.addListener(() {
      if (mounted) {
        setState(() {
          _searchQuery = _searchController.text.toLowerCase();
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetToHomeTab() {
    if (mounted && _selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
    }
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index && index !=0) return;

    if (index != 0 && _searchQuery.isNotEmpty) {
        _searchController.clear();
    }


    if (index == 0) {
        setState(() {
          _selectedIndex = index;
        });
    } else if (index == 1) {
      setState(() { _selectedIndex = index; });
      Navigator.push(context, MaterialPageRoute(builder: (context) => const RiwayatTransaksiPage()))
          .then((_) => _resetToHomeTab());
    } else if (index == 2) {
      setState(() { _selectedIndex = index; });
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatPage()))
          .then((_) => _resetToHomeTab());
    } else if (index == 3) {
      setState(() { _selectedIndex = index; });
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()))
          .then((_) => _resetToHomeTab());
    }
  }

  @override
  Widget build(BuildContext context) {
    String displayName = _currentUser?.displayName ?? _currentUser?.email?.split('@').first ?? "Pengguna";
    if (displayName.length > 15) {
      displayName = "${displayName.substring(0, 12)}...";
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          children: [
            _buildHeader(context, displayName),
            const SizedBox(height: 20),
            _buildSearchBar(context),
            const SizedBox(height: 25),
            _buildActionIcons(context),
            const SizedBox(height: 30),
            _buildTopDoctorsSection(context),
            const SizedBox(height: 10),
            _buildDoctorListStream(context),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader(BuildContext context, String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat Datang,",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              Text(
                userName,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800]),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none_outlined, color: Colors.teal[700], size: 28),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationPage()),
                  ).then((_) => _resetToHomeTab());
                },
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()))
                      .then((_) => _resetToHomeTab());
                },
                child: CircleAvatar(
                  backgroundColor: Colors.teal[600],
                  backgroundImage: _currentUser?.photoURL != null ? NetworkImage(_currentUser!.photoURL!) : null,
                  onBackgroundImageError: _currentUser?.photoURL != null ? (_, __) {} : null,
                  child: _currentUser?.photoURL == null || _currentUser!.photoURL!.isEmpty
                      ? Text(
                          userName.isNotEmpty ? userName[0].toUpperCase() : "U",
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

 Widget _buildSearchBar(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: "Cari dokter, spesialisasi, keluhan...",
        hintStyle: TextStyle(color: Colors.grey[500]),
        prefixIcon: Icon(Icons.search, color: Colors.teal[700]),
        suffixIcon: _searchQuery.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: Colors.teal[700]),
                onPressed: () {
                  _searchController.clear();
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
      ),
    ),
  );
}


  Widget _buildActionIcons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _actionIcon(context, Icons.medical_services_outlined, "Konsultasi", Colors.blue, onTap: () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pilih dokter di bawah untuk konsultasi.")));
            }
          }),
          _actionIcon(context, Icons.calendar_today_outlined, "Buat Janji", Colors.orange, onTap: () {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur Buat Janji (Belum Tersedia)")));
            }
          }),
          _actionIcon(context, Icons.local_pharmacy_outlined, "Apotek", Colors.green, onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PharmacyPage()),
            ).then((_) => _resetToHomeTab());
          }),
        ],
      ),
    );
  }

  Widget _actionIcon(BuildContext context, IconData icon, String label, Color color, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, size: 30, color: color),
            ),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 13, color: Colors.grey[800], fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildTopDoctorsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _searchQuery.isNotEmpty
                  ? "Hasil Pencarian"
                  : (_selectedDoctorCategory == null ? "Semua Dokter" : "Dokter Teratas"),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800]),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedDoctorCategory = null; 
                    _searchController.clear();
                  });
                },
                child: const Text("Lihat Semua", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _doctorCategoryChip("Dokter Gigi"),
                _doctorCategoryChip("Spesialis THT"),
                _doctorCategoryChip("Psikolog"),
                _doctorCategoryChip("Umum"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _doctorCategoryChip(String label) {
    bool isSelected = _selectedDoctorCategory == label;
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          if (selected) {
            setState(() {
              _selectedDoctorCategory = label;
            });
          }
        },
        backgroundColor: Colors.white,
        selectedColor: Colors.teal[400],
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.teal[700], fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: isSelected ? Colors.teal[400]! : Colors.grey[300]!),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      ),
    );
  }

Widget _buildDoctorListStream(BuildContext context) {
  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: _firebaseService.getDoctorsStream(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        print("Error Firestore: ${snapshot.error}");
        return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("Belum ada data dokter."));
      }

      List<Map<String, dynamic>> allDoctorsFromFirestore = snapshot.data!;
      List<Map<String, dynamic>> filteredByCategoryDoctors;

      if (_selectedDoctorCategory == null) {
        filteredByCategoryDoctors = allDoctorsFromFirestore;
      } else {
        filteredByCategoryDoctors = allDoctorsFromFirestore
            .where((doctor) => doctor["category"] == _selectedDoctorCategory)
            .toList();
      }

      final List<Map<String, dynamic>> doctorsToDisplay;
      if (_searchQuery.isEmpty) {
        doctorsToDisplay = filteredByCategoryDoctors;
      } else {
        doctorsToDisplay = filteredByCategoryDoctors.where((doctor) {
          final String name = (doctor['name'] as String? ?? "").toLowerCase();
          final String category = (doctor['category'] as String? ?? "").toLowerCase();
          final String description = (doctor['description'] as String? ?? "").toLowerCase();

          return name.contains(_searchQuery) ||
                 category.contains(_searchQuery) ||
                 description.contains(_searchQuery);
        }).toList();
      }

      if (doctorsToDisplay.isEmpty) {
        String message;
        if (_searchQuery.isNotEmpty) {
          message = "Tidak ada dokter yang cocok dengan pencarian '$_searchQuery'";
          if (_selectedDoctorCategory != null) {
            message += " untuk kategori '$_selectedDoctorCategory'.";
          } else {
            message += ".";
          }
        } else if (_selectedDoctorCategory != null) {
          message = "Tidak ada dokter ditemukan untuk kategori '$_selectedDoctorCategory'.";
        } else {
          message = "Tidak ada dokter yang tersedia saat ini.";
        }
        return Container(
          padding: const EdgeInsets.all(20.0),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 50, color: Colors.grey[400]),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: doctorsToDisplay.length,
        itemBuilder: (context, index) {
          final doctor = doctorsToDisplay[index];
          return _doctorCard(context, doctor);
        },
      );
    },
  );
}


  Widget _doctorCard(BuildContext context, Map<String, dynamic> doctorData) {
    String name = doctorData["name"] ?? "Nama Dokter Tidak Tersedia";
    String description = doctorData["description"] ?? "Deskripsi tidak tersedia.";
    String imageUrl = doctorData["imageUrl"] ?? "https://placehold.co/100x100/E0F2F1/00796B?text=N/A";
    double rating = (doctorData["rating"] as num?)?.toDouble() ?? 0.0;
    int experience = (doctorData["experience"] as num?)?.toInt() ?? 0;
    String shortLabel = doctorData["shortLabel"] ?? doctorData["category"] ?? (name.split(" ").length > 1 ? name.split(" ").last : name.split(" ").first);


    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      elevation: 2,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(imageUrl),
                  onBackgroundImageError: (_, __) {},
                    backgroundColor: Colors.teal.withOpacity(0.1),
                ),
                const SizedBox(height: 8),
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.teal[600],
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(
                      shortLabel,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                ),
              ],
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[900]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber[600], size: 16),
                      const SizedBox(width: 4),
                      Text("$rating/5", style: TextStyle(fontSize: 12, color: Colors.grey[800], fontWeight: FontWeight.w500)),
                      const SizedBox(width: 3),
                      Text("($experience Thn)", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DoctorDetailPage(doctorData: doctorData),
                  ),
                ).then((_) => _resetToHomeTab());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
              ),
              child: const Text("Konsultasi", style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history_outlined),
          activeIcon: Icon(Icons.history),
          label: 'Riwayat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble_outline),
          activeIcon: Icon(Icons.chat_bubble),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profil',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.teal[700],
      unselectedItemColor: Colors.grey[500],
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      elevation: 8.0,
    );
  }
}