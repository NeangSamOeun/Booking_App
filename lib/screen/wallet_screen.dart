// screens/wallet_screen.dart

import 'package:flutter/material.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWalletCard(context),
            const SizedBox(height: 20),
            _buildQuickActions(),
            const SizedBox(height: 30),
            _buildSectionHeader('Transaction History'),
            _buildTransactionList(),
          ],
        ),
      ),
    );
  }

  // --- App Bar ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'My Wallet',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      backgroundColor: Colors.red[400],
      elevation: 0,
    );
  }

  // --- Wallet Balance Card ---
  Widget _buildWalletCard(BuildContext context) {
    // Dummy Data
    const double currentBalance = 1545.50;
    const int loyaltyPoints = 250;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          // Use a subtle gradient for a premium feel
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Available Balance', style: TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 5),
            Text(
              '\$${currentBalance.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: Colors.white38, height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Loyalty Points:', style: TextStyle(color: Colors.white70, fontSize: 16)),
                Text('$loyaltyPoints pts', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- Quick Actions ---
  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _WalletActionChip(icon: Icons.add_circle_outline, label: 'Add Money', color: Colors.green.shade600, onTap: () {}),
        _WalletActionChip(icon: Icons.savings_outlined, label: 'Withdraw', color: Colors.blue.shade600, onTap: () {}),
        _WalletActionChip(icon: Icons.local_activity_outlined, label: 'Redeem', color: Colors.orange.shade600, onTap: () {}),
      ],
    );
  }

  // --- Transaction History ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
      ),
    );
  }

  Widget _buildTransactionList() {
    // Dummy Transaction Data
    final transactions = [
      {'type': 'Credit', 'description': 'Wallet Top-up', 'amount': 1000.00, 'date': '10 Dec', 'icon': Icons.account_balance_wallet_outlined},
      {'type': 'Debit', 'description': 'Ticket #A1B2C3', 'amount': -850.00, 'date': '10 Dec', 'icon': Icons.directions_bus_filled},
      {'type': 'Credit', 'description': 'Loyalty Redemption', 'amount': 200.00, 'date': '05 Dec', 'icon': Icons.local_activity},
      {'type': 'Debit', 'description': 'Ticket #G7H8I9', 'amount': -700.00, 'date': '01 Dec', 'icon': Icons.directions_bus_filled},
    ];

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(), // Handled by SingleChildScrollView
      shrinkWrap: true,
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final tx = transactions[index];
        final isCredit = tx['type'] == 'Credit';

        return Card(
          elevation: 1,
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isCredit ? Colors.green.shade50 : Colors.red.shade50,
              child: Icon(tx['icon'] as IconData?, color: isCredit ? Colors.green : Colors.red),
            ),
            title: Text(tx['description'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: Text(tx['date'] as String, style: const TextStyle(color: Colors.grey)),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$${tx['amount']}',
                  style: TextStyle(
                    color: isCredit ? Colors.green.shade700 : Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(tx['type'] as String, style: TextStyle(fontSize: 12, color: isCredit ? Colors.green : Colors.red)),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- Helper Widget for Quick Actions ---
class _WalletActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _WalletActionChip({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(color: Colors.grey[700], fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}