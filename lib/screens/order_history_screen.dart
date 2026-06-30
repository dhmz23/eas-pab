import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      _OrderItem(
        code: 'INV-1001',
        title: 'Sepatu Sneakers',
        date: '12 Jun 2026',
        status: 'Sudah Diterima',
        amount: 'Rp 1.200.000',
      ),
      _OrderItem(
        code: 'INV-0998',
        title: 'Tas Tote',
        date: '08 Jun 2026',
        status: 'Dalam Pengiriman',
        amount: 'Rp 320.000',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat Pesanan')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        order.code,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.status,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppTheme.successColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(order.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('Tanggal: ${order.date}'),
                  const SizedBox(height: 6),
                  Text(order.amount, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _OrderItem {
  final String code;
  final String title;
  final String date;
  final String status;
  final String amount;

  const _OrderItem({
    required this.code,
    required this.title,
    required this.date,
    required this.status,
    required this.amount,
  });
}
