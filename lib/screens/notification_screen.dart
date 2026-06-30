import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      _NotificationItem(
        title: 'Promo khusus member',
        message: 'Diskon 20% untuk produk fashion hari ini.',
        time: '5 menit lalu',
      ),
      _NotificationItem(
        title: 'Pesanan dikirim',
        message: 'Barang Anda sedang dalam perjalanan ke alamatmu.',
        time: '1 jam lalu',
      ),
      _NotificationItem(
        title: 'Produk baru tersedia',
        message: 'Cek koleksi terbaru dari kategori elektronik.',
        time: 'Kemarin',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, index) {
          final item = notifications[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.primaryColor.withOpacity(0.12),
                child: const Icon(Icons.notifications_active_rounded, color: AppTheme.primaryColor),
              ),
              title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(item.message),
              trailing: Text(item.time, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
            ),
          );
        },
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String message;
  final String time;

  const _NotificationItem({required this.title, required this.message, required this.time});
}
