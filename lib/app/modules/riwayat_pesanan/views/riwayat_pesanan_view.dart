import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:waterxpress_admin/app/modules/riwayat_pesanan/controllers/riwayat_pesanan_controller.dart';
import 'package:waterxpress_admin/app/data/Riwayat.dart';
import 'package:waterxpress_admin/app/routes/app_pages.dart';
import 'package:intl/intl.dart';

class RiwayatPesananView extends StatefulWidget {
  const RiwayatPesananView({Key? key}) : super(key: key);

  @override
  _RiwayatPesananViewState createState() => _RiwayatPesananViewState();
}

class _RiwayatPesananViewState extends State<RiwayatPesananView> {
  int _currentIndex = 2;

  // Fungsi untuk memformat tanggal
  String _formatTanggal(DateTime tanggal) {
    return DateFormat('dd MMM yyyy HH:mm').format(tanggal);
  }

  // Fungsi untuk mendapatkan warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.green;
      case 'proses':
        return Colors.orange;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final RiwayatPesananController controller = Get.put(RiwayatPesananController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Riwayat Pesanan'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF40C4FF), Color(0xFF0288D1)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<List<Riwayat>>(
        stream: controller.getAllCompletedProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 50,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Terjadi kesalahan: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      controller.getAllCompletedProducts();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0288D1),
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Tidak ada riwayat pesanan'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Riwayat riwayat = snapshot.data![index];
              return Card(
                color: const Color.fromARGB(255, 237, 246, 255),
                elevation: 2,
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ID : ${riwayat.id}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            _formatTanggal(riwayat.tanggal),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Nama Pengguna : ${riwayat.nama}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Pesanan : ${riwayat.pesanan}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Total Pembayaran',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Rp${NumberFormat('#,###').format(riwayat.total_harga)},00',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0288D1),
                        ),
                      ),
                    ],
                  ),
                  ),
                );
            },
          );
        },
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        height: 57.0,
        items: const <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.home, size: 28, color: Colors.white),
              Text(
                'Home',
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 28, color: Colors.white),
              Text(
                'Konfir',
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.history, size: 28, color: Colors.white),
              Text(
                'Riwayat',
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
            ],
          ),
        ],
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          // Navigasi ke halaman baru
          switch (index) {
            case 0:
              Get.toNamed(Routes.HOME);
              break;
            case 1:
              Get.toNamed(Routes.KONFIRMASI_PESANAN);
              break;
            case 2:
              Get.toNamed(Routes.RIWAYAT_PESANAN);
              break;
          }
        },
        color: const Color(0xFF0288D1),
        buttonBackgroundColor: const Color(0xFF40C4FF),
        animationDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}