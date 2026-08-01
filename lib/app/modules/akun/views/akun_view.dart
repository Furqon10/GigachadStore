import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/providers/database_helper.dart';
import '../../../routes/app_pages.dart';

class AkunView extends StatefulWidget {
  const AkunView({super.key});

  @override
  State<AkunView> createState() => _AkunViewState();
}

class _AkunViewState extends State<AkunView> {
  Map<String, dynamic>? _userSession;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserSession();
  }

  Future<void> _loadUserSession() async {
    final session = await DatabaseHelper.instance.getSesiPengguna();
    if (mounted) {
      setState(() {
        _userSession = session;
        _isLoading = false;
      });
    }
  }

  String _formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _showRiwayatPesanan(BuildContext context) async {
    final userEmail = _userSession?['email'] ?? 'guest@tokolaptop.com';
    final list = await DatabaseHelper.instance.getRiwayatTransaksi(userEmail: userEmail);

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Transaksi Saya',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: list.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 60, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Belum ada riwayat transaksi',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: list.length,
                        separatorBuilder: (c, i) => const SizedBox(height: 8),
                        itemBuilder: (context, index) {
                          final item = list[index];
                          final invoice = item['no_invoice'] ?? '-';
                          final total = (item['total_harga'] as num?)?.toDouble() ?? 0.0;
                          var status = item['status_sinkronisasi']?.toString() ?? 'Pesanan Diproses';
                          if (status == 'TERKIRIM_SERVER') status = 'Pesanan Diproses';
                          final lat = item['latitude'] ?? 0.0;
                          final lng = item['longitude'] ?? 0.0;

                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade50,
                                child: const Icon(Icons.receipt_long, color: Colors.blueAccent),
                              ),
                              title: Text(
                                invoice.toString(),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatRupiah(total),
                                    style: const TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    '📍 Lat: $lat, Lng: $lng',
                                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                                  ),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  status,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWishlist(BuildContext context) async {
    final userEmail = _userSession?['email'] ?? 'guest@tokolaptop.com';
    final list = await DatabaseHelper.instance.getWishlist(userEmail: userEmail);

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Wishlist Saya',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: list.isEmpty
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.favorite_border, size: 60, color: Colors.grey),
                                SizedBox(height: 8),
                                Text(
                                  'Wishlist Anda masih kosong',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: list.length,
                            separatorBuilder: (c, i) => const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final item = list[index];
                              final nama = item['nama_produk'] ?? '-';
                              final productId = item['product_id'] ?? '';

                              return ListTile(
                                leading: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade50,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(Icons.favorite, color: Colors.redAccent),
                                ),
                                title: Text(nama.toString(),
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('SKU: $productId', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.grey),
                                  onPressed: () async {
                                    await DatabaseHelper.instance.deleteWishlist(productId.toString(), userEmail: userEmail);
                                    if (!context.mounted) return;
                                    Navigator.pop(context);
                                    _showWishlist(context);
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _logout() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 8,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Colors.redAccent,
                  size: 38,
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'Konfirmasi Keluar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Apakah Anda yakin ingin keluar dari akun?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Batal', style: TextStyle(color: Colors.black87)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back();
                        await DatabaseHelper.instance.hapusSesiPengguna();
                        Get.offAllNamed(Routes.LOGIN);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nama = _userSession?['nama'] ?? 'Pengguna Toko';
    final email = _userSession?['email'] ?? 'user@tokolaptop.com';
    final noHp = _userSession?['no_hp'] ?? '-';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Header Profile Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.indigo.shade800],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.shade200.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.person, size: 40, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nama.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              email.toString(),
                              style: const TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                            if (noHp != '-') ...[
                              const SizedBox(height: 2),
                              Text(
                                '📱 $noHp',
                                style: const TextStyle(color: Colors.white70, fontSize: 11),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                '⭐ Member Verified',
                                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                const Text(
                  'Aktivitas & Transaksi',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 10),

                // Menu List
                _buildMenuTile(
                  icon: Icons.shopping_bag_outlined,
                  iconColor: Colors.blueAccent,
                  bgColor: Colors.blue.shade50,
                  title: 'Riwayat Pesanan',
                  subtitle: 'Lihat transaksi tersimpan milik Anda',
                  onTap: () => _showRiwayatPesanan(context),
                ),
                const SizedBox(height: 10),
                _buildMenuTile(
                  icon: Icons.favorite_outline,
                  iconColor: Colors.redAccent,
                  bgColor: Colors.red.shade50,
                  title: 'Wishlist Saya',
                  subtitle: 'Daftar laptop favorit tersimpan',
                  onTap: () => _showWishlist(context),
                ),
                const SizedBox(height: 10),
                _buildMenuTile(
                  icon: Icons.location_on_outlined,
                  iconColor: Colors.orangeAccent,
                  bgColor: Colors.orange.shade50,
                  title: 'Alamat Pengiriman & GPS',
                  subtitle: 'Lokasi pengiriman otomatis terhubung',
                  onTap: () => Get.snackbar('Lokasi GPS', 'Integrasi GPS aktif pada halaman Checkout'),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Pengaturan & Akun',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const SizedBox(height: 10),

                _buildMenuTile(
                  icon: Icons.settings_outlined,
                  iconColor: Colors.purpleAccent,
                  bgColor: Colors.purple.shade50,
                  title: 'Pengaturan Aplikasi',
                  subtitle: 'Preferensi & preferensi akun',
                  onTap: () => Get.snackbar('Info', 'Pengaturan aplikasi siap digunakan'),
                ),
                const SizedBox(height: 10),
                _buildMenuTile(
                  icon: Icons.logout,
                  iconColor: Colors.redAccent,
                  bgColor: Colors.red.shade50,
                  title: 'Keluar Dari Akun',
                  subtitle: 'Hapus sesi dan kembali ke Login',
                  titleColor: Colors.redAccent,
                  onTap: _logout,
                ),
              ],
            ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: titleColor ?? Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}

