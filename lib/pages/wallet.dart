import 'dart:convert'; // สำหรับการแปลง JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // สำหรับการทำ HTTP request
import 'package:minipro/config/internal_config.dart';
import 'package:minipro/pages/showlotto.dart';
import 'package:minipro/pages/profilecus.dart';
import 'package:minipro/pages/Resultslotto.dart';

import '../model/users_login.dart';
 // เพิ่ม import เพื่อใช้ UserLogin model

class WalletPage extends StatefulWidget {
  final int userId; // เพิ่มการรับพารามิเตอร์ userId
  const WalletPage({Key? key, required this.userId}) : super(key: key); // แก้ constructor เพื่อรับ userId

  @override
  State<WalletPage> createState() => WalletPageState();
}

class WalletPageState extends State<WalletPage> {
  late final int userId;
  int _selectedIndex = 1; // กำหนดค่าเริ่มต้นให้กับ _selectedIndex เป็น 1 (WalletPage)
  String walletAmount = 'Loading...'; // ตัวแปรสำหรับเก็บจำนวนเงิน

  @override
  void initState() {
    super.initState();
    userId = widget.userId; // กำหนดค่า userId จาก widget

    // ตรวจสอบว่าได้รับค่า userId หรือไม่
    if (userId <= 0) {
      print('Error: userId is not valid or not received.');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: userId is missing or invalid')),
        );
      });
    } else {
      print('Received userId: $userId');
      showWalletAmount(); // เรียกฟังก์ชันเพื่อดึงข้อมูลกระเป๋าเงิน
    }
  }

  Future<void> showWalletAmount() async {
    final String apiUrl = '$API_ENDPOINT/showUser/${widget.userId}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final UserLogin user = UserLogin.fromJson(data);

        // Log ค่า money ที่ได้รับจาก API
        print('Money received from API: ${user.money}');

        // อัพเดทจำนวนเงินที่แสดงบนหน้า
        setState(() {
          walletAmount = user.money; // ดึงจำนวนเงินจาก model
        });
      } else {
        print('เกิดข้อผิดพลาดในการดึงข้อมูล: รหัสสถานะ ${response.statusCode}');
      }
    } catch (e) {
      print('เกิดข้อผิดพลาด: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LOTTO',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo[900], // สีของ AppBar
      ),
      body: Column(
        children: [
          // Sidebox ที่อยู่ติดกับ AppBar และมีความกว้างเต็มจอ
          Container(
            width: double.infinity,
            height: 200.0, // กำหนดความสูงของ Sidebox
            color: Colors.indigo[900], // สีพื้นหลังของ Sidebox
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              top: 40.0, // เพิ่ม padding ด้านบน
            ), // Padding ภายใน Sidebox
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'ยอดเงินคงเหลือ',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10), // เพิ่มระยะห่างระหว่างข้อความ
                Text(
                  '$walletAmount บาท', // แสดงจำนวนเงินที่ดึงมาจาก API
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // เนื้อหาหลักของหน้า
          // const Expanded(
          //   child: Center(
          //     child: Text('This is the Wallet page content.'),
          //   ),
          // ),
        ],
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
            icon: Icon(Icons.add_task),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
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
              MaterialPageRoute(builder: (context) => ShowlottoPage(userId: userId)),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ResultLottoPage(userId: userId)),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilecusPage(userId: userId)),
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
