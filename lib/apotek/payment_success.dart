import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medease/riwayat/riwayat.dart';

class PaymentSuccessfulPage extends StatelessWidget {
  final double amountPaid;
  final String paymentMethod;
  final DateTime transactionDate;

  const PaymentSuccessfulPage({
    super.key,
    required this.amountPaid,
    required this.paymentMethod,
    required this.transactionDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final DateFormat dateFormatter = DateFormat('d MMMM yyyy, HH:mm', 'id_ID');
    final NumberFormat rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Pembayaran Berhasil", style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_outline_rounded, color: Colors.green.shade600, size: 80),
              ),
              const SizedBox(height: 24),
              Text(
                "Pembayaran Berhasil!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[800]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                "Anda telah berhasil melakukan pembayaran sebesar ${rupiahFormatter.format(amountPaid)} menggunakan $paymentMethod pada ${dateFormatter.format(transactionDate)}.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.5),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Kembali ke Beranda", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RiwayatTransaksiPage(userName: "Pengguna")),
                  );
                },
                child: Text(
                  "Lihat Riwayat Transaksi",
                  style: TextStyle(fontSize: 15, color: theme.primaryColor, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
