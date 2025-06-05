import 'package:flutter/material.dart';

class RhinosPage extends StatelessWidget {
  const RhinosPage({super.key});

  Widget _buildDetailRow(String label, String value, {bool isBoldValue = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[800]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context);

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
                "https://placehold.co/200x150/E0F7FA/00ACC1?text=Rhinos+SR",
                height: 150,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.medication_liquid, size: 100, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              "Rhinos SR 10 Kapsul",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[900]),
            ),
            Text(
              "Per Strip",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tidak Bisa Dibeli Bebas",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.orange.shade800),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Pembelian obat keras harus dengan anjuran dokter. Konsultasikan gejalamu terlebih dahulu.",
                          style: TextStyle(fontSize: 13, color: Colors.orange.shade700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.chat_bubble_outline, size: 20),
                label: const Text("Chat dengan Dokter"),
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Fungsi Chat dengan Dokter belum tersedia"), duration: Duration(seconds: 1)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const Divider(height: 32, thickness: 1),

            Text(
              "Detail Produk",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[900]),
            ),
            _buildSectionTitle("Kategori"),
            _buildDetailRow("Kategori", "Cough and Flu, Medicines & Treatments, Cough, Cold & Flu, Cough & Flu Relief, Eligible for Coupon"),

            _buildSectionTitle("Deskripsi"),
            _buildDetailRow("Deskripsi", "RHINOS SR merupakan obat dengan kandungan Pseudoephedrine HCI dan Loratadine dalam bentuk kapsul lepas lambat. Obat ini dapat meredakan gejala yang berhubungan dengan rinitis alergi misalnya flu, bersin, pilek, hidung tersumbat, rinore, ruam kulit, pruritus (gatal pada kulit) & lakrimasi (mata gatal dan berair). Dalam penggunaan obat ini harus SESUAI DENGAN PETUNJUK DOKTER."),

            _buildSectionTitle("Indikasi Umum"),
            _buildDetailRow("Indikasi Umum", "INFORMASI OBAT INI HANYA UNTUK KALANGAN MEDIS. Meredakan gejala yang berhubungan dengan rinitis alergi misalnya bersin, hidung tersumbat, rinore, pruritus & lakrimasi."),

            _buildSectionTitle("Komposisi"),
            _buildDetailRow("Komposisi", "Tiap Kapsul mengandung: Loratadine 5 mg, Pseudoephedrine HCL 120 mg."),

            _buildSectionTitle("Dosis"),
            _buildDetailRow("Dosis", "PENGGUNAAN OBAT INI HARUS SESUAI DENGAN PETUNJUK DOKTER. Dewasa dan anak diatas 12 tahun: 1 kapsul, 2 kali perhari atau setiap 12 jam."),

            _buildSectionTitle("Aturan Pakai"),
            _buildDetailRow("Aturan Pakai", "Diminum sebelum atau sesudah makan."),

            _buildSectionTitle("Perhatian"),
            _buildDetailRow("Perhatian", "HARUS DENGAN RESEP DOKTER. Hipertensi, DM, insufisiensi hati & ginjal, glaukoma, ulkus peptikum stenosis, obstruksi piloroduodenal, hipertrofi prostat, obstruksi leher kandung kemih, penyakit KV, peningkatan TIO. Dapat menyebabkan penyalahgunaan obat. Kehamilan & laktasi. Anak <12 thn. Lansia >60 thn. Kategori Kehamilan: Belum terdapat data keamanan terkait penggunaan obat ini pada wanita hamil dan/atau menyusui. Konsultasikan kepada dokter apabila Anda sedang hamil dan/atau menyusui."),

            _buildSectionTitle("Kontra Indikasi"),
            _buildDetailRow("Kontra Indikasi", "Hipersensitivitas terhadap agen adrenergik. Penyakit KV misalnya, insufisiensi koroner, aritmia, pasien yang menerima terapi MAOI atau dalam 10 hari setelah penghentian pengobatan tersebut. Glaukoma sudut sempit, retensi urin, hipertensi berat, CAD berat, hipertiroidisme."),

            _buildSectionTitle("Efek Samping"),
            _buildDetailRow("Efek Samping", "Pemakaian obat umumnya memiliki efek samping tertentu dan sesuai dengan masing-masing individu. Jika terjadi efek samping yang berlebih dan berbahaya, harap konsultasikan kepada tenaga medis. Efek samping yang mungkin terjadi dalam penggunaan obat adalah: gangguan GI, palpitasi, takikardia & ekstrasistol."),

            _buildSectionTitle("Golongan Produk"),
            _buildDetailRow("Golongan Produk", "Obat Keras (Merah)", isBoldValue: true, valueColor: Colors.red.shade700),

            _buildSectionTitle("Kemasan"),
            _buildDetailRow("Kemasan", "Dus, 5 Blister @ 10 Kapsul pelepasan lambat."),

            _buildSectionTitle("Manufaktur"),
            _buildDetailRow("Manufaktur", "Dexa Medica"),

            _buildSectionTitle("No. Registrasi"),
            _buildDetailRow("No. Registrasi", "BPOM: DKL9905028303A1"),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
