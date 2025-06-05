// lib/features/doctor_consultation/payment_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'doctor_detail_page.dart'; // Untuk mengakses model Doctor
import 'payment_success_page.dart'; // Halaman selanjutnya

class PaymentPage extends StatefulWidget {
  final Doctor doctor;
  final DateTime selectedDate;
  final String selectedTime;
  final Map<String, dynamic> consultationType;

  const PaymentPage({
    super.key,
    required this.doctor,
    required this.selectedDate,
    required this.selectedTime,
    required this.consultationType,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String? _selectedPaymentMethod;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Mastercard', 'icon': Icons.credit_card, 'imageAsset': null}, // Ganti dengan AssetImage jika punya
    {'name': 'Google Pay', 'icon': null, 'imageAsset': 'assets/icons/google_pay.png'}, // Contoh path, pastikan ada asetnya
    {'name': 'Apple Pay', 'icon': null, 'imageAsset': 'assets/icons/apple_pay.png'}, // Contoh path
    {'name': 'Paypal', 'icon': null, 'imageAsset': 'assets/icons/paypal.png'}, // Contoh path
  ];

  // Pastikan Anda membuat folder assets/icons/ dan menambahkan gambar yang sesuai
  // atau gunakan Icons jika tidak ada gambar.

  @override
  Widget build(BuildContext context) {
    final consultationPrice = widget.consultationType['price'] as num;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[800])),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.teal[700]),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          _buildOrderSummary(),
          const SizedBox(height: 25),
          Text(
            "Pilih Metode Pembayaran",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.teal[800]),
          ),
          const SizedBox(height: 15),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _paymentMethods.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final method = _paymentMethods[index];
              final isSelected = _selectedPaymentMethod == method['name'];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPaymentMethod = method['name'] as String;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? Colors.teal[600]! : Colors.grey[300]!,
                      width: isSelected ? 1.5 : 1,
                    ),
                    boxShadow: [
                       BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 3)
                    ]
                  ),
                  child: Row(
                    children: [
                      if (method['imageAsset'] != null)
                        Image.asset(method['imageAsset'] as String, width: 36, height: 36, errorBuilder: (context, error, stackTrace) => Icon(Icons.payment, size: 28, color: Colors.grey[600]))
                      else if (method['icon'] != null)
                        Icon(method['icon'] as IconData, size: 28, color: Colors.teal[700]),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Text(
                          method['name'] as String,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey[800]),
                        ),
                      ),
                      if (isSelected)
                        Icon(Icons.check_circle, color: Colors.teal[600]),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildPayButton(context, consultationPrice.toDouble()),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Detail Konsultasi",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[800]),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(widget.doctor.imageUrl),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.doctor.name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                  Text(widget.consultationType['type'] as String, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                ],
              )
            ],
          ),
          const Divider(height: 25),
          _summaryRow("Jadwal:", "${DateFormat('dd MMM yyyy').format(widget.selectedDate)}, Pukul ${widget.selectedTime}"),
          const SizedBox(height: 5),
          _summaryRow("Harga Konsultasi:", "\$${widget.consultationType['price']}"),
          // Bisa ditambahkan biaya admin atau lainnya jika ada
          const Divider(height: 25),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total Pembayaran:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal[900])),
              Text(
                "\$${widget.consultationType['price']}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800])),
      ],
    );
  }


  Widget _buildPayButton(BuildContext context, double amount) {
     bool canPay = _selectedPaymentMethod != null;
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
        onPressed: canPay ? () {
          // Simulasi pembayaran
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Memproses pembayaran dengan $_selectedPaymentMethod..."),
              backgroundColor: Colors.blue,
            ),
          );
          // Delay untuk simulasi
          Future.delayed(const Duration(seconds: 2), () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentSuccessPage(
                  doctorName: widget.doctor.name,
                  consultationType: widget.consultationType['type'] as String,
                  date: widget.selectedDate,
                  time: widget.selectedTime,
                ),
              ),
              (Route<dynamic> route) => route.isFirst, // Hapus semua rute sebelumnya sampai HomePage
            );
          });
        } : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: canPay ? Colors.red[600] : Colors.grey[400],
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        child: Text("Bayar Sekarang (\$$amount)", style: TextStyle(color: Colors.white)),
      ),
    );
  }
}