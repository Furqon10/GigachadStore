import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../data/models/cart_item_model.dart';
import '../../../data/providers/database_helper.dart';
import '../../../routes/app_pages.dart';

class CheckoutController extends GetxController {
  late TextEditingController namaController;
  late TextEditingController hpController;

  final RxList<CartItemModel> cartItems = <CartItemModel>[].obs;
  final RxDouble totalPrice = 0.0.obs;
  final RxString userEmail = 'guest@tokolaptop.com'.obs;

  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;
  final RxString locationStatus = 'Belum mengambil lokasi'.obs;
  final RxBool isGettingLocation = false.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    namaController = TextEditingController();
    hpController = TextEditingController();
    _loadCartSummary();
  }

  @override
  void onReady() {
    super.onReady();
    fetchLocation();
  }

  Future<void> _loadCartSummary() async {
    final session = await DatabaseHelper.instance.getSesiPengguna();
    if (session != null) {
      userEmail.value = session['email'] ?? 'guest@tokolaptop.com';
      if (namaController.text.isEmpty && session['nama'] != null) {
        namaController.text = session['nama'].toString();
      }
      if (hpController.text.isEmpty && session['no_hp'] != null) {
        hpController.text = session['no_hp'].toString();
      }
    }

    final items = await DatabaseHelper.instance.getCartItems(userEmail: userEmail.value);
    cartItems.assignAll(items);
    totalPrice.value = items.fold(0.0, (sum, i) => sum + (i.harga * i.qty));
  }

  Future<void> fetchLocation() async {
    isGettingLocation.value = true;
    locationStatus.value = 'Mengecek GPS & Izin...';

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        locationStatus.value = 'Layanan GPS tidak aktif';
        Get.snackbar(
          'GPS Mati',
          'Harap aktifkan Layanan Lokasi (GPS) pada perangkat Anda',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orangeAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationStatus.value = 'Izin lokasi ditolak';
          Get.snackbar(
            'Izin Ditolak',
            'Izin lokasi diperlukan untuk menentukan titik pengiriman',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        locationStatus.value = 'Izin lokasi ditolak permanen';
        Get.snackbar(
          'Izin Permanen Ditolak',
          'Buka pengaturan aplikasi untuk memberikan izin lokasi',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
        return;
      }

      locationStatus.value = 'Mengambil titik koordinat...';
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      latitude.value = position.latitude;
      longitude.value = position.longitude;
      locationStatus.value = 'Lokasi berhasil didapatkan';
    } catch (e) {
      locationStatus.value = 'Gagal mendapatkan lokasi';
      Get.snackbar('Error Lokasi', e.toString());
    } finally {
      isGettingLocation.value = false;
    }
  }

  Future<void> submitOrder() async {
    final nama = namaController.text.trim();
    final hp = hpController.text.trim();

    if (nama.isEmpty || hp.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Nama dan Nomor HP tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (latitude.value == 0.0 && longitude.value == 0.0) {
      Get.snackbar(
        'Lokasi Belum Siap',
        'Harap ambil titik koordinat GPS terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isSubmitting.value = true;
    try {
      final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
      final payload = {
        'user_email': userEmail.value,
        'nama': nama,
        'nomor_hp': hp,
        'total_harga': totalPrice.value,
        'total_item': cartItems.length,
        'latitude': latitude.value,
        'longitude': longitude.value,
      };

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final noInvoice = 'INV-${DateTime.now().millisecondsSinceEpoch}';
        await DatabaseHelper.instance.insertRiwayatTransaksi({
          'user_email': userEmail.value,
          'no_invoice': noInvoice,
          'total_harga': totalPrice.value,
          'latitude': latitude.value,
          'longitude': longitude.value,
          'status_sinkronisasi': 'Pesanan Diproses',
        });

        await DatabaseHelper.instance.clearCart(userEmail: userEmail.value);

        Get.dialog(
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            elevation: 10,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated glowing check icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.25),
                          blurRadius: 20,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Pesanan Berhasil! 🎉',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Terima kasih! Pesanan laptop Anda telah diproses.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),

                  // Digital Receipt Container
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'No. Invoice',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              noInvoice,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Pembayaran',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              'Rp ${totalPrice.value.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.local_shipping, size: 12, color: Colors.blueAccent),
                                  SizedBox(width: 4),
                                  Text(
                                    'Pesanan Diproses',
                                    style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Colors.orangeAccent),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  '📍 GPS: Lat ${latitude.value.toStringAsFixed(4)}, Lng ${longitude.value.toStringAsFixed(4)}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.offAllNamed(Routes.MAIN);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Lihat Riwayat Pesanan',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );
      } else {
        Get.snackbar(
          'Gagal Mengirim',
          'Server merespons dengan status: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Koneksi',
        'Gagal terhubung ke server: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isSubmitting.value = false;
    }
  }
}

