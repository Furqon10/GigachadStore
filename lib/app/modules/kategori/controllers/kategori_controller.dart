import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/laptop_model.dart';
import '../../../data/providers/database_helper.dart';

class KategoriController extends GetxController {
  final RxList<LaptopModel> laptopList = <LaptopModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProductsFromDb();
  }

  Future<void> fetchProductsFromDb() async {
    isLoading.value = true;
    try {
      final products = await DatabaseHelper.instance.getProdukList();
      laptopList.assignAll(products);
    } catch (e) {
      Get.snackbar(
        'Error Database',
        'Gagal mengambil data produk kategori dari SQLite: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<LaptopModel> getProductsByCategory(String categoryKey) {
    return laptopList
        .where((laptop) => laptop.kategori.toLowerCase() == categoryKey.toLowerCase())
        .toList();
  }

  int getCategoryCount(String categoryKey) {
    return getProductsByCategory(categoryKey).length;
  }
}
