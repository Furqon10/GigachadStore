import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/database_helper.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController hpController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  final RxBool isLoading = false.obs;
  final RxBool isObscurePassword = true.obs;
  final RxBool isObscureConfirmPassword = true.obs;

  @override
  void onInit() {
    super.onInit();
    namaController = TextEditingController();
    emailController = TextEditingController();
    hpController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void toggleObscurePassword() {
    isObscurePassword.value = !isObscurePassword.value;
  }

  void toggleObscureConfirmPassword() {
    isObscureConfirmPassword.value = !isObscureConfirmPassword.value;
  }

  Future<void> register() async {
    final nama = namaController.text.trim();
    final email = emailController.text.trim();
    final hp = hpController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (nama.isEmpty || email.isEmpty || hp.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Form Belum Lengkap',
        'Harap isi semua kolom pendaftaran',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Get.snackbar(
        'Email Tidak Valid',
        'Harap masukkan format email yang benar (misal: user@gmail.com)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (password.length < 4) {
      Get.snackbar(
        'Password Terlalu Pendek',
        'Password minimal terdiri dari 4 karakter',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Konfirmasi Password Gagal',
        'Password dan konfirmasi password tidak cocok',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;
    try {
      final userData = await DatabaseHelper.instance.registerUser(
        nama: nama,
        email: email,
        noHp: hp,
        password: password,
      );

      Get.snackbar(
        'Registrasi Berhasil! 🎉',
        'Akun ${userData['nama']} berhasil dibuat. Silakan login menggunakan email dan password Anda.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );

      Get.offAllNamed(Routes.LOGIN, arguments: email);
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar(
        'Registrasi Gagal',
        message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
