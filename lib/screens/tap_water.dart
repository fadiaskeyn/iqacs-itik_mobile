import 'package:flutter/material.dart';
import 'package:inovokasi_rebuild/Theme.dart';

class TapWater extends StatefulWidget {
  @override
  State<TapWater> createState() => _TapWaterState();
}

class _TapWaterState extends State<TapWater> {
  // Status untuk switch Pompa
  bool isPompa1On = false;
  bool isPompa2On = false;

  // Status untuk switch Keran (total 10 switch)
  List<bool> keranStatus = List.generate(10, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kontrol Pompa & Keran"),
        backgroundColor: darkBrown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Container abu-abu untuk Switch Pompa
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: darkBrown,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Switch Pompa 1
                  Column(
                    children: [
                      Text("Pompa 1",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Switch(
                        value: isPompa1On,
                        onChanged: (value) {
                          setState(() {
                            isPompa1On = value;
                            // Jika Pompa 1 mati, tutup keran 1-5
                            if (!isPompa1On) {
                              for (int i = 0; i < 5; i++) {
                                keranStatus[i] = false;
                                print("Keran ${i + 1} tutup");
                              }
                            }
                          });
                        },
                      ),
                    ],
                  ),

                  // Switch Pompa 2
                  Column(
                    children: [
                      Text("Pompa 2",
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                      Switch(
                        value: isPompa2On,
                        onChanged: (value) {
                          setState(() {
                            isPompa2On = value;
                            // Jika Pompa 2 mati, tutup keran 6-10
                            if (!isPompa2On) {
                              for (int i = 5; i < 10; i++) {
                                keranStatus[i] = false;
                                print("Keran ${i + 1} tutup");
                              }
                            }
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: Row(
                children: [
                  // Kolom Kiri (Keran 1-5)
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return keranSwitchTile(index, isPompa1On, "Pompa 1");
                      },
                    ), 
                  ),
                  const SizedBox(width: 16),
                  // Kolom Kanan (Keran 6-10)
                  Expanded(
                    child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return keranSwitchTile(
                            index + 5, isPompa2On, "Pompa 2");
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk setiap switch keran
  Widget keranSwitchTile(int index, bool isPompaOn, String pompaName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
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
              if (!isPompaOn) {
                // Tampilkan popup jika pompa belum menyala
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Pompa Belum Menyala"),
                      content: Text("Silahkan nyalakan $pompaName dulu."),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("OK"),
                        ),
                      ],
                    );
                  },
                );
              } else {
                // Buka atau tutup keran jika pompa menyala
                setState(() {
                  keranStatus[index] = value;
                  print("Keran ${index + 1} ${value ? 'buka' : 'tutup'}");
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
