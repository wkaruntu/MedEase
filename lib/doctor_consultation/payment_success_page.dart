// lib/features/doctor_consultation/payment_success_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String doctorName;
  final String consultationType;
  final DateTime date;
  final String time;

  const PaymentSuccessPage({
    super.key,
    required this.doctorName,
    required this.consultationType,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Tidak ada tombol kembali
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.grey[700]),
            onPressed: () {
              // Kembali ke HomePage (atau halaman utama aplikasi Anda)
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[700], // Warna biru dari gambar
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 70),
              ),
              const SizedBox(height: 30),
              Text(
                "Pembayaran Berhasil!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Text(
                "Anda telah berhasil membuat janji konsultasi dengan $doctorName untuk $consultationType pada ${DateFormat('EEEE, dd MMM yyyy').format(date)} pukul $time.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Arahkan ke halaman Riwayat Pesanan/Transaksi
                  // Jika halaman Riwayat belum siap, bisa kembali ke Home
                  // Navigator.pushReplacementNamed(context, '/history'); // Contoh jika menggunakan named routes
                  ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text("Navigasi ke Riwayat Pesan (Belum Tersedia)")),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst); // Kembali ke home untuk sementara
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.blue[700],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )
                ),
                child: const Text("Lihat Riwayat Pesan"),
              ),
              const SizedBox(height: 15),
               TextButton(
                onPressed: () {
                   Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Text(
                  "Kembali ke Beranda",
                  style: TextStyle(color: Colors.grey[600], fontSize: 15)
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}