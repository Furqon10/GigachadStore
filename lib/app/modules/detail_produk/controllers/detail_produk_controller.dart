import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/laptop_model.dart';
import '../../../data/providers/database_helper.dart';
import '../../keranjang/controllers/keranjang_controller.dart';

class DetailProdukController extends GetxController {
  late final LaptopModel laptop;
  final RxBool isWishlisted = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is LaptopModel) {
      laptop = Get.arguments as LaptopModel;
      _checkWishlistStatus();
    } else {
      laptop = LaptopModel(
        id: 'UNKNOWN',
        name: 'Laptop Detail',
        kategori: 'Umum',
        price: 0,
        rating: 5.0,
        description: 'Detail produk laptop',
        specs: 'Spesifikasi laptop',
        gambar: '',
      );
    }
  }

  Future<String> _getUserEmail() async {
    final session = await DatabaseHelper.instance.getSesiPengguna();
    return session?['email'] ?? 'guest@tokolaptop.com';
  }

  Future<void> _checkWishlistStatus() async {
    final email = await _getUserEmail();
    isWishlisted.value = await DatabaseHelper.instance.isWishlisted(laptop.id, userEmail: email);
  }

  Future<void> toggleWishlist() async {
    final email = await _getUserEmail();
    if (isWishlisted.value) {
      await DatabaseHelper.instance.deleteWishlist(laptop.id, userEmail: email);
      isWishlisted.value = false;
      Get.snackbar('Wishlist', 'Dihapus dari wishlist');
    } else {
      await DatabaseHelper.instance.insertWishlist(laptop.id, laptop.name, laptop.gambar, userEmail: email);
      isWishlisted.value = true;
      Get.snackbar('Wishlist', 'Ditambahkan ke wishlist');
    }
  }

  Future<void> addToCart() async {
    try {
      final email = await _getUserEmail();
      final cartItem = CartItemModel(
        productId: laptop.id,
        namaProduk: laptop.name,
        harga: laptop.price,
        qty: 1,
        gambar: laptop.gambar,
      );

      await DatabaseHelper.instance.insertCartItem(cartItem, userEmail: email);

      if (Get.isRegistered<KeranjangController>()) {
        Get.find<KeranjangController>().loadCartItems();
      }

      Get.snackbar(
        'Sukses Ditambahkan',
        '${laptop.name} telah masuk ke keranjang belanja!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal Ditambahkan',
        'Terjadi kesalahan saat menyimpan ke keranjang: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }
}

