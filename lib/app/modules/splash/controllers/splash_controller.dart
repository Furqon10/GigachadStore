import 'package:get/get.dart';
import '../../../data/providers/database_helper.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _checkActiveSession();
  }

  void _checkActiveSession() async {
    await Future.delayed(const Duration(seconds: 2));
    final session = await DatabaseHelper.instance.getSesiPengguna();
    if (session != null && session['email'] != null && session['email'].toString().isNotEmpty) {
      Get.offNamed(Routes.MAIN);
    } else {
      Get.offNamed(Routes.LOGIN);
    }
  }
}

