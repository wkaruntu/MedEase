// lib/features/doctor_consultation/doctor_detail_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk formatting tanggal
import 'payment_page.dart'; // Halaman selanjutnya

// Model sederhana untuk data dokter, sesuaikan jika sudah ada model global
class Doctor {
  final String id;
  final String name;
  final String category; // e.g., "Dokter Gigi", "Sp.KG"
  final String imageUrl;
  final double rating;
  final int experience;
  final int patients; // Jumlah pasien
  final String description;
  final List<Map<String, dynamic>> consultationOptions; // Misal: [{'type': 'Chat', 'price': 6}, ...]

  Doctor({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    this.rating = 0.0,
    this.experience = 0,
    this.patients = 0,
    this.description = "Deskripsi dokter tidak tersedia.",
    this.consultationOptions = const [
      {'type': 'Personal Chat', 'price': 6, 'detail': 'Konsultasi kesehatanmu via chat'},
      {'type': 'Voice Call', 'price': 11, 'detail': 'Lebih jelas jika telpon'},
      {'type': 'Video Call', 'price': 19, 'detail': 'Seperti konsultasi langsung'}
    ],
  });

  // Factory constructor untuk membuat instance Doctor dari Map (data Firestore)
  factory Doctor.fromMap(Map<String, dynamic> data, String documentId) {
    return Doctor(
      id: documentId,
      name: data['name'] ?? 'Nama Dokter',
      category: data['category'] ?? 'Spesialis',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
      rating: (data['rating'] as num?)?.toDouble() ?? 4.5,
      experience: (data['experience'] as num?)?.toInt() ?? 5,
      patients: (data['patients'] as num?)?.toInt() ?? 100, // Ambil dari data atau default
      description: data['description'] ?? 'Deskripsi lengkap dokter.',
      // Jika consultationOptions ada di Firestore, ambil dari sana
      consultationOptions: (data['consultationOptions'] as List?)
          ?.map((opt) => opt as Map<String, dynamic>)
          ?.toList() ??
          [
            {'type': 'Personal Chat', 'price': 6, 'detail': 'Konsultasi kesehatanmu via chat', 'icon': Icons.chat_bubble_outline},
            {'type': 'Voice Call', 'price': 11, 'detail': 'Lebih jelas jika telpon', 'icon': Icons.call_outlined},
            {'type': 'Video Call', 'price': 19, 'detail': 'Seperti konsultasi langsung', 'icon': Icons.videocam_outlined}
          ],
    );
  }
}


class DoctorDetailPage extends StatefulWidget {
  final Map<String, dynamic> doctorData;

  const DoctorDetailPage({super.key, required this.doctorData});

  @override
  State<DoctorDetailPage> createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  late Doctor _doctor;
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;
  Map<String, dynamic>? _selectedConsultationType;

  // Daftar waktu yang tersedia (bisa diambil dari data dokter jika ada)
  final List<String> _availableTimes = [
    "10.00", "10.30", "11.00", "11.30", "13.00", "13.30", "14.00", "14.30"
  ];

  @override
  void initState() {
    super.initState();
    // Menggunakan factory constructor untuk membuat objek Doctor
    _doctor = Doctor.fromMap(widget.doctorData, widget.doctorData['id'] ?? 'unknown_id');
    // Set default selection
    if (_doctor.consultationOptions.isNotEmpty) {
      _selectedConsultationType = _doctor.consultationOptions.first;
    }
    if (_availableTimes.isNotEmpty) {
      _selectedTime = _availableTimes.first;
    }
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
      // Reset waktu jika tanggal berubah, atau implementasi logika ketersediaan waktu per tanggal
      _selectedTime = _availableTimes.isNotEmpty ? _availableTimes.first : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dates = List.generate(7, (index) => today.add(Duration(days: index)));

    return Scaffold(
      appBar: AppBar(
        title: Text(_doctor.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800])),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.teal[700]),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(0), // Remove padding from ListView itself
        children: [
          _buildDoctorHeader(),
          _buildDoctorAbout(),
          _buildScheduleSection(dates),
          _buildConsultationTypeSection(),
        ],
      ),
      bottomNavigationBar: _buildProceedButton(context),
    );
  }

  Widget _buildDoctorHeader() {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.teal[50],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_doctor.imageUrl),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(height: 12),
          Text(
            _doctor.name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal[900]),
          ),
          Text(
            _doctor.category, // Misalnya "Spesialis Gigi" atau "General Practitioner"
            style: TextStyle(fontSize: 16, color: Colors.teal[700]),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(Icons.people_alt_outlined, "${_doctor.patients}+", "Pasien"),
              _buildStatItem(Icons.work_outline, "${_doctor.experience} Tahun", "Pengalaman"),
              _buildStatItem(Icons.star_border_outlined, "${_doctor.rating}", "Rating"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.teal[600], size: 28),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[800])),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildDoctorAbout() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tentang Dokter",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800]),
          ),
          const SizedBox(height: 8),
          Text(
            _doctor.description,
            style: TextStyle(fontSize: 14, color: Colors.grey[700], height: 1.5),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: () {
              // Aksi untuk "Pilih Jadwal" jika diperlukan, tapi jadwal sudah di bawah
              // Mungkin bisa scroll ke bagian jadwal
            },
            icon: Icon(Icons.calendar_today_outlined, size: 16, color: Colors.teal[700]),
            label: Text("Lihat Jadwal Tersedia", style: TextStyle(color: Colors.teal[700])),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[50],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.teal[200]!),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildScheduleSection(List<DateTime> dates) {
    final now = DateTime.now();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('MMMM yyyy').format(_selectedDate), // "Februari 2024"
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800]),
          ),
          const SizedBox(height: 15),
          SizedBox(
            height: 70,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dates.length,
              itemBuilder: (context, index) {
                final date = dates[index];
                final isSelected = date.year == _selectedDate.year &&
                                   date.month == _selectedDate.month &&
                                   date.day == _selectedDate.day;
                bool isPast = date.isBefore(DateTime(now.year, now.month, now.day));

                return GestureDetector(
                  onTap: isPast ? null : () => _selectDate(date),
                  child: Container(
                    width: 55,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isPast ? Colors.grey[300] : (isSelected ? Colors.teal[600] : Colors.white),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: isSelected ? Colors.teal[600]! : Colors.grey[300]!),
                      boxShadow: isSelected ? [
                        BoxShadow(color: Colors.teal.withOpacity(0.3), spreadRadius: 1, blurRadius: 3)
                      ] : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('EEE').format(date).substring(0,3), // "Mon", "Tue"
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isPast? Colors.grey[500] : (isSelected ? Colors.white : Colors.grey[700]),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('dd').format(date), // "13", "14"
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isPast? Colors.grey[500] : (isSelected ? Colors.white : Colors.teal[800]),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Jam",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800]),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: _availableTimes.map((time) {
              final isSelected = _selectedTime == time;
              return ChoiceChip(
                label: Text(time),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedTime = time;
                    });
                  }
                },
                backgroundColor: Colors.white,
                selectedColor: Colors.teal[400],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.teal[700],
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: isSelected ? Colors.teal[400]! : Colors.grey[300]!),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationTypeSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pilih Jalur Konsultasi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800]),
          ),
          const SizedBox(height: 15),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _doctor.consultationOptions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final option = _doctor.consultationOptions[index];
              final isSelected = _selectedConsultationType == option;
              IconData iconData = option['icon'] as IconData? ?? Icons.help_outline;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedConsultationType = option;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.teal[50] : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.teal[600]! : Colors.grey[300]!,
                      width: isSelected ? 1.5 : 1,
                    ),
                     boxShadow: isSelected ? [
                        BoxShadow(color: Colors.teal.withOpacity(0.2), spreadRadius: 1, blurRadius: 4)
                      ] : [
                        BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3)
                      ],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: isSelected ? Colors.teal[600] : Colors.grey[200],
                        child: Icon(iconData, size: 22, color: isSelected ? Colors.white : Colors.teal[700]),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              option['type'] as String,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[900],
                              ),
                            ),
                            const SizedBox(height: 3),
                             Text(
                              option['detail'] as String? ?? 'Detail tidak tersedia',
                              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "\$${option['price']}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[700],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildProceedButton(BuildContext context) {
    bool canProceed = _selectedTime != null && _selectedConsultationType != null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: canProceed ? () {
          // Navigasi ke halaman pembayaran
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPage(
                doctor: _doctor,
                selectedDate: _selectedDate,
                selectedTime: _selectedTime!,
                consultationType: _selectedConsultationType!,
              ),
            ),
          );
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canProceed ? Colors.teal[600] : Colors.grey[400],
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: Text("Lanjut Pembayaran", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}