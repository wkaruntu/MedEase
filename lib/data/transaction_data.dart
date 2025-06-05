import 'package:medease/riwayat/riwayat.dart';

class TransactionHistoryService {
  static final List<TransactionBase> _transactions = [
    ConsultationTransaction(
      id: 'consult_init_1',
      date: DateTime(2025, 6, 1, 10, 0),
      doctorName: "dr. Amelia Sari, Sp.A",
      doctorSpecialty: "Spesialis Anak",
      doctorImageUrl: "https://placehold.co/80x80/AED581/33691E?text=Dr.A",
      status: "Selesai",
    ),
    MedicinePurchaseTransaction(
      id: 'med_init_1',
      date: DateTime(2025, 5, 28, 14, 30),
      productNames: ["Paracetamol 500mg", "Vitamin B Complex"],
      totalItems: 2,
      totalPrice: 45000,
      status: "Selesai",
    ),
  ];
  static List<TransactionBase> get transactions => List.unmodifiable(_transactions);
  static void addTransaction(TransactionBase transaction) {
    _transactions.insert(0, transaction);
  }

  static void clearTransactions() {
    _transactions.clear();
  }
}
