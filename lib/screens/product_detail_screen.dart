// lib/screens/product_detail_screen.dart

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorite_provider.dart';
import '../screens/cart_screen.dart';
import '../utils/app_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFavorite = false;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _isFavorite = context.read<FavoriteProvider>().isFavorite(widget.product.id);
  }

  void _addToCart() {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final currentCartQty = cart.quantityInCart(widget.product.id);
    final availableToAdd = widget.product.stock - currentCartQty;
    if (availableToAdd <= 0) {
      _showSnackBar('Stok produk tidak mencukupi.');
      return;
    }

    final requestedQty = min(_quantity, availableToAdd);
    for (int i = 0; i < requestedQty; i++) {
      cart.addItem(widget.product);
    }

    final message = requestedQty == _quantity
        ? 'Berhasil ditambahkan ke keranjang'
        : 'Hanya $requestedQty item berhasil ditambahkan (stok terbatas)';

    _showSnackBar(message);
  }

  void _showSnackBar(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(12),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _toggleFavorite() async {
    final favoriteProvider = context.read<FavoriteProvider>();
    await favoriteProvider.toggleFavorite(widget.product);
    if (mounted) {
      setState(() => _isFavorite = favoriteProvider.isFavorite(widget.product.id));
    }
  }

  void _buyNow() {
    _addToCart();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CartScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final priceIdr = p.price * 15000;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: AppTheme.primaryColor, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(
                      _isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: _isFavorite ? Colors.red : AppTheme.primaryColor,
                      size: 20,
                    ),
                    onPressed: _toggleFavorite,
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.grey.shade50,
                child: Hero(
                  tag: 'product_${p.id}',
                  child: Image.network(
                    p.image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const Icon(
                        Icons.image_not_supported,
                        color: Colors.grey,
                        size: 60),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(21, 101, 192, 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          p.category.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '${p.rating.rate} (${p.rating.count} ulasan)',
                        style: const TextStyle(
                            fontSize: 12, color: AppTheme.textSecondary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    p.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price
                  Row(
                    children: [
                      Text(
                        AppConstants.formatCurrency(priceIdr),
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppConstants.formatCurrency(priceIdr * 1.3),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Rating bar
                  Row(
                    children: [
                      ...List.generate(5, (i) {
                        final filled = i < p.rating.rate.floor();
                        final half = !filled &&
                            i < p.rating.rate &&
                            p.rating.rate - p.rating.rate.floor() >= 0.5;
                        return Icon(
                          half
                              ? Icons.star_half_rounded
                              : (filled
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded),
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                      const SizedBox(width: 6),
                      Text(
                        '${p.rating.rate}/5.0',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Text(
                        'Stok tersedia:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.product.stock > 0
                            ? '${widget.product.stock} buah'
                            : 'Habis',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.product.stock > 0
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const Divider(),
                  const SizedBox(height: 12),

                  // Description
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quantity selector
                  Row(
                    children: [
                      const Text(
                        'Jumlah:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: _quantity > 1
                                  ? () =>
                                      setState(() => _quantity--)
                                  : null,
                              constraints: const BoxConstraints(
                                  minWidth: 36, minHeight: 36),
                              padding: EdgeInsets.zero,
                            ),
                            SizedBox(
                              width: 36,
                              child: Text(
                                '$_quantity',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () => setState(() => _quantity++),
                              constraints: const BoxConstraints(
                                  minWidth: 36, minHeight: 36),
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Add to cart button
                  Consumer<CartProvider>(
                    builder: (context, cart, _) {
                      final inCart = cart.isInCart(p.id);
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _addToCart,
                          icon: Icon(inCart
                              ? Icons.shopping_cart_rounded
                              : Icons.add_shopping_cart_rounded),
                          label: Text(
                            inCart
                                ? 'Tambah Lagi ke Keranjang'
                                : 'Tambah ke Keranjang',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: inCart
                                ? AppTheme.successColor
                                : AppTheme.primaryColor,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _buyNow,
                      icon: const Icon(Icons.flash_on_rounded,
                          color: AppTheme.accentColor),
                      label: const Text(
                        'Beli Sekarang',
                        style: TextStyle(
                            color: AppTheme.accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppTheme.accentColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
