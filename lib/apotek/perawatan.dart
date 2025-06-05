import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'restricted/rhinos_page.dart';
import 'allowed/mylanta_page.dart';
import 'cart/cart.dart';

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String unit;
  final double price;
  final double? priceRangeMax;
  final String? additionalInfo;
  final bool requiresPrescription;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.unit,
    required this.price,
    this.priceRangeMax,
    this.additionalInfo,
    this.requiresPrescription = false,
  });
}

class DrugTreatmentPage extends StatefulWidget {
  const DrugTreatmentPage({super.key});

  @override
  State<DrugTreatmentPage> createState() => _DrugTreatmentPageState();
}

class _DrugTreatmentPageState extends State<DrugTreatmentPage> {
  String formatRupiah(double amount, {double? maxAmount}) {
    final formatCurrency = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    if (maxAmount != null && maxAmount > amount && maxAmount != 0) {
      return "${formatCurrency.format(amount)} - ${formatCurrency.format(maxAmount)}";
    }
    return formatCurrency.format(amount);
  }

  final List<Product> _bestSellingProducts = [
    Product(id: 'bs1', name: "Interlac Sachet", imageUrl: "https://placehold.co/120x120/E3F2FD/2196F3?text=Interlac", unit: "Per Sachet", price: 0, additionalInfo: "Chat Dengan Dokter", requiresPrescription: true),
    Product(id: 'bs2', name: "Mucera 30mg 10 Tablet", imageUrl: "https://placehold.co/120x120/FFF9C4/FFEB3B?text=Mucera", unit: "Per Box", price: 20200),
    Product(id: 'bs3', name: "Mylanta Sirup 50 ml", imageUrl: "https://placehold.co/120x120/E8F5E9/4CAF50?text=Mylanta", unit: "Per Botol", price: 48500, priceRangeMax: 0),
  ];

  final List<Product> _coughFluProducts = [
    Product(id: 'cf1', name: "Sanadryl Expectorant Sirup 60 ml", imageUrl: "https://placehold.co/120x120/E1F5FE/03A9F4?text=Sanadryl", unit: "Per Botol", price: 31000),
    Product(id: 'cf2', name: "OBH Combi Batuk Plus Flu Sachet", imageUrl: "https://placehold.co/120x120/F1F8E9/8BC34A?text=OBH+Combi", unit: "Per Box", price: 38500, priceRangeMax: 50500),
    Product(id: 'cf3', name: "Rhinos SR 10 Kapsul", imageUrl: "https://placehold.co/120x120/FFFDE7/FFC107?text=Rhinos", unit: "Per Strip", price: 0, additionalInfo: "Chat Dengan Dokter", requiresPrescription: true),
    Product(id: 'cf4', name: "Triaminic Plus 10 Tablet", imageUrl: "https://placehold.co/120x120/F3E5F5/9C27B0?text=Triaminic", unit: "Per Strip", price: 0, additionalInfo: "Chat Dengan Dokter", requiresPrescription: true),
  ];

  final List<Product> _digestiveProducts = [
    Product(id: 'dp1', name: "Mylanta Sirup 150 ml", imageUrl: "https://placehold.co/120x120/E8F5E9/4CAF50?text=Mylanta+L", unit: "Per Botol", price: 48000, priceRangeMax: 56700),
    Product(id: 'dp2', name: "New Diatabs 4 Tablet", imageUrl: "https://placehold.co/120x120/E0E0E0/9E9E9E?text=Diatabs", unit: "Per Strip", price: 2300, priceRangeMax: 3300),
    Product(id: 'dp3', name: "Lansoprazole 30 mg 10 Kapsul", imageUrl: "https://placehold.co/120x120/BBDEFB/42A5F5?text=Lanso", unit: "Per Strip", price: 16300),
    Product(id: 'dp4', name: "Ondansetron 8 mg 10 Kapsul", imageUrl: "https://placehold.co/120x120/FFCCBC/FF5722?text=Ondan", unit: "Per Strip", price: 65400),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal.shade800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Perawatan dan Obat",
          style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _buildProductSection(context, title: "Penjualan Terbaik", products: _bestSellingProducts, showViewMore: false),
          _buildProductSection(context, title: "Batuk & Flu", products: _coughFluProducts),
          _buildProductSection(context, title: "Masalah Pencernaan", products: _digestiveProducts),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProductSection(BuildContext context, {required String title, required List<Product> products, bool showViewMore = true}) {
    return Container(
      margin: const EdgeInsets.only(top: 12.0),
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal.shade800),
            ),
          ),
          const SizedBox(height: 12),
          GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: 0.62,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductItem(products[index]);
            },
          ),
          if (showViewMore)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextButton(
                  onPressed: () {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Lihat Lebih Banyak untuk $title (Belum Tersedia)"), duration: const Duration(seconds: 1)),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Lihat Lebih Banyak", style: TextStyle(color: Colors.teal.shade700, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 14, color: Colors.teal.shade700),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          if (product.name == "Rhinos SR 10 Kapsul") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RhinosPage()),
            );
          } else if (product.name.toLowerCase().contains("mylanta")) {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const MylantaDetailPage()),
             );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Halaman detail untuk ${product.name} (Mylanta) belum tersedia."), duration: const Duration(seconds: 1)),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Halaman detail untuk ${product.name} belum tersedia."), duration: const Duration(seconds: 1)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.network(
                    product.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 60, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                product.additionalInfo ?? product.unit,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
              const Spacer(),
              Text(
                product.price > 0 ? formatRupiah(product.price, maxAmount: product.priceRangeMax) : "",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.teal.shade700),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: product.requiresPrescription
                    ? OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Chat dengan Dokter untuk ${product.name} (Belum Tersedia)"), duration: const Duration(seconds: 1)),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: BorderSide(color: Colors.orange.shade400),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        child: Text("Chat Dengan Dokter", style: TextStyle(color: Colors.orange.shade700, fontWeight: FontWeight.w600, fontSize: 11)),
                      )
                    : OutlinedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("${product.name} ditambahkan ke keranjang (dummy)"), duration: const Duration(seconds: 1)),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CartPage()),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          side: BorderSide(color: Colors.teal.shade400),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                        ),
                        child: Text("Tambah", style: TextStyle(color: Colors.teal.shade700, fontWeight: FontWeight.w600)),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
