import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/database_helper.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final RxBool isLoading = false.obs;
  final RxBool isObscurePassword = true.obs;

  void toggleObscurePassword() {
    isObscurePassword.value = !isObscurePassword.value;
  }

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _checkArguments();
  }

  @override
  void onReady() {
    super.onReady();
    _checkArguments();
  }

  void _checkArguments() {
    if (Get.arguments != null && Get.arguments is String) {
      emailController.text = Get.arguments as String;
      passwordController.clear();
    }
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Validasi Gagal',
        'Email dan Password tidak boleh kosong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    isLoading.value = true;
    try {
      final user = await DatabaseHelper.instance.loginUser(
        email: email,
        password: password,
      );

      if (user != null) {
        Get.snackbar(
          'Login Berhasil! 👋',
          'Selamat datang kembali, ${user['nama']}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(16),
        );
        Get.offAllNamed(Routes.MAIN);
      } else {
        Get.snackbar(
          'Login Gagal',
          'Email atau Password salah. Jika belum punya akun, silakan daftar.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error Login',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }
}

