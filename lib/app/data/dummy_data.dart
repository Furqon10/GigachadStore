import 'models/laptop_model.dart';

final List<Map<String, dynamic>> dummyLaptopProducts = [
  // ==================== GAMING ====================
  {
    'id': 'GM001',
    'name': 'ASUS ROG Strix G16',
    'kategori': 'Gaming',
    'price': 24999000.0,
    'rating': 4.7,
    'description':
        'Laptop gaming performa tinggi dengan sistem pendinginan optimal untuk gaming berat dan multitasking.',
    'specs':
        'Intel Core i7-13650HX, RAM 16GB, SSD 512GB, NVIDIA RTX 4060 8GB',
    'gambar': 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=800&q=80',
  },
  {
    'id': 'GM002',
    'name': 'Lenovo Legion 5 Pro',
    'kategori': 'Gaming',
    'price': 21500000.0,
    'rating': 4.6,
    'description':
        'Layar QHD 165Hz dengan performa grafis tangguh, cocok untuk gamer kompetitif.',
    'specs':
        'AMD Ryzen 7 7745HX, RAM 16GB, SSD 1TB, NVIDIA RTX 4060 8GB',
    'gambar': 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=800&q=80',
  },
  {
    'id': 'GM003',
    'name': 'MSI Katana 15',
    'kategori': 'Gaming',
    'price': 17999000.0,
    'rating': 4.4,
    'description':
        'Laptop gaming entry ke mid-range dengan layar refresh rate tinggi dan bodi ramping.',
    'specs':
        'Intel Core i7-13620H, RAM 16GB, SSD 512GB, NVIDIA RTX 4050 6GB',
    'gambar': 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800&q=80',
  },
  {
    'id': 'GM004',
    'name': 'Acer Predator Helios Neo 16',
    'kategori': 'Gaming',
    'price': 23499000.0,
    'rating': 4.5,
    'description':
        'Sistem pendingin ganda dan layar mini-LED untuk pengalaman gaming yang imersif.',
    'specs':
        'Intel Core i7-13700HX, RAM 16GB, SSD 1TB, NVIDIA RTX 4060 8GB',
    'gambar': 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=800&q=80',
  },
  {
    'id': 'GM005',
    'name': 'HP Omen 16',
    'kategori': 'Gaming',
    'price': 26999000.0,
    'rating': 4.6,
    'description':
        'Desain premium dengan performa CPU/GPU kelas atas untuk gaming dan streaming.',
    'specs':
        'AMD Ryzen 9 7940HS, RAM 16GB, SSD 1TB, NVIDIA RTX 4070 8GB',
    'gambar': 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=800&q=80',
  },
  {
    'id': 'GM006',
    'name': 'Dell G15 Gaming',
    'kategori': 'Gaming',
    'price': 15499000.0,
    'rating': 4.2,
    'description':
        'Pilihan laptop gaming terjangkau dengan performa yang cukup untuk game AAA setting menengah.',
    'specs':
        'Intel Core i5-13450HX, RAM 16GB, SSD 512GB, NVIDIA RTX 3050 6GB',
    'gambar': 'https://images.unsplash.com/photo-1603302576837-37561b2e2302?w=800&q=80',
  },

  // ==================== ULTRABOOK ====================
  {
    'id': 'UB001',
    'name': 'ASUS Zenbook 14 OLED',
    'kategori': 'Ultrabook',
    'price': 15999000.0,
    'rating': 4.5,
    'description':
        'Desain tipis dan ringan dengan layar OLED tajam, cocok untuk mobilitas tinggi.',
    'specs':
        'Intel Core i5-1340P, RAM 16GB, SSD 512GB, Intel Iris Xe Graphics',
    'gambar': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80',
  },
  {
    'id': 'UB002',
    'name': 'LG Gram 14',
    'kategori': 'Ultrabook',
    'price': 17499000.0,
    'rating': 4.4,
    'description':
        'Bobot super ringan dengan daya tahan baterai lama, ideal untuk kerja mobile sehari-hari.',
    'specs':
        'Intel Core i7-1360P, RAM 16GB, SSD 512GB, Intel Iris Xe Graphics',
    'gambar': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&q=80',
  },
  {
    'id': 'UB003',
    'name': 'Acer Swift Go 14',
    'kategori': 'Ultrabook',
    'price': 12999000.0,
    'rating': 4.3,
    'description':
        'Ultrabook harian dengan layar OLED dan performa cukup untuk produktivitas ringan.',
    'specs':
        'Intel Core i5-1335U, RAM 16GB, SSD 512GB, Intel Iris Xe Graphics',
    'gambar': 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&q=80',
  },
  {
    'id': 'UB004',
    'name': 'Lenovo Yoga Slim 7',
    'kategori': 'Ultrabook',
    'price': 16499000.0,
    'rating': 4.5,
    'description':
        'Bodi metal premium dengan efisiensi baterai tinggi berkat chip AMD terbaru.',
    'specs':
        'AMD Ryzen 7 7840U, RAM 16GB, SSD 512GB, AMD Radeon 780M',
    'gambar': 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=800&q=80',
  },
  {
    'id': 'UB005',
    'name': 'HP Spectre x360 14',
    'kategori': 'Ultrabook',
    'price': 21999000.0,
    'rating': 4.6,
    'description':
        'Convertible 2-in-1 dengan desain mewah dan layar sentuh beresolusi tinggi.',
    'specs':
        'Intel Core i7-1355U, RAM 16GB, SSD 1TB, Intel Iris Xe Graphics',
    'gambar': 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=800&q=80',
  },
  {
    'id': 'UB006',
    'name': 'Huawei MateBook X Pro',
    'kategori': 'Ultrabook',
    'price': 22499000.0,
    'rating': 4.7,
    'description':
        'Layar 3K dengan bezel sangat tipis dan bodi full metal yang elegan.',
    'specs':
        'Intel Core i7-1360P, RAM 16GB, SSD 1TB, Intel Iris Xe Graphics',
    'gambar': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80',
  },

  // ==================== BUSINESS ====================
  {
    'id': 'BZ001',
    'name': 'Lenovo ThinkPad X1 Carbon Gen 11',
    'kategori': 'Business',
    'price': 27500000.0,
    'rating': 4.8,
    'description':
        'Standar laptop bisnis premium dengan keamanan tingkat enterprise dan build quality kokoh.',
    'specs':
        'Intel Core i7-1355U, RAM 16GB, SSD 1TB, Intel Iris Xe Graphics',
    'gambar': 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=800&q=80',
  },
  {
    'id': 'BZ002',
    'name': 'Dell Latitude 7440',
    'kategori': 'Business',
    'price': 22999000.0,
    'rating': 4.5,
    'description':
        'Laptop bisnis andal dengan fitur manajemen IT terintegrasi dan konektivitas lengkap.',
    'specs':
        'Intel Core i5-1345U, RAM 16GB, SSD 512GB, Intel Iris Xe Graphics',
    'gambar': 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800&q=80',
  },
  {
    'id': 'BZ003',
    'name': 'HP EliteBook 840 G10',
    'kategori': 'Business',
    'price': 20999000.0,
    'rating': 4.4,
    'description':
        'Dilengkapi fitur privasi layar dan keamanan biometrik untuk kebutuhan korporat.',
    'specs':
        'Intel Core i5-1335U, RAM 16GB, SSD 512GB, Intel Iris Xe Graphics',
    'gambar': 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=800&q=80',
  },
  {
    'id': 'BZ004',
    'name': 'Lenovo ThinkPad T14 Gen 4',
    'kategori': 'Business',
    'price': 18999000.0,
    'rating': 4.3,
    'description':
        'Keyboard nyaman dan daya tahan tinggi, jadi andalan pekerja kantoran.',
    'specs':
        'AMD Ryzen 5 7530U, RAM 16GB, SSD 512GB, AMD Radeon Graphics',
    'gambar': 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=800&q=80',
  },
  {
    'id': 'BZ005',
    'name': 'ASUS ExpertBook B9',
    'kategori': 'Business',
    'price': 25999000.0,
    'rating': 4.6,
    'description':
        'Bobot di bawah 1 kg dengan ketahanan militer, cocok untuk eksekutif yang sering bepergian.',
    'specs':
        'Intel Core i7-1355U, RAM 16GB, SSD 1TB, Intel Iris Xe Graphics',
    'gambar': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80',
  },
  {
    'id': 'BZ006',
    'name': 'Dell Latitude 5440',
    'kategori': 'Business',
    'price': 16999000.0,
    'rating': 4.1,
    'description':
        'Opsi laptop bisnis mid-range dengan build quality solid dan harga bersaing.',
    'specs':
        'Intel Core i5-1335U, RAM 8GB, SSD 256GB, Intel Iris Xe Graphics',
    'gambar': 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800&q=80',
  },

  // ==================== CREATOR ====================
  {
    'id': 'CR001',
    'name': 'Apple MacBook Pro 14" M3',
    'kategori': 'Creator',
    'price': 32999000.0,
    'rating': 4.9,
    'description':
        'Performa chip Apple Silicon yang powerful untuk editing video dan desain grafis profesional.',
    'specs': 'Apple M3, RAM 16GB, SSD 512GB, GPU 10-core',
    'gambar': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&q=80',
  },
  {
    'id': 'CR002',
    'name': 'ASUS ProArt Studiobook 16',
    'kategori': 'Creator',
    'price': 29999000.0,
    'rating': 4.6,
    'description':
        'Layar dengan kalibrasi warna akurat dan GPU mumpuni untuk rendering dan animasi 3D.',
    'specs':
        'Intel Core i9-13980HX, RAM 32GB, SSD 1TB, NVIDIA RTX 4070 8GB',
    'gambar': 'https://images.unsplash.com/photo-1525547719571-a2d4ac8945e2?w=800&q=80',
  },
  {
    'id': 'CR003',
    'name': 'Dell XPS 15',
    'kategori': 'Creator',
    'price': 28999000.0,
    'rating': 4.5,
    'description':
        'Layar InfinityEdge dengan akurasi warna tinggi, cocok untuk editing foto dan video.',
    'specs':
        'Intel Core i7-13700H, RAM 16GB, SSD 512GB, NVIDIA RTX 4050 6GB',
    'gambar': 'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?w=800&q=80',
  },
  {
    'id': 'CR004',
    'name': 'MSI Creator Z16',
    'kategori': 'Creator',
    'price': 31499000.0,
    'rating': 4.6,
    'description':
        'Ditujukan untuk content creator dengan layar True Pixel dan GPU kelas atas.',
    'specs':
        'Intel Core i7-13700H, RAM 32GB, SSD 1TB, NVIDIA RTX 4060 8GB',
    'gambar': 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800&q=80',
  },
  {
    'id': 'CR005',
    'name': 'Lenovo Yoga Creator 7',
    'kategori': 'Creator',
    'price': 22999000.0,
    'rating': 4.4,
    'description':
        'Keseimbangan antara portabilitas dan performa grafis untuk editing konten sehari-hari.',
    'specs':
        'AMD Ryzen 7 7735H, RAM 16GB, SSD 512GB, NVIDIA RTX 4050 6GB',
    'gambar': 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=800&q=80',
  },
  {
    'id': 'CR006',
    'name': 'Microsoft Surface Laptop Studio 2',
    'kategori': 'Creator',
    'price': 35999000.0,
    'rating': 4.7,
    'description':
        'Layar fleksibel dengan stylus support, ideal untuk desainer dan digital artist.',
    'specs':
        'Intel Core i7-13700H, RAM 32GB, SSD 1TB, NVIDIA RTX 4060 8GB',
    'gambar': 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=800&q=80',
  },

  // ==================== ENTRY-LEVEL ====================
  {
    'id': 'EL001',
    'name': 'Acer Aspire 5',
    'kategori': 'Entry-Level',
    'price': 7999000.0,
    'rating': 4.2,
    'description':
        'Pilihan hemat untuk kebutuhan sehari-hari seperti browsing, mengetik, dan kuliah.',
    'specs':
        'Intel Core i3-1215U, RAM 8GB, SSD 256GB, Intel UHD Graphics',
    'gambar': 'https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=800&q=80',
  },
  {
    'id': 'EL002',
    'name': 'HP 14s',
    'kategori': 'Entry-Level',
    'price': 6499000.0,
    'rating': 4.0,
    'description':
        'Laptop ringkas dengan harga terjangkau, cocok untuk pelajar dan pemula.',
    'specs':
        'AMD Ryzen 3 7320U, RAM 8GB, SSD 256GB, AMD Radeon Graphics',
    'gambar': 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=800&q=80',
  },
  {
    'id': 'EL003',
    'name': 'Lenovo IdeaPad Slim 3',
    'kategori': 'Entry-Level',
    'price': 7499000.0,
    'rating': 4.1,
    'description':
        'Desain simpel dengan performa cukup untuk tugas kantor dan sekolah ringan.',
    'specs':
        'Intel Core i3-1315U, RAM 8GB, SSD 256GB, Intel UHD Graphics',
    'gambar': 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=800&q=80',
  },
  {
    'id': 'EL004',
    'name': 'ASUS Vivobook Go 14',
    'kategori': 'Entry-Level',
    'price': 8499000.0,
    'rating': 4.3,
    'description':
        'Storage lega dengan bodi ringan, pas untuk mahasiswa yang butuh laptop serbaguna.',
    'specs':
        'AMD Ryzen 5 7520U, RAM 8GB, SSD 512GB, AMD Radeon Graphics',
    'gambar': 'https://images.unsplash.com/photo-1531297484001-80022131f5a1?w=800&q=80',
  },
  {
    'id': 'EL005',
    'name': 'Dell Vostro 3420',
    'kategori': 'Entry-Level',
    'price': 9999000.0,
    'rating': 4.2,
    'description':
        'Opsi entry-level dengan build quality Dell yang solid untuk penggunaan jangka panjang.',
    'specs':
        'Intel Core i5-1235U, RAM 8GB, SSD 256GB, Intel Iris Xe Graphics',
    'gambar': 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=800&q=80',
  },
  {
    'id': 'EL006',
    'name': 'Axioo MyBook Pro',
    'kategori': 'Entry-Level',
    'price': 6999000.0,
    'rating': 3.9,
    'description':
        'Laptop lokal dengan harga sangat terjangkau, cocok untuk kebutuhan basic computing.',
    'specs':
        'Intel Core i5-1155G7, RAM 8GB, SSD 256GB, Intel Iris Xe Graphics',
    'gambar': 'https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=800&q=80',
  },
];

List<LaptopModel> get allLaptopProducts {
  return dummyLaptopProducts.map((json) => LaptopModel.fromMap(json)).toList();
}
