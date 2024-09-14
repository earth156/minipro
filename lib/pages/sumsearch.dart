import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:minipro/pages/showlotto.dart';
import 'package:minipro/pages/wallet.dart';
import 'package:minipro/pages/profilecus.dart';
import 'package:minipro/pages/Resultslotto.dart';

class SumsearchPage extends StatefulWidget {
  final int userId; // เพิ่มการรับพารามิเตอร์ userId
  const SumsearchPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<SumsearchPage> createState() => _SumsearchPageState();
}

class _SumsearchPageState extends State<SumsearchPage> {
  String searchQuery = '';
  int _selectedIndex = 0; // กำหนดค่าเริ่มต้นให้กับ _selectedIndex

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LOTTO',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple[900], // สีของ AppBar
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              log('Help button pressed');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft, // จัดตำแหน่งให้ชิดซ้าย
                child: SizedBox(
                  width: 300, // กำหนดความกว้างของ TextField
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'ค้นหา...', // ข้อความคำแนะนำ
                      hintStyle: const TextStyle(color: Colors.white), // เปลี่ยนสีเป็นสีขาว
                      prefixIcon: const Icon(Icons.search, color: Colors.white), // เปลี่ยนสีไอคอนเป็นสีขาว
                      filled: true,
                      fillColor: Colors.deepPurple[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0), // เพิ่มช่องว่างระหว่าง TextField และคอนเทนต์อื่นๆ
              Text(
                'ผลการค้นหา: $searchQuery',
                style: const TextStyle(fontSize: 18.0),
              ),
              // ตัวอย่างคอนเทนต์เพิ่มเติม
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet), // ไอคอน Wallet
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_task),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShowlottoPage(userId: widget.userId)), // ดึง userId จาก widget
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WalletPage(userId: widget.userId)), // ดึง userId จาก widget
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilecusPage(userId: widget.userId)), // ดึง userId จาก widget
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ResultLottoPage(userId: widget.userId)), // ดึง userId จาก widget
            );
          }
        },
        backgroundColor: Colors.indigo[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
