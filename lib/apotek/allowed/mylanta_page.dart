import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../cart/cart.dart'; 

class MylantaDetailPage extends StatelessWidget {
  const MylantaDetailPage({super.key});

  // Fungsi format mata uang Rupiah
  String formatRupiah(double amount) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return formatCurrency.format(amount);
  }

  // Widget untuk membuat baris detail
  Widget _buildDetailRow(String label, String value, {bool isBoldValue = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isBoldValue ? FontWeight.bold : FontWeight.normal,
                color: valueColor ?? Colors.grey[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk judul section detail
  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.primaryColorDark),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const productName = "Mylanta Sirup 50 ml";
    const productUnit = "Per Botol";
    const productPrice = 31000.0;
    const productImageUrl = "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2022/3/6/ae140ee0-37d7-41de-a02a-bc2c477465fb.jpg";


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal.shade800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.share_outlined, color: Colors.teal.shade800),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Fungsi bagikan belum tersedia"), duration: Duration(seconds: 1)),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.teal.shade800),
            onPressed: () {
              // Navigasi ke halaman keranjang
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
               ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Navigasi ke keranjang (Belum Tersedia dari sini)"), duration: Duration(seconds: 1)),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                productImageUrl,
                height: 200,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.medication_liquid_outlined, size: 150, color: Colors.grey[300]),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              productName,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[900]),
            ),
            Text(
              productUnit,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              formatRupiah(productPrice),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.primaryColor),
            ),
            const SizedBox(height: 16),

            Text(
              "Pilih Opsi Pembelian",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
                side: BorderSide(color: theme.primaryColor.withOpacity(0.5))
              ),
              child: ListTile(
                title: Text(productUnit, style: const TextStyle(fontWeight: FontWeight.w500)),
                trailing: Text(formatRupiah(productPrice), style: TextStyle(fontWeight: FontWeight.bold, color: theme.primaryColor)),
              ),
            ),

            const Divider(height: 32, thickness: 1),

            Text(
              "Detail Produk",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.primaryColorDark),
            ),
            _buildSectionTitle("Kategori", theme),
            _buildDetailRow("Kategori", "Digestive System, Others, Special Offer, Medicines & Treatments, Digestive Health, GERD & Reflux, Produk Lambung Pilihan, Digestive Health, Eligible for Coupon, Digestive"),

            _buildSectionTitle("Deskripsi", theme),
            _buildDetailRow("Deskripsi", "MYLANTA SIRUP 50 ML merupakan obat dengan kandungan Aluminium Hidroksida kering, Magnesium Hidroksida, dan Simetikon dalam bentuk sirup. Obat ini digunakan untuk mengurangi gejala-gejala yang berhubungan dengan kelebihan asam lambung, gastritis, tukak lambung, tukak usus dua belas jari, dengan gejala-gejala seperti mual, nyeri lambung, nyeri ulu hati. Kombinasi Aluminium hidroksida dan Magnesium hidroksida merupakan antasida yang bekerja menetralkan asam lambung dan menginaktifkan pepsin, sehingga rasa nyeri ulu hati akibat iritasi oleh asam lambung dan pepsin berkurang. Disamping itu, efek laksatif dari Magnesium hidroksida akan mengurangi efek konstipasi dari Aluminium hidroksida."),

            _buildSectionTitle("Indikasi Umum", theme),
            _buildDetailRow("Indikasi Umum", "Obat ini digunakan untuk mengurangi gejala-gejala yang berhubungan dengan kelebihan asam lambung, gastritis, tukak lambung, tukak usus 12 jari, dengan gejala-gejala seperti mual, nyeri lambung, nyeri ulu hati."),

            _buildSectionTitle("Komposisi", theme),
            _buildDetailRow("Komposisi", "Per 5 mL : Aluminium hidroksida 200 mg, Magnesium hidroksida 200 mg, Simetikon 20 mg"),

            _buildSectionTitle("Dosis", theme),
            _buildDetailRow("Dosis", "Dewasa : 1-2 sendok takar (5-10 mL) 3-4 kali sehari. Anak-anak 6-12 tahun : 1/2 - 1 sendok takar (2.5 - 5 mL), sebanyak 3-4 kali sehari."),

            _buildSectionTitle("Aturan Pakai", theme),
            _buildDetailRow("Aturan Pakai", "Diminum 1 jam sebelum makan atau 2 jam sesudah makan dan menjelang tidur."),

            _buildSectionTitle("Perhatian", theme),
            _buildDetailRow("Perhatian", "Tidak dianjurkan untuk digunakan secara terus menerus selama lebih dari 2 minggu, kecuali atas petunjuk dokter. Bila sedang menggunakan obat tukak lambung lain seperti Simetidin atau antibiotika Tetrasiklin, harap diberikan dengan selang waktu 1-2 jam. Tidak dianjurkan pemberian pada anak-anak di bawah 6 tahun, kecuali atas petunjuk dokter, karena biasanya kurang jelas penyebab gangguan penyakitnya. Hati-hati pemberian pada penderita diet fosfor rendah dan pemakaian lama, karena dapat mengurangi kadar fosfor dalam darah."),

            _buildSectionTitle("Kontra Indikasi", theme),
            _buildDetailRow("Kontra Indikasi", "Jangan diberikan pada penderita gangguan fungsi ginjal yang berat, karena dapat menimbulkan hipermagnesia (kadar magnesium dalam darah meningkat). Tidak boleh digunakan pada pasien yang hipersensitif terhadap aluminium hidroksida, magnesium hidroksida, simetikon atau komponen lain dalam formula obat ini."),

            _buildSectionTitle("Efek Samping", theme),
            _buildDetailRow("Efek Samping", "Efek samping yang umum adalah sembelit, diare, mual, muntah, seperti terbakar di mulut atau tenggorokan, perubahan indra perasa, sakit kepala, dan ruam. Semua efek samping tersebut termasuk ringan, sementara efek samping yang lebih serius termasuk reaksi alergi yang parah dan kesulitan bernapas. Jika efek samping tersebut tidak hilang, atau bahkan memburuk, hentikan penggunaan obat dan segera hubungi dokter."), // Teks efek samping saya sesuaikan agar lebih umum dan informatif

            _buildSectionTitle("Golongan Produk", theme),
            _buildDetailRow("Golongan Produk", "Obat Bebas (Hijau)", isBoldValue: true, valueColor: Colors.green.shade700),

            _buildSectionTitle("Kemasan", theme),
            _buildDetailRow("Kemasan", "Dus, Botol @ 50 ml"),

            _buildSectionTitle("Manufaktur", theme),
            _buildDetailRow("Manufaktur", "Integrated Healthcare Indonesia"),

            _buildSectionTitle("No. Registrasi", theme),
            _buildDetailRow("No. Registrasi", "BPOM: DBL1441200233A1"),

            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionButtons(context, theme, productName),
    );
  }

  Widget _buildBottomActionButtons(BuildContext context, ThemeData theme, String productName) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0).copyWith(bottom: MediaQuery.of(context).padding.bottom + 12.0), // Menambahkan padding bawah untuk safe area
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("$productName ditambahkan ke keranjang (dummy)"), duration: const Duration(seconds: 1)),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: BorderSide(color: theme.primaryColor),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              child: Text("Tambah Keranjang", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.primaryColor)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Beli Sekarang $productName (Belum Tersedia)"), duration: const Duration(seconds: 1)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              child: const Text("Beli Sekarang"),
            ),
          ),
        ],
      ),
    );
  }
}
