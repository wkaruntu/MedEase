import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'perawatan.dart';

class ProductCategory {
  final String id;
  final String label;
  final IconData icon;
  final Color color;
  final Widget? targetPage;

  ProductCategory({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    this.targetPage,
  });
}

class Product {
  final String id;
  final String name;
  final String imageUrl;
  final String unit;
  final double price;
  final double? originalPrice;
  final int? discountPercentage;

  Product({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.unit,
    required this.price,
    this.originalPrice,
    this.discountPercentage,
  });
}

class OfficialStore {
  final String id;
  final String name;
  final String logoUrl;

  OfficialStore({
    required this.id,
    required this.name,
    required this.logoUrl
  });
}

class PharmacyPage extends StatefulWidget {
  const PharmacyPage({super.key});

  @override
  State<PharmacyPage> createState() => _PharmacyPageState();
}

class _PharmacyPageState extends State<PharmacyPage> {
  final TextEditingController _searchController = TextEditingController();
  final NumberFormat _rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  late List<ProductCategory> _categories;
  late List<Product> _featuredProducts;
  late List<OfficialStore> _officialStores;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  void _loadMockData() {
    _categories = [
      ProductCategory(id: 'cat1', label: 'Perawatan & Obat', icon: Icons.healing_outlined, color: Colors.blue.shade700, targetPage: const DrugTreatmentPage()),
      ProductCategory(id: 'cat2', label: 'Produk Rekomendasi', icon: Icons.recommend_outlined, color: Colors.green.shade700, targetPage: null), // Belum ada halaman target
      ProductCategory(id: 'cat3', label: 'Vitamin & Suplemen', icon: Icons.medication_liquid_outlined, color: Colors.orange.shade700, targetPage: null), // Belum ada halaman target
    ];

    _featuredProducts = [
      Product(id: 'prod1', name: "Blackmores Multivitamins & Minerals", imageUrl: "https://placehold.co/150x150/E0F2F1/00796B?text=Blackmores+M", unit: "Per Botol", price: 161500, originalPrice: 192000, discountPercentage: 15),
      Product(id: 'prod2', name: "Blackmores Ultimate Radiance Skin", imageUrl: "https://placehold.co/150x150/FFF3E0/FF9800?text=Blackmores+R", unit: "Per Botol", price: 442000, originalPrice: 552500, discountPercentage: 20),
      Product(id: 'prod3', name: "Blackmores Pregnancy & Breast-Feeding Gold", imageUrl: "https://placehold.co/150x150/E3F2FD/2196F3?text=Blackmores+P", unit: "Per Botol", price: 262000, originalPrice: 299000, discountPercentage: 12),
      Product(id: 'prod4', name: "Vitamin C IPI", imageUrl: "https://placehold.co/150x150/F1F8E9/8BC34A?text=Vit+C", unit: "Per Tablet", price: 15000),
    ];

    _officialStores = [
      OfficialStore(id: 'store1', name: "Guardian", logoUrl: "https://placehold.co/120x60/FF7043/FFFFFF?text=guardian&font=roboto"),
      OfficialStore(id: 'store2', name: "Watsons", logoUrl: "https://placehold.co/120x60/4CAF50/FFFFFF?text=watsons&font=roboto"),
      OfficialStore(id: 'store3', name: "AEON Health and Beauty", logoUrl: "https://placehold.co/120x60/F06292/FFFFFF?text=AEON&font=roboto"),
    ];
  }
  String formatRupiah(double amount) {
    return _rupiahFormatter.format(amount);
  }

  void _navigateToCategoryPage(Widget? page) {
    if (page != null) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Halaman ini belum tersedia."), duration: Duration(seconds: 1)),
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
          icon: Icon(Icons.arrow_back, color: theme.primaryColorDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Toko Obat",
          style: TextStyle(color: theme.primaryColorDark, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildSearchBar(theme),
          _buildSectionContainer(
            child: _buildCategoriesSection(theme),
          ),
          _buildSectionContainer(
            title: "Produk Pilihan",
            theme: theme,
            child: _buildFeaturedProductsSection(),
          ),
          _buildSectionContainer(
            title: "Beli Produk dari Toko Resmi",
            theme: theme,
            child: _buildOfficialStoresSection(theme),
            isLastSection: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionContainer({String? title, required Widget child, ThemeData? theme, bool isLastSection = false}) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(top: 8.0),
      padding: EdgeInsets.only(
        top: title != null ? 16.0 : 8.0,
        bottom: isLastSection ? 24.0 : 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null && theme != null) ...[
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.primaryColorDark),
            ),
            const SizedBox(height: 16),
          ],
          child,
        ],
      ),
    );
  }


  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Contoh: Vitamin D3 IPI 1000",
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: theme.primaryColor),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
        ),
      ),
    );
  }

  Widget _buildCategoriesSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Text(
            "Belanja Sesuai Kategori",
             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.primaryColorDark),
          ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _categories.map((category) {
            return _buildCategoryItem(category, theme);
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(ProductCategory category, ThemeData theme) {
    return Expanded(
      child: InkWell(
        onTap: () => _navigateToCategoryPage(category.targetPage),
        borderRadius: BorderRadius.circular(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: category.color.withOpacity(0.15),
                child: Icon(category.icon, size: 30, color: category.color),
              ),
              const SizedBox(height: 10),
              Text(
                category.label,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: theme.textTheme.bodySmall?.color, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildFeaturedProductsSection() {
    return SizedBox(
      height: 295,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _featuredProducts.length,
        itemBuilder: (context, index) {
          return _buildProductCard(_featuredProducts[index]);
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      width: 165,
      margin: const EdgeInsets.only(right: 12.0),
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: (){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Detail produk: ${product.name} (Belum Tersedia)"), duration: const Duration(seconds: 1)),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image_outlined, size: 60, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(product.unit, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                const Spacer(),
                Text(
                  formatRupiah(product.price),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                ),
                if (product.originalPrice != null && product.discountPercentage != null)
                  Row(
                    children: [
                       Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          borderRadius: BorderRadius.circular(4)
                        ),
                        child: Text(
                          "${product.discountPercentage}%",
                          style: TextStyle(fontSize: 10, color: Colors.red[700], fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        formatRupiah(product.originalPrice!),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                       ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${product.name} ditambahkan ke keranjang (dummy)"), duration: const Duration(seconds: 1)),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.7)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                    ),
                    child: Text("Tambah", style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

   Widget _buildOfficialStoresSection(ThemeData theme) {
     return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          childAspectRatio: 0.9,
        ),
        itemCount: _officialStores.length,
        itemBuilder: (context, index) {
          final store = _officialStores[index];
          return InkWell(
            onTap: (){
               ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Kunjungi toko ${store.name} (Belum Tersedia)"), duration: const Duration(seconds: 1)),
              );
            },
            borderRadius: BorderRadius.circular(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300)
                  ),
                  child: Image.network(
                    store.logoUrl,
                    height: 40,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Text(store.name.isNotEmpty ? store.name[0] : "N/A", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  store.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: theme.textTheme.bodySmall?.color, fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      );
   }
}
