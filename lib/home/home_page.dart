import 'package:flutter/material.dart';
import '../screens/masuk_page.dart';
import '../screens/cuti_page.dart';
import '../screens/akun_page.dart';
import '../screens/kehadiran_list_page.dart';
import '../screens/riwayat_cuti_page.dart'; // ✅ Tambahkan ini
import '../services/kehadiran_service.dart';
import '../screens/pengaturan_page.dart'; // Tambahkan ini

class KehadiranHomePage extends StatefulWidget {
  final String name;
  final String token;

  KehadiranHomePage({required this.name, required this.token});

  @override
  _KehadiranHomePageState createState() => _KehadiranHomePageState();
}

class _KehadiranHomePageState extends State<KehadiranHomePage> {
  int _selectedIndex = 0;
  bool isWorking = false;

  void _onBottomNavTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => KehadiranListPage(token: widget.token),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RiwayatCutiPage(token: widget.token),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AkunPage(token: widget.token)),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Color(0xFF8FAFC6),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'HAD!R',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            // Spacer() dihapus karena tak perlu spasi ke ikon profil yang sudah dihapus
          ],
        ),
      ),
    );
  }


  Widget buildCircleButton(IconData icon, String label, {VoidCallback? onTap}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Color(0xFF8FAFC6),
          shape: CircleBorder(),
          elevation: 4,
          child: InkWell(
            customBorder: CircleBorder(),
            onTap: onTap,
            child: Container(
              width: 80,
              height: 80,
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildMainButtons(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 180,
          height: 180,
          margin: EdgeInsets.only(bottom: 24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('assets/images/avatar_user.jpeg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Text(
          'Hai, ${widget.name}!',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 24),
        if (isWorking)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              '✅ Anda sedang bekerja',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.green[700],
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              buildCircleButton(Icons.login, 'Masuk', onTap: () {
                setState(() {
                  isWorking = true;
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MasukPage(
                      name: widget.name,
                      token: widget.token,
                    ),
                  ),
                );
              }),
              buildCircleButton(Icons.logout, 'Keluar', onTap: () async {
                setState(() {
                  isWorking = false;
                });

                try {
                  final message = await KehadiranService.absenKeluar(widget.token);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("✅ $message")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("❌ Gagal absen keluar: $e")),
                  );
                }
              }),
              buildCircleButton(Icons.beach_access, 'Cuti', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CutiPage(token: widget.token),
                  ),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 72),
        child: _buildHeader(context),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: _buildMainButtons(context),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF8FAFC6),
        unselectedItemColor: Colors.grey[600],
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined), label: 'Kehadiran'),
          BottomNavigationBarItem(icon: Icon(Icons.beach_access_outlined), label: 'Cuti'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Akun'),
        ],
      ),
    );
  }
}
