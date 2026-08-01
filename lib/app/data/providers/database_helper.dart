import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../dummy_data.dart';
import '../models/cart_item_model.dart';
import '../models/laptop_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('toko_laptop.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        no_hp TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE produk (
        id TEXT PRIMARY KEY,
        name TEXT,
        kategori TEXT,
        price REAL,
        rating REAL,
        description TEXT,
        specs TEXT,
        gambar TEXT
      )
    ''');

    // Database Seeding untuk 30 produk laptop
    for (var item in dummyLaptopProducts) {
      await db.insert('produk', {
        'id': item['id'],
        'name': item['name'],
        'kategori': item['kategori'],
        'price': item['price'],
        'rating': item['rating'],
        'description': item['description'],
        'specs': item['specs'],
        'gambar': item['gambar'],
      });
    }

    await db.execute('''
      CREATE TABLE keranjang (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_email TEXT NOT NULL,
        product_id TEXT NOT NULL,
        nama_produk TEXT NOT NULL,
        harga REAL NOT NULL,
        qty INTEGER NOT NULL,
        gambar TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE sesi_pengguna (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id_server TEXT,
        nama TEXT,
        email TEXT,
        no_hp TEXT,
        access_token TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE riwayat_transaksi (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_email TEXT,
        no_invoice TEXT,
        total_harga REAL,
        latitude REAL,
        longitude REAL,
        status_sinkronisasi TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE wishlist (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_email TEXT,
        product_id TEXT,
        nama_produk TEXT,
        gambar TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE keranjang ADD COLUMN gambar TEXT');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS sesi_pengguna (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id_server TEXT,
          nama TEXT,
          email TEXT,
          no_hp TEXT,
          access_token TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS riwayat_transaksi (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          no_invoice TEXT,
          total_harga REAL,
          latitude REAL,
          longitude REAL,
          status_sinkronisasi TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS wishlist (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          product_id TEXT,
          nama_produk TEXT,
          gambar TEXT
        )
      ''');
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          nama TEXT NOT NULL,
          email TEXT NOT NULL UNIQUE,
          no_hp TEXT NOT NULL,
          password TEXT NOT NULL
        )
      ''');

      try {
        await db.execute('ALTER TABLE keranjang ADD COLUMN user_email TEXT DEFAULT "guest@tokolaptop.com"');
      } catch (_) {}
      try {
        await db.execute('ALTER TABLE riwayat_transaksi ADD COLUMN user_email TEXT DEFAULT "guest@tokolaptop.com"');
      } catch (_) {}
      try {
        await db.execute('ALTER TABLE wishlist ADD COLUMN user_email TEXT DEFAULT "guest@tokolaptop.com"');
      } catch (_) {}
    }

    if (oldVersion < 4) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS produk (
          id TEXT PRIMARY KEY,
          name TEXT,
          kategori TEXT,
          price REAL,
          rating REAL,
          description TEXT,
          specs TEXT,
          gambar TEXT
        )
      ''');

      final result = await db.rawQuery('SELECT COUNT(*) FROM produk');
      final count = (result.isNotEmpty && result.first.values.isNotEmpty)
          ? ((result.first.values.first as num?)?.toInt() ?? 0)
          : 0;
      if (count == 0) {
        for (var item in dummyLaptopProducts) {
          await db.insert('produk', {
            'id': item['id'],
            'name': item['name'],
            'kategori': item['kategori'],
            'price': item['price'],
            'rating': item['rating'],
            'description': item['description'],
            'specs': item['specs'],
            'gambar': item['gambar'],
          }, conflictAlgorithm: ConflictAlgorithm.replace);
        }
      } else {
        // Auto-sync image URLs if existing database has old picsum.photos links
        for (var item in dummyLaptopProducts) {
          await db.update(
            'produk',
            {'gambar': item['gambar']},
            where: 'id = ?',
            whereArgs: [item['id']],
          );
        }
      }
    }
  }

  // --- Produk SQLite Queries ---
  Future<List<LaptopModel>> getProdukList() async {
    final db = await instance.database;
    final result = await db.rawQuery('SELECT * FROM produk');
    return result.map((json) => LaptopModel.fromMap(json)).toList();
  }

  // --- Auth & Users ---
  Future<Map<String, dynamic>> registerUser({
    required String nama,
    required String email,
    required String noHp,
    required String password,
  }) async {
    final db = await instance.database;
    final existing = await db.query(
      'users',
      where: 'LOWER(email) = ?',
      whereArgs: [email.toLowerCase().trim()],
    );

    if (existing.isNotEmpty) {
      throw Exception('Email "$email" sudah terdaftar. Silakan login atau gunakan email lain.');
    }

    final userId = await db.insert('users', {
      'nama': nama.trim(),
      'email': email.toLowerCase().trim(),
      'no_hp': noHp.trim(),
      'password': password.trim(),
    });

    final userData = {
      'user_id_server': userId.toString(),
      'nama': nama.trim(),
      'email': email.toLowerCase().trim(),
      'no_hp': noHp.trim(),
      'access_token': 'token_user_$userId',
    };

    return userData;
  }

  Future<Map<String, dynamic>?> loginUser({
    required String email,
    required String password,
  }) async {
    final db = await instance.database;
    final result = await db.query(
      'users',
      where: 'LOWER(email) = ? AND (password = ? OR password = ?)',
      whereArgs: [email.toLowerCase().trim(), password.trim(), password],
    );

    if (result.isEmpty) {
      return null;
    }

    final user = result.first;
    final userData = {
      'user_id_server': user['id'].toString(),
      'nama': user['nama'],
      'email': user['email'],
      'no_hp': user['no_hp'],
      'access_token': 'token_user_${user['id']}',
    };

    await saveSesiPengguna(userData);
    return userData;
  }

  // --- Keranjang ---
  Future<int> insertCartItem(CartItemModel item, {String userEmail = 'guest@tokolaptop.com'}) async {
    final db = await instance.database;
    final existing = await db.query(
      'keranjang',
      where: 'product_id = ? AND user_email = ?',
      whereArgs: [item.productId, userEmail],
    );

    if (existing.isNotEmpty) {
      final existingItem = CartItemModel.fromMap(existing.first);
      final newQty = existingItem.qty + item.qty;
      return await updateQty(existingItem.id!, newQty);
    } else {
      final map = item.toMap();
      map['user_email'] = userEmail;
      return await db.insert('keranjang', map);
    }
  }

  Future<List<CartItemModel>> getCartItems({String userEmail = 'guest@tokolaptop.com'}) async {
    final db = await instance.database;
    final result = await db.query(
      'keranjang',
      where: 'user_email = ?',
      whereArgs: [userEmail],
      orderBy: 'id DESC',
    );
    return result.map((json) => CartItemModel.fromMap(json)).toList();
  }

  Future<int> updateQty(int id, int qty) async {
    final db = await instance.database;
    return await db.update(
      'keranjang',
      {'qty': qty},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCartItem(int id) async {
    final db = await instance.database;
    return await db.delete(
      'keranjang',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> clearCart({String userEmail = 'guest@tokolaptop.com'}) async {
    final db = await instance.database;
    return await db.delete(
      'keranjang',
      where: 'user_email = ?',
      whereArgs: [userEmail],
    );
  }

  // --- Sesi Pengguna ---
  Future<int> saveSesiPengguna(Map<String, dynamic> data) async {
    final db = await instance.database;
    await db.delete('sesi_pengguna');
    return await db.insert('sesi_pengguna', data);
  }

  Future<Map<String, dynamic>?> getSesiPengguna() async {
    final db = await instance.database;
    final result = await db.query('sesi_pengguna', limit: 1);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> hapusSesiPengguna() async {
    final db = await instance.database;
    return await db.delete('sesi_pengguna');
  }

  // --- Riwayat Transaksi ---
  Future<int> insertRiwayatTransaksi(Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert('riwayat_transaksi', data);
  }

  Future<List<Map<String, dynamic>>> getRiwayatTransaksi({String userEmail = 'guest@tokolaptop.com'}) async {
    final db = await instance.database;
    return await db.query(
      'riwayat_transaksi',
      where: 'user_email = ?',
      whereArgs: [userEmail],
      orderBy: 'id DESC',
    );
  }

  // --- Wishlist ---
  Future<int> insertWishlist(String productId, String namaProduk, String gambar, {String userEmail = 'guest@tokolaptop.com'}) async {
    final db = await instance.database;
    final existing = await db.query(
      'wishlist',
      where: 'product_id = ? AND user_email = ?',
      whereArgs: [productId, userEmail],
    );
    if (existing.isEmpty) {
      return await db.insert('wishlist', {
        'user_email': userEmail,
        'product_id': productId,
        'nama_produk': namaProduk,
        'gambar': gambar,
      });
    }
    return 0;
  }

  Future<int> deleteWishlist(String productId, {String userEmail = 'guest@tokolaptop.com'}) async {
    final db = await instance.database;
    return await db.delete(
      'wishlist',
      where: 'product_id = ? AND user_email = ?',
      whereArgs: [productId, userEmail],
    );
  }

  Future<List<Map<String, dynamic>>> getWishlist({String userEmail = 'guest@tokolaptop.com'}) async {
    final db = await instance.database;
    return await db.query(
      'wishlist',
      where: 'user_email = ?',
      whereArgs: [userEmail],
      orderBy: 'id DESC',
    );
  }

  Future<bool> isWishlisted(String productId, {String userEmail = 'guest@tokolaptop.com'}) async {
    final db = await instance.database;
    final result = await db.query(
      'wishlist',
      where: 'product_id = ? AND user_email = ?',
      whereArgs: [productId, userEmail],
    );
    return result.isNotEmpty;
  }
}



