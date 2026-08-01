import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../akun/views/akun_view.dart';
import '../../beranda/views/beranda_view.dart';
import '../../kategori/views/kategori_view.dart';
import '../../keranjang/views/keranjang_view.dart';
import '../../pesanan/views/pesanan_view.dart';

class MainController extends GetxController {
  final RxInt currentIndex = 0.obs;

  final List<Widget> pages = const [
    BerandaView(),
    KategoriView(),
    KeranjangView(),
    PesananView(),
    AkunView(),
  ];

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
