import 'package:flutter/material.dart';
import 'package:inovokasi_rebuild/Theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(
          'Profil Pengguna',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture, Name, and Role
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/profile_image2.png'),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Admin',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Owner',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Divider
              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),
              SizedBox(height: 20),
              // Informasi Pribadi Header
              Text(
                'Informasi Pribadi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              _buildProfileItem(
                icon: Icons.phone,
                title: 'Nomor Telepon',
                value: '+6285745616430',
              ),
              _buildProfileItem(
                icon: Icons.email,
                title: 'Email',
                value: 'admin@gmail.com',
              ),
              _buildProfileItem(
                icon: Icons.lock,
                title: 'Ganti Password',
              ),
              SizedBox(height: 30),
              // Kembali Button
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Log Out',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    String? title,
    String? value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Icon
          Icon(icon, color: Colors.brown, size: 30),
          SizedBox(width: 20),
          // Column for title and value
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? '',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              if (value != null) ...[
                SizedBox(height: 5),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
