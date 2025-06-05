import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/transaction_data.dart';
import '../pages/video_call_page.dart';

enum TransactionType { consultation, medicinePurchase }

abstract class TransactionBase {
  final String id;
  final DateTime date;
  final TransactionType type;

  TransactionBase({required this.id, required this.date, required this.type});
}

class ConsultationTransaction extends TransactionBase {
  final String doctorName;
  final String doctorSpecialty;
  final String doctorImageUrl;
  final String status;

  ConsultationTransaction({
    required super.id,
    required super.date,
    required this.doctorName,
    required this.doctorSpecialty,
    required this.doctorImageUrl,
    required this.status,
  }) : super(type: TransactionType.consultation);
}

class MedicinePurchaseTransaction extends TransactionBase {
  final List<String> productNames;
  final int totalItems;
  final double totalPrice;
  final String status;

  MedicinePurchaseTransaction({
    required super.id,
    required super.date,
    required this.productNames,
    required this.totalItems,
    required this.totalPrice,
    required this.status,
  }) : super(type: TransactionType.medicinePurchase);
}

class RiwayatTransaksiPage extends StatefulWidget {
  final String userName;
  static const String routeName = '/riwayat';

  const RiwayatTransaksiPage({super.key, this.userName = "Luthfi Halimawan"});

  @override
  State<RiwayatTransaksiPage> createState() => _RiwayatTransaksiPageState();
}

class _RiwayatTransaksiPageState extends State<RiwayatTransaksiPage> {
  final DateFormat _dateFormatter = DateFormat('d MMMM yy', 'id_ID');
  final DateFormat _timeFormatter = DateFormat('HH:mm', 'id_ID');
  final NumberFormat _rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  List<TransactionBase> _transactions = [];
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
  }

  void _loadTransactions() {
     if (TransactionHistoryService.transactions.isEmpty) {
       TransactionHistoryService.transactions.add(
         ConsultationTransaction(
           id: 'consult-001',
           date: DateTime.now().subtract(const Duration(days: 1)),
           doctorName: 'Dr. Mutiara Sp.KG',
           doctorSpecialty: 'Dokter Gigi Spesialis Konservasi Gigi',
           doctorImageUrl: 'https://t3.ftcdn.net/jpg/05/04/25/70/360_F_504257032_jBtwqNdvdMN9Xm6aDT0hcvtxDXPZErrn.jpg', // Ganti dengan URL gambar valid
           status: 'Selesai',
         ),
       );
     }
    var allTransactions = List<TransactionBase>.from(TransactionHistoryService.transactions);
    allTransactions.sort((a, b) => b.date.compareTo(a.date));

    if (mounted) {
      setState(() {
        _transactions = allTransactions;
      });
    }
  }

  Map<String, List<TransactionBase>> _groupTransactionsByDate() {
    final Map<String, List<TransactionBase>> grouped = {};
    for (var transaction in _transactions) {
      String formattedDate = _dateFormatter.format(transaction.date);
      if (grouped[formattedDate] == null) {
        grouped[formattedDate] = [];
      }
      grouped[formattedDate]!.add(transaction);
    }
    return grouped;
  }

  void _onBottomNavTapped(int index) {
    if (_currentIndex == index) return; 

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/chat');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupedTransactions = _groupTransactionsByDate();
    final sortedDates = groupedTransactions.keys.toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.teal.shade800),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "Riwayat Transaksi",
          style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverPersistentHeader(
            delegate: _UserProfileHeaderDelegate(userName: widget.userName, theme: theme),
            pinned: true,
          ),
          if (groupedTransactions.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 70, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text("Belum ada riwayat transaksi", style: TextStyle(fontSize: 17, color: Colors.grey[600])),
                  ],
                ),
              ),
            )
          else
            SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                String dateKey = sortedDates[index];
                List<TransactionBase> transactionsOnDate = groupedTransactions[dateKey]!;
                return _buildDateSection(context, dateKey, transactionsOnDate, theme);
              },
              childCount: sortedDates.length,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.teal.shade700,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        backgroundColor: Colors.white,
        elevation: 8.0,
        items: const [
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
            label: 'Inbox', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection(BuildContext context, String date, List<TransactionBase> transactions, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 20.0, bottom: 8.0, right: 16.0),
          child: Text(
            date,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color ?? Colors.grey[800]),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (context, index) {
            final transaction = transactions[index];
            if (transaction.type == TransactionType.consultation) {
              return _buildConsultationItem(transaction as ConsultationTransaction, theme);
            } else if (transaction.type == TransactionType.medicinePurchase) {
              return _buildMedicinePurchaseItem(transaction as MedicinePurchaseTransaction, theme);
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildConsultationItem(ConsultationTransaction item, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Konsultasi dengan",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color ?? Colors.grey[850]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.status.toLowerCase() == "selesai" ? Colors.green.shade50 : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: item.status.toLowerCase() == "selesai" ? Colors.green.shade300 : Colors.orange.shade300)
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: item.status.toLowerCase() == "selesai" ? Colors.green.shade700 : Colors.orange.shade700),
                  ),
                ),
              ],
            ),
            Text(
              _timeFormatter.format(item.date),
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const Divider(height: 20),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(item.doctorImageUrl),
                  onBackgroundImageError: (_,__) {},
                  backgroundColor: Colors.grey[200],
                  child: item.doctorImageUrl.isEmpty || !item.doctorImageUrl.startsWith('http')
                    ? Icon(Icons.person, size: 24, color: Colors.grey[400])
                    : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.doctorName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                      Text(item.doctorSpecialty, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.video_call_outlined, size: 18),
                  label: const Text("Mulai Panggilan", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  onPressed: () {
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoCallPage(
                            doctorImageUrl: item.doctorImageUrl,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedicinePurchaseItem(MedicinePurchaseTransaction item, ThemeData theme) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      elevation: 2.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Pembelian Obat",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.textTheme.titleMedium?.color ?? Colors.grey[850]),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.status.toLowerCase() == "selesai" ? Colors.green.shade50 : (item.status.toLowerCase() == "dikirim" ? Colors.blue.shade50 : Colors.orange.shade50),
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: item.status.toLowerCase() == "selesai" ? Colors.green.shade300 : (item.status.toLowerCase() == "dikirim" ? Colors.blue.shade300 : Colors.orange.shade300))
                  ),
                  child: Text(
                    item.status,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: item.status.toLowerCase() == "selesai" ? Colors.green.shade700 : (item.status.toLowerCase() == "dikirim" ? Colors.blue.shade700 : Colors.orange.shade700)),
                  ),
                ),
              ],
            ),
            Text(
              _timeFormatter.format(item.date),
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const Divider(height: 20),
            Row(
              children: [
                Icon(Icons.medication_outlined, size: 30, color: theme.primaryColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productNames.join(", "),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text("${item.totalItems} produk", style: TextStyle(fontSize: 13, color: Colors.grey[700])),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "Total: ${_rupiahFormatter.format(item.totalPrice)}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.primaryColorDark),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Lihat detail pembelian ${item.id} (Belum Tersedia)"), duration: const Duration(seconds: 1)),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    side: BorderSide(color: theme.primaryColor.withOpacity(0.7)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: Text("Lihat Detail", style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Beli lagi produk dari transaksi ${item.id} (Belum Tersedia)"), duration: const Duration(seconds: 1)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  ),
                  child: const Text("Beli Lagi", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UserProfileHeaderDelegate extends SliverPersistentHeaderDelegate {
  final String userName;
  final ThemeData theme;

  _UserProfileHeaderDelegate({required this.userName, required this.theme});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      alignment: Alignment.centerLeft,
      child: Text(
        userName,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
      ),
    );
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant _UserProfileHeaderDelegate oldDelegate) {
    return userName != oldDelegate.userName || theme != oldDelegate.theme;
  }
}