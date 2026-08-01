import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/laptop_model.dart';
import '../../../data/providers/database_helper.dart';
import '../../../routes/app_pages.dart';
import '../../keranjang/controllers/keranjang_controller.dart';

class BerandaController extends GetxController {
  late TextEditingController searchController;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'Semua'.obs;
  final RxString selectedSort = 'Semua'.obs;

  final RxList<LaptopModel> laptopList = <LaptopModel>[].obs;

  final List<String> categories = const [
    'Semua',
    'Gaming',
    'Ultrabook',
    'Business',
    'Creator',
    'Entry-Level',
  ];

  final List<String> sortOptions = const [
    'Semua',
    'Harga Termurah',
    'Rating Tertinggi',
  ];

  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    fetchProductsFromDb();
  }

  Future<void> fetchProductsFromDb() async {
    isLoading.value = true;
    try {
      final products = await DatabaseHelper.instance.getProdukList();
      laptopList.assignAll(products);
    } catch (e) {
      Get.snackbar('Error', 'Gagal mengambil data dari database: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<LaptopModel> get filteredLaptopList {
    var result = laptopList.where((laptop) {
      final matchesSearch = searchQuery.value.isEmpty ||
          laptop.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          laptop.specs.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          laptop.description.toLowerCase().contains(searchQuery.value.toLowerCase());

      final matchesCategory = selectedCategory.value == 'Semua' ||
          laptop.kategori.toLowerCase() == selectedCategory.value.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();

    if (selectedSort.value == 'Harga Termurah') {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else if (selectedSort.value == 'Rating Tertinggi') {
      result.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return result;
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
  }

  void selectSort(String sort) {
    selectedSort.value = sort;
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
  }

  Future<void> addToCart(LaptopModel laptop) async {
    try {
      final session = await DatabaseHelper.instance.getSesiPengguna();
      final userEmail = session?['email'] ?? 'guest@tokolaptop.com';

      final cartItem = CartItemModel(
        productId: laptop.id,
        namaProduk: laptop.name,
        harga: laptop.price,
        qty: 1,
        gambar: laptop.gambar,
      );

      await DatabaseHelper.instance.insertCartItem(cartItem, userEmail: userEmail);

      if (Get.isRegistered<KeranjangController>()) {
        Get.find<KeranjangController>().loadCartItems();
      }

      Get.snackbar(
        'Sukses',
        '${laptop.name} telah masuk ke keranjang!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Gagal menambahkan ke keranjang: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  void goToDetail(LaptopModel laptop) {
    Get.toNamed(Routes.DETAIL_PRODUK, arguments: laptop);
  }
}
