import 'package:get/get.dart';
import '../../beranda/controllers/beranda_controller.dart';
import '../../kategori/controllers/kategori_controller.dart';
import '../../keranjang/controllers/keranjang_controller.dart';
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<BerandaController>(() => BerandaController());
    Get.lazyPut<KategoriController>(() => KategoriController());
    Get.lazyPut<KeranjangController>(() => KeranjangController());
  }
}

