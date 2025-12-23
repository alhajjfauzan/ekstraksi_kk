import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ekstraksi KK',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
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
  final TextEditingController _noKKController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _rtController = TextEditingController();
  final TextEditingController _rwController = TextEditingController();
  final TextEditingController _kelurahanController = TextEditingController();
  final TextEditingController _kecamatanController = TextEditingController();
  final TextEditingController _kabupatenController = TextEditingController();
  final TextEditingController _provinsiController = TextEditingController();
  final TextEditingController _tglKeluarBerkasController =
      TextEditingController();
  List<Map<String, TextEditingController>> _anggotaControllers = [];

  @override
  void initState() {
    super.initState();
    _anggotaControllers.add(_buatControllerAnggota());
  }
  Map<String, TextEditingController> _buatControllerAnggota() {
    return {
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
    };
  }
  void _tambahAnggota() {
    setState(() {
      _anggotaControllers.add(_buatControllerAnggota());
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Anggota keluarga ditambahkan'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            if (_anggotaControllers.length > 1) {
              setState(() {
                _anggotaControllers.removeLast();
              });
            }
          },
        ),
      ),
    );
  }
  void _hapusAnggota(int index) {
    if (_anggotaControllers.length == 1) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Anggota"),
        content:
            const Text("Yakin ingin menghapus anggota keluarga ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() {
                _anggotaControllers.removeAt(index);
              });
              Navigator.pop(context);
            },
            child: const Text("Hapus"),
          ),
        ],
      ),
    );
  }

  // ================= AMBIL GAMBAR =================
  Future<void> _ambilGambar(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _noKKController.text = "1234567890123456";
      _alamatController.text = "Jl. Contoh No. 123";
    });

    if (!mounted) return;
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Ekstraksi berhasil")),
    );
  }

  // ================= SIMPAN DATA =================
  void _simpanData() {
    print("No KK: ${_noKKController.text}");
    for (int i = 0; i < _anggotaControllers.length; i++) {
      print("Anggota ${i + 1}: ${_anggotaControllers[i]['nama']?.text}");
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Data berhasil disimpan")),
    );
  }

  // ================= UI =================
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Data Kartu Keluarga",
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            _buildTextField("No KK", _noKKController),
            _buildTextField("Alamat", _alamatController),

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
            _buildTextField(
                "Tanggal Keluar Berkas", _tglKeluarBerkasController),

            const Divider(height: 40, thickness: 2),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _anggotaControllers.length,
              itemBuilder: (context, index) =>
                  _buildAnggotaForm(index),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: _tambahAnggota,
              icon: const Icon(Icons.add),
              label: const Text("Tambah Anggota Keluarga"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _simpanData,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
              child: const Text("SIMPAN DATA",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTextField(
      String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnggotaForm(int index) {
    final anggota = _anggotaControllers[index];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Anggota Keluarga ${index + 1}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            IconButton(
              icon:
                  const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _hapusAnggota(index),
            ),
          ],
        ),
        _buildTextField("Nama", anggota['nama']!),
        _buildTextField("NIK", anggota['nik']!),
        _buildTextField("Jenis Kelamin", anggota['jenisKelamin']!),
        _buildTextField("Tempat Lahir", anggota['tempatLahir']!),
        _buildTextField("Tanggal Lahir", anggota['tanggalLahir']!),
        _buildTextField("Agama", anggota['agama']!),
        _buildTextField("Pendidikan", anggota['pendidikan']!),
        _buildTextField("Pekerjaan", anggota['pekerjaan']!),
        _buildTextField("Golongan Darah", anggota['golonganDarah']!),
        _buildTextField(
            "Status Perkawinan", anggota['statusPerkawinan']!),
        _buildTextField(
            "Tanggal Perkawinan", anggota['tanggalPerkawinan']!),
        _buildTextField("Hubungan", anggota['hubungan']!),
        _buildTextField(
            "Kewarganegaraan", anggota['kewarganegaraan']!),
        Row(
          children: [
            Expanded(
                child:
                    _buildTextField("No Paspor", anggota['noPaspor']!)),
            const SizedBox(width: 10),
            Expanded(
                child:
                    _buildTextField("No KITAP", anggota['noKitap']!)),
          ],
        ),
        _buildTextField("Nama Ayah", anggota['namaAyah']!),
        _buildTextField("Nama Ibu", anggota['namaIbu']!),
        const SizedBox(height: 20),
      ],
    );
  }
}
