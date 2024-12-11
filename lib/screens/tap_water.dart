import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:inovokasi_rebuild/Theme.dart';

class TapWater extends StatefulWidget {
  @override
  _TapWaterState createState() => _TapWaterState();
}

class _TapWaterState extends State<TapWater> {
  // Status untuk switch Keran (total 10 switch)
  List<bool> keranStatus = List.generate(10, (_) => false);

  @override
  void initState() {
    super.initState();
    // Ambil status awal keran dari API
    fetchKeranStatus();
  }

  // Fungsi untuk mengambil status keran dari API
  Future<void> fetchKeranStatus() async {
    final url = 'https://iqacs-duck.research-ai.my.id/api/control/states';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final relays = data['relays'];

        // Update status keran dengan data dari API
        setState(() {
          for (int i = 0; i < 10; i++) {
            keranStatus[i] = (relays['${i + 1}'] == 1); // 1 berarti keran aktif
          }
        });
      } else {
        // Handle error jika API gagal
        print('Failed to load keran status');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Fungsi untuk mengupdate status keran ke API
  Future<void> updateKeranStatus(int deviceId, bool state) async {
    final url = 'https://iqacs-duck.research-ai.my.id/api/control/manual';
    final data = {
      'device_id': deviceId,
      'state': state ? 1 : 0,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print('Keran ${deviceId} status updated to: ${state ? 'On' : 'Off'}');
      } else {
        print('Failed to update keran status');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Widget untuk setiap switch keran
  Widget keranSwitchTile(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: greyColor, // Warna latar belakang
        border: Border.all(color: Colors.brown, width: 1),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Keran ${index + 1}", style: TextStyle(fontSize: 14)),
          Switch(
            value: keranStatus[index],
            onChanged: (value) {
              setState(() {
                keranStatus[index] = value;
                // Update status keran ke API
                updateKeranStatus(
                    index + 1, value); // index + 1 karena ID dimulai dari 1
                print("Keran ${index + 1} ${value ? 'buka' : 'tutup'}");
              });
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kontrol Keran"),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 kolom
            crossAxisSpacing: 10.0, // Jarak antar kolom
            mainAxisSpacing: 10.0, // Jarak antar baris
            childAspectRatio: 2.0, // Menyesuaikan aspek rasio lebar dan tinggi
          ),
          itemCount: 10, // Total switch 10 (keran 1 hingga keran 10)
          itemBuilder: (context, index) {
            return keranSwitchTile(index); // Membuat switch untuk setiap keran
          },
        ),
      ),
    );
  }
}
