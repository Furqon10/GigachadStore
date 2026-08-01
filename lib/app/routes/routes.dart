// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const SPLASH = _Paths.SPLASH;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTER = _Paths.REGISTER;
  static const MAIN = _Paths.MAIN;
  static const BERANDA = _Paths.BERANDA;
  static const DETAIL_PRODUK = _Paths.DETAIL_PRODUK;
  static const KERANJANG = _Paths.KERANJANG;
  static const CHECKOUT = _Paths.CHECKOUT;
}

abstract class _Paths {
  _Paths._();
  static const SPLASH = '/splash';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const MAIN = '/main';
  static const BERANDA = '/beranda';
  static const DETAIL_PRODUK = '/detail-produk';
  static const KERANJANG = '/keranjang';
  static const CHECKOUT = '/checkout';
}

