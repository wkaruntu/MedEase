import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum PaymentMethodType { wallet, card }
enum WalletType { medease, gopay, linkaja }

class PaymentSummaryPage extends StatefulWidget {
  final double totalAmount;

  const PaymentSummaryPage({super.key, required this.totalAmount});

  @override
  State<PaymentSummaryPage> createState() => _PaymentSummaryPageState();
}

class _PaymentSummaryPageState extends State<PaymentSummaryPage> {
  final NumberFormat _rupiahFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);
  PaymentMethodType _selectedPaymentMethodType = PaymentMethodType.wallet;
  WalletType? _selectedWallet;

  final List<Map<String, dynamic>> _walletOptions = [
    {'type': WalletType.medease, 'name': 'Saldo MedEase', 'balance': 0, 'logo': Icons.account_balance_wallet_outlined},
    {'type': WalletType.gopay, 'name': 'GoPay', 'logo': Icons.payment_outlined},
    {'type': WalletType.linkaja, 'name': 'LinkAja', 'logo': Icons.credit_card_outlined},
  ];


  @override
  void initState() {
    super.initState();
    if (_selectedPaymentMethodType == PaymentMethodType.wallet && _walletOptions.isNotEmpty) {
      var gopayOption = _walletOptions.firstWhere((opt) => opt['type'] == WalletType.gopay, orElse: () => _walletOptions.first);
      _selectedWallet = gopayOption['type'] as WalletType;
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
          "Ringkasan Pembayaran",
          style: TextStyle(color: theme.primaryColorDark, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildPriceSummarySection(theme),
                _buildPaymentMethodSelectionSection(theme),
              ],
            ),
          ),
          _buildBottomPayButtonSection(theme),
        ],
      ),
    );
  }

  Widget _buildSectionContainer(Widget child, {EdgeInsetsGeometry? padding, Color? color, bool addMargin = true}) {
    return Container(
      width: double.infinity,
      color: color ?? Colors.white,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      margin: addMargin ? const EdgeInsets.only(bottom: 8.0) : null,
      child: child,
    );
  }

  Widget _buildPriceSummarySection(ThemeData theme) {
    return _buildSectionContainer(
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Harga Total", style: TextStyle(fontSize: 15, color: theme.textTheme.bodyMedium?.color)),
              Text(_rupiahFormatter.format(widget.totalAmount), style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.textTheme.bodyLarge?.color)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Bayar", style: TextStyle(fontSize: 15, color: theme.textTheme.bodyMedium?.color, fontWeight: FontWeight.bold)),
              Text(_rupiahFormatter.format(widget.totalAmount), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.primaryColorDark)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSelectionSection(ThemeData theme) {
    return _buildSectionContainer(
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Pilih metode pembayaran", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textTheme.titleLarge?.color)),
          const SizedBox(height: 16),
          Center(
            child: ToggleButtons(
              isSelected: [_selectedPaymentMethodType == PaymentMethodType.wallet, _selectedPaymentMethodType == PaymentMethodType.card],
              onPressed: (int index) {
                setState(() {
                  _selectedPaymentMethodType = index == 0 ? PaymentMethodType.wallet : PaymentMethodType.card;
                  if (_selectedPaymentMethodType == PaymentMethodType.wallet && _walletOptions.isNotEmpty) {
                     var gopayOption = _walletOptions.firstWhere((opt) => opt['type'] == WalletType.gopay, orElse: () => _walletOptions.first);
                    _selectedWallet = gopayOption['type'] as WalletType;
                  } else {
                    _selectedWallet = null;
                  }
                });
              },
              borderRadius: BorderRadius.circular(8.0),
              selectedColor: Colors.white,
              color: theme.primaryColor,
              fillColor: theme.primaryColor,
              borderColor: theme.primaryColor.withOpacity(0.5),
              selectedBorderColor: theme.primaryColor,
              constraints: BoxConstraints(minHeight: 40.0, minWidth: (MediaQuery.of(context).size.width - 32 - 4) / 2), // -32 for padding, -4 for borders/spacing
              children: const [
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Dompet")),
                Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Kartu Debit/Kredit")),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedPaymentMethodType == PaymentMethodType.wallet)
            ..._walletOptions.map((wallet) => _buildWalletOptionTile(
                  theme: theme,
                  walletType: wallet['type'] as WalletType,
                  name: wallet['name'] as String,
                  balance: wallet['balance'] as int?,
                  logo: wallet['logo'] as IconData,
                )).toList(),
          if (_selectedPaymentMethodType == PaymentMethodType.card)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Center(
                child: Text(
                  "Fitur Kartu Debit/Kredit belum tersedia.",
                  style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWalletOptionTile({
    required ThemeData theme,
    required WalletType walletType,
    required String name,
    int? balance,
    required IconData logo,
  }) {
    bool isSelected = _selectedWallet == walletType;
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: isSelected ? theme.primaryColor : Colors.grey.shade300,
          width: isSelected ? 1.5 : 1.0,
        ),
      ),
      child: RadioListTile<WalletType>(
        title: Row(
          children: [
            Icon(logo, color: isSelected ? theme.primaryColor : Colors.grey[700], size: 28),
            const SizedBox(width: 12),
            Text(name, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: theme.textTheme.bodyLarge?.color)),
            if (balance != null) ...[
              const Spacer(),
              Text(
                "Saldo: ${_rupiahFormatter.format(balance.toDouble())}",
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
              ),
            ]
          ],
        ),
        value: walletType,
        groupValue: _selectedWallet,
        onChanged: (WalletType? value) {
          setState(() {
            _selectedWallet = value;
          });
        },
        activeColor: theme.primaryColor,
        controlAffinity: ListTileControlAffinity.trailing,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      ),
    );
  }


  Widget _buildBottomPayButtonSection(ThemeData theme) {
    return Container(
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
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 12.0, bottom: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Total Pembayaran", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              Text(_rupiahFormatter.format(widget.totalAmount), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.primaryColorDark)),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (_selectedPaymentMethodType == PaymentMethodType.wallet && _selectedWallet == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Silakan pilih metode dompet terlebih dahulu."), backgroundColor: Colors.orange),
                );
                return;
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Membayar dengan ${_selectedPaymentMethodType == PaymentMethodType.wallet ? _selectedWallet.toString().split('.').last : 'Kartu'} (Belum Tersedia)"), duration: const Duration(seconds: 1)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            child: const Text("Bayar"),
          ),
        ],
      ),
    );
  }
}
