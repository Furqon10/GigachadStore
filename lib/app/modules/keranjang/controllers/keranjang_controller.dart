import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/providers/database_helper.dart';
import '../../../routes/app_pages.dart';

class KeranjangController extends GetxController {
  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString userEmail = 'guest@tokolaptop.com'.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartItems();
  }

  @override
  void onReady() {
    super.onReady();
    loadCartItems();
  }

  Future<void> loadCartItems() async {
    isLoading.value = true;
    try {
      final session = await DatabaseHelper.instance.getSesiPengguna();
      userEmail.value = session?['email'] ?? 'guest@tokolaptop.com';
      final items = await DatabaseHelper.instance.getCartItems(userEmail: userEmail.value);
      cartItems.assignAll(items);
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat keranjang: $e');
    } finally {
      isLoading.value = false;
    }
  }

  double get totalPrice {
    return cartItems.fold(
      0.0,
      (sum, item) => sum + (item.harga * item.qty),
    );
  }

  Future<void> incrementQty(CartItemModel item) async {
    if (item.id == null) return;
    final newQty = item.qty + 1;
    await DatabaseHelper.instance.updateQty(item.id!, newQty);
    await loadCartItems();
  }

  Future<void> decrementQty(CartItemModel item) async {
    if (item.id == null) return;
    if (item.qty > 1) {
      final newQty = item.qty - 1;
      await DatabaseHelper.instance.updateQty(item.id!, newQty);
      await loadCartItems();
    } else {
      await deleteCartItem(item.id!);
    }
  }

  Future<void> deleteCartItem(int id) async {
    await DatabaseHelper.instance.deleteCartItem(id);
    await loadCartItems();
    Get.snackbar(
      'Informasi',
      'Produk berhasil dihapus dari keranjang',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );
  }

  void checkout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Keranjang belanja Anda masih kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Get.toNamed(Routes.CHECKOUT);
  }
}

