import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Untuk format mata uang

import 'payment.dart'; // Pastikan file 'payment.dart' mendefinisikan PaymentSummaryPage


// Model data sederhana untuk item di keranjang
class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final String unit; // Contoh: "Per Botol"
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.unit,
    required this.price,
    this.quantity = 1,
  });
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final NumberFormat _rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  // Data contoh untuk item di keranjang
  final List<CartItem> _cartItems = [
    CartItem(
      id: 'item1',
      name: "Mylanta Sirup 50 ml",
      imageUrl: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2022/3/6/ae140ee0-37d7-41de-a02a-bc2c477465fb.jpg",
      unit: "Per Botol",
      price: 31000,
      quantity: 1,
    ),
    CartItem(
      id: 'item2',
      name: "Vitamin D3 1000 IU",
      imageUrl: "https://images.tokopedia.net/img/cache/500-square/VqbcmM/2024/5/23/254a124e-ace2-4b75-abd9-7d831cb91df6.jpg",
      unit: "Per Strip",
      price: 75000,
      quantity: 2,
    ),
  ];

  bool _isSecurityProtectionEnabled = true;
  final double _securityProtectionPrice = 550;

  double _calculateTotalPrice() {
    double itemsTotal = _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
    if (_isSecurityProtectionEnabled) {
      itemsTotal += _securityProtectionPrice;
    }
    return itemsTotal;
  }

  void _updateQuantity(int index, int newQuantity) {
    if (newQuantity > 0) {
      setState(() {
        _cartItems[index].quantity = newQuantity;
      });
    } else {
      _removeItem(index);
    }
  }

  void _removeItem(int index) {
    String itemName = _cartItems[index].name; 
    setState(() {
      _cartItems.removeAt(index);
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$itemName dihapus dari keranjang"), duration: const Duration(seconds: 2)),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.primaryColorDark ?? theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Keranjang",
          style: TextStyle(color: theme.primaryColorDark ?? theme.colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: _cartItems.isEmpty
                ? _buildEmptyCart(theme)
                : ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildDeliveryInfoSection(theme),
                      _buildContactInfoSection(theme),
                      _buildCartItemsSection(theme),
                      _buildSecurityProtectionSection(theme),
                      const SizedBox(height: 20), 
                    ],
                  ),
          ),
          
          _buildPaymentSummarySection(theme),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(ThemeData theme) {
    return Center(
      child: Padding( 
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "Keranjang Anda kosong",
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              "Yuk, isi dengan barang-barang menarik!",
              textAlign: TextAlign.center, 
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst); 
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              ),
              child: const Text("Mulai Belanja"),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer(Widget child, {EdgeInsetsGeometry? padding, Color? color, bool addMargin = true}) {
    return Container(
      width: double.infinity,
      color: color ?? Colors.white,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      margin: addMargin ? const EdgeInsets.only(bottom: 8.0) : null,
      child: child,
    );
  }

  Widget _buildDeliveryInfoSection(ThemeData theme) {
    return _buildSectionContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Diantar ke", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color ?? theme.colorScheme.onSurface)),
          const SizedBox(height: 4),
          Text("JL. Menteng Atas Barat", style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurfaceVariant)),
          Text("JL. Menteng Atas Barat, Gg x No. xx.", style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
              hintText: "(Wajib) : Tambah detail lokasi",
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey[500]),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: theme.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection(ThemeData theme) {
    return _buildSectionContainer(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Kontak Penerima", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color ?? theme.colorScheme.onSurface)),
                const SizedBox(height: 4),
                Text("Luthfi Halimawan - 08123456789", style: TextStyle(fontSize: 14, color: theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurfaceVariant), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: theme.primaryColor),
            onPressed: () {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Edit kontak (Belum Tersedia)"), duration: Duration(seconds: 1)),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemsSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionContainer(
           Padding(
             padding: const EdgeInsets.only(bottom:0.0, top: 4.0),
             child: Text("Barang", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color ?? theme.colorScheme.onSurface)),
           ),
           
           addMargin: _cartItems.isNotEmpty,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _cartItems.length,
          itemBuilder: (context, idx) {
            CartItem item = _cartItems[idx];
            return _buildSectionContainer(
              Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.broken_image_outlined, color: Colors.grey[400], size: 30);
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                            Text(item.unit, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(_rupiahFormatter.format(item.price), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.primaryColorDark ?? theme.colorScheme.onSurface)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
                        onPressed: () => _removeItem(idx),
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                        tooltip: "Hapus item",
                      ),
                      const Spacer(),
                      _buildQuantityButton(Icons.remove, () => _updateQuantity(idx, item.quantity - 1), theme),
                      Container(
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(item.quantity.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                      _buildQuantityButton(Icons.add, () => _updateQuantity(idx, item.quantity + 1), theme),
                    ],
                  ),
                ],
              ),
              addMargin: idx < _cartItems.length -1,
            );
          },
        ),
      ],
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed, ThemeData theme) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Icon(icon, size: 20, color: theme.primaryColor),
      ),
    );
  }

  Widget _buildSecurityProtectionSection(ThemeData theme) {
    return _buildSectionContainer(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Proteksi Keamanan", style: TextStyle(fontSize: 15, color: theme.textTheme.bodyMedium?.color ?? theme.colorScheme.onSurfaceVariant)),
          Row(
            children: [
              Text(_rupiahFormatter.format(_securityProtectionPrice), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.primaryColorDark ?? theme.colorScheme.onSurface)),
              Checkbox(
                value: _isSecurityProtectionEnabled,
                onChanged: (bool? value) {
                  setState(() {
                    _isSecurityProtectionEnabled = value ?? false;
                  });
                },
                activeColor: theme.primaryColor,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget _buildPaymentSummarySection(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton.icon(
            icon: Icon(Icons.confirmation_number_outlined, color: theme.primaryColor),
            label: Text("Pakai Kupon & Makin Hemat!", style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold)),
            onPressed: () {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Fitur kupon belum tersedia"), duration: Duration(seconds: 1)),
                );
              }
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 44),
              side: BorderSide(color: theme.primaryColor.withOpacity(0.5)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Pembayaranmu", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  Text(_rupiahFormatter.format(_calculateTotalPrice()), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.primaryColorDark ?? theme.colorScheme.onSurface)),
                ],
              ),
              ElevatedButton(
                onPressed: _cartItems.isEmpty ? null : () {
                  if (mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentSummaryPage(totalAmount: _calculateTotalPrice()),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                child: const Text("Lanjut Bayar"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
