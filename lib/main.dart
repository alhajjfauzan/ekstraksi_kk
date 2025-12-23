import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Import library image_picker

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ekstraksi KK',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const KKFormScreen(),
    );
  }
}

class KKFormScreen extends StatefulWidget {
  const KKFormScreen({super.key});

  @override
  State<KKFormScreen> createState() => _KKFormScreenState();
}

class _KKFormScreenState extends State<KKFormScreen> {
  final ImagePicker _picker = ImagePicker();

  // --- WADAH UNTUK MODEL MACHINE LEARNING ---
  Future<void> _prosesEkstraksiML(File imageFile) async {
    // Tampilkan loading saat proses ML berjalan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // TODO: Taruh kode integrasi model ML kamu di sini.
      // Contoh simulasi hasil ekstraksi:
      await Future.delayed(const Duration(seconds: 2)); // Simulasi waktu proses
      
      String hasilScanNoKK = "1234567890123456"; 
      String hasilScanAlamat = "Jl. Contoh No. 123";

      // Update isi text field dengan hasil scan
      setState(() {
        _noKKController.text = hasilScanNoKK;
        _alamatController.text = hasilScanAlamat;
        // Kamu bisa menambahkan pengisian field lainnya di sini
      });

      if (!mounted) return;
      Navigator.pop(context); // Tutup loading
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ekstraksi Berhasil!')),
      );
    } catch (e) {
      Navigator.pop(context);
      print("Error saat ekstraksi: $e");
    }
  }

  // Fungsi untuk memicu kamera/galeri
  Future<void> _ambilGambar(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      _prosesEkstraksiML(File(pickedFile.path));
    }
  }

  // Controller untuk data utama KK
  final TextEditingController _noKKController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();
  final TextEditingController _kelurahanController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kabupatenController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _tglKeluarBerkasController = TextEditingController();
  // List untuk menampung controller setiap anggota keluarga
  List<Map<String, TextEditingController>> _anggotaControllers = [];

  @override
  void initState() {
    super.initState();
    // Menambah satu anggota keluarga pertama secara default
    _tambahAnggota();
  }

  void _tambahAnggota() {
    setState(() {
      _anggotaControllers.add({
        'nama': TextEditingController(),
        'nik': TextEditingController(),
        'jenisKelamin': TextEditingController(),
        'tempatLahir': TextEditingController(),
        'tanggalLahir': TextEditingController(),
        'agama': TextEditingController(),
        'pendidikan': TextEditingController(),
        'pekerjaan': TextEditingController(),
        'golonganDarah': TextEditingController(),
        'statusPerkawinan': TextEditingController(),
        'tanggalPerkawinan': TextEditingController(),
        'hubungan': TextEditingController(),
        'kewarganegaraan': TextEditingController(),
        'noPaspor': TextEditingController(),
        'noKitap': TextEditingController(),
        'namaAyah': TextEditingController(),
        'namaIbu': TextEditingController(),
      });
    });
  }

  void _simpanData() {
    // Di sini logika untuk menyimpan data (misal ke database atau print ke console)
    print("Nomor KK: ${_noKKController.text}");
    for (var i = 0; i < _anggotaControllers.length; i++) {
      print("Anggota ${i + 1}: ${_anggotaControllers[i]['nama']?.text}");
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data Berhasil Disimpan!')),
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text("Prototype Ekstraksi KK"),
      actions: [
        IconButton(
          icon: const Icon(Icons.camera_alt),
          onPressed: () => _ambilGambar(ImageSource.camera),
        ),
        IconButton(
          icon: const Icon(Icons.photo_library),
          onPressed: () => _ambilGambar(ImageSource.gallery),
        ),
      ],
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Menjaga teks tetap di kiri
        children: [
          // 1. Banner Petunjuk
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text("Gunakan tombol kamera di atas untuk scan KK secara otomatis."),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),

          // 2. Form Data Utama Kartu Keluarga
          const Text("Data Kartu Keluarga", 
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 10),
          
          _buildTextField("No KK", _noKKController),
          _buildTextField("Alamat", _alamatController),
          
          // RT dan RW bersampingan (Opsional: Menggunakan Row)
          Row(
            children: [
              Expanded(child: _buildTextField("RT", _rtController)),
              const SizedBox(width: 10),
              Expanded(child: _buildTextField("RW", _rwController)),
            ],
          ),
          
          _buildTextField("Kelurahan", _kelurahanController),
          _buildTextField("Kecamatan", _kecamatanController),
          _buildTextField("Kabupaten", _kabupatenController),
          _buildTextField("Provinsi", _provinsiController),
          _buildTextField("Tanggal Keluar Berkas", _tglKeluarBerkasController),
          
          const Divider(height: 40, thickness: 2),
          
          // 3. Form Anggota Keluarga (Dinamis)
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _anggotaControllers.length,
            itemBuilder: (context, index) {
              return _buildAnggotaForm(index);
            },
          ),
          
          const SizedBox(height: 20),
          
          // 4. Tombol Aksi
          ElevatedButton.icon(
            onPressed: _tambahAnggota,
            icon: const Icon(Icons.add),
            label: const Text("Tambah Anggota Keluarga"),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              side: const BorderSide(color: Colors.grey),
            ),
          ),
          
          const SizedBox(height: 12),
          
          ElevatedButton(
            onPressed: _simpanData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
            child: const Text("SIMPAN DATA SEKARANG", 
              style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          
          const SizedBox(height: 30), // Padding bawah agar tidak mepet
        ],
      ),
    ),
  );
}

  // Widget pendukung untuk membuat TextField agar kode lebih rapi
  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk form anggota keluarga
  Widget _buildAnggotaForm(int index) {
    final anggota = _anggotaControllers[index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Anggota Keluarga ${index + 1}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        // Gunakan operator ?? untuk memberikan controller baru jika key tidak ditemukan (safety)
        _buildTextField("Nama Lengkap", anggota['nama'] ?? TextEditingController()),
        _buildTextField("NIK", anggota['nik'] ?? TextEditingController()),
        _buildTextField("Jenis Kelamin", anggota['jenisKelamin'] ?? TextEditingController()),
        _buildTextField("Tempat Lahir", anggota['tempatLahir'] ?? TextEditingController()),
        _buildTextField("Tanggal Lahir", anggota['tanggalLahir'] ?? TextEditingController()),
        _buildTextField("Agama", anggota['agama'] ?? TextEditingController()),
        _buildTextField("Pendidikan", anggota['pendidikan'] ?? TextEditingController()),
        _buildTextField("Pekerjaan", anggota['pekerjaan'] ?? TextEditingController()),
        _buildTextField("Golongan Darah", anggota['golonganDarah'] ?? TextEditingController()),
        _buildTextField("Status Perkawinan", anggota['statusPerkawinan'] ?? TextEditingController()),
        _buildTextField("Tanggal Perkawinan", anggota['tanggalPerkawinan'] ?? TextEditingController()),
        _buildTextField("Status Hubungan dalam Keluarga", anggota['hubungan'] ?? TextEditingController()),
        _buildTextField("Kewarganegaraan", anggota['kewarganegaraan'] ?? TextEditingController()),
        Row(
            children: [
              Expanded(child: _buildTextField("No Paspor", anggota['noPaspor'] ?? TextEditingController())),
              const SizedBox(width: 10),
              Expanded(child: _buildTextField("No KITAP", anggota['noKitap'] ?? TextEditingController())),
            ],
          ),
        _buildTextField("No KITAP", anggota['noKitap'] ?? TextEditingController()),
        _buildTextField("Nama Ayah", anggota['namaAyah'] ?? TextEditingController()),
        _buildTextField("Nama Ibu", anggota['namaIbu'] ?? TextEditingController()),
        const SizedBox(height: 20),
      ],
    );
  }
}