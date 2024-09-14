import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:minipro/pages/showlotto.dart';
import 'package:minipro/pages/profilecus.dart';
import 'package:minipro/pages/wallet.dart';

class ResultLottoPage extends StatefulWidget {
  final int userId; // รับ userId เป็นพารามิเตอร์

  const ResultLottoPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ResultLottoPage> createState() => _ResultLottoPageState();
}

class _ResultLottoPageState extends State<ResultLottoPage> {
  int _selectedIndex = 0; // สถานะของ BottomNavigationBar
  bool isButtonEnabled = false; // สถานะของปุ่ม กำหนดเป็น false เพื่อปิดการใช้งาน
  String searchQuery = ''; // ตัวแปรเก็บค่าการค้นหา
  String resultMessage = ''; // ข้อความผลการค้นหา
  Color resultColor = Colors.transparent; // สีของข้อความผลการค้นหา

  void alllotto() {
    log('All lotto button pressed');
  }

  void checkLottoNumber() {
    final prizeNumbers = [
      '123456', '234567', '345678', '456789', '567890'
    ];

    if (prizeNumbers.contains(searchQuery)) {
      final prizeIndex = prizeNumbers.indexOf(searchQuery) + 1;
      setState(() {
        resultMessage = 'ยินดีด้วย! คุณถูกรางวัลที่ $prizeIndex\t\t\tเงินรางวัล: ${getPrizeMoney(prizeIndex)}';
        resultColor = Colors.green;
      });
    } else {
      setState(() {
        resultMessage = 'เสียใจด้วย คุณไม่ถูกรางวัล ขอให้ครั้งหน้าโชคดี';
        resultColor = Colors.red;
      });
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
          padding: const EdgeInsets.only(top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // จัดให้อยู่ตรงกลาง
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150, // กำหนดความกว้างของปุ่ม
                    height: 30, // กำหนดความสูงของปุ่ม
                    child: ElevatedButton(
                      onPressed: isButtonEnabled
                          ? alllotto // ถ้าปุ่มเปิดใช้งานให้เรียกฟังก์ชัน
                          : null, // ถ้าปุ่มปิดใช้งาน, onPressed = null
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.indigo[900],
                        ), // กำหนดสีของปุ่ม
                      ),
                      child: const Text(
                        'ตรวจผล LOTTO',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20), // เพิ่มช่องว่างระหว่างปุ่มและฟิลด์ค้นหา
              Center( // ใช้ Center เพื่อให้ TextField อยู่ตรงกลางหน้าจอ
                child: SizedBox(
                  width: 200, // กำหนดความกว้างของ TextField
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'ค้นหา...',
                      hintStyle: const TextStyle(color: Colors.white),
                      prefixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          log('Search button pressed');
                          checkLottoNumber(); // เรียกฟังก์ชันตรวจสอบหมายเลขล็อตโต้
                        },
                      ),
                      filled: true,
                      fillColor: Colors.indigo[900], // สีพื้นหลัง
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20), // ช่องว่างระหว่างกรอบแสดงรางวัลและข้อความผลการค้นหา
              Text(
                resultMessage,
                style: TextStyle(color: resultColor, fontSize: 16), // ใช้สีและขนาดที่กำหนด
              ),
              const SizedBox(height: 100), // ช่องว่างระหว่างปุ่มและข้อความ

              // กรอบแสดงรางวัลที่ 1-5 และเงินรางวัล
              Container(
                width: double.infinity, // กำหนดความกว้างเต็มหน้าจอ
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // เพิ่มระยะห่างซ้ายขวา
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 1; i <= 5; i++)
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8.0), // ช่องว่างระหว่างแต่ละรายการ
                        padding: const EdgeInsets.all(12.0), // ระยะห่างภายในกรอบ
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.indigo[900]!), // สีกรอบ
                          borderRadius: BorderRadius.circular(10.0), // มุมโค้งของกรอบ
                        ),
                        child: Text(
                          'รางวัลที่ $i:  หมายเลขล็อตโต้: ${getLottoNumber(i)}\t\t\t เงินรางวัล: ${getPrizeMoney(i)}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ),
                  ],
                ),
              ),
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
              MaterialPageRoute(
                builder: (context) => ShowlottoPage(userId: widget.userId), // ส่ง userId ไปด้วย
              ),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WalletPage(userId: widget.userId),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilecusPage(userId: widget.userId), // ส่ง userId ไปด้วย
              ),
            );
          }
        },
        backgroundColor: Colors.indigo[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  // ฟังก์ชันคืนค่าเงินรางวัลตามลำดับที่
  String getPrizeMoney(int rank) {
    final fakePrizes = [
      '1,000,000', // รางวัลที่ 1
      '500,000',   // รางวัลที่ 2
      '250,000',   // รางวัลที่ 3
      '100,000',   // รางวัลที่ 4
      '50,000',    // รางวัลที่ 5
    ];

    return fakePrizes[rank - 1];
  }

  // ฟังก์ชันคืนค่าหมายเลขล็อตโต้ปลอมตามลำดับที่
  String getLottoNumber(int rank) {
    final fakeLottoNumbers = [
      '123456', // รางวัลที่ 1
      '234567', // รางวัลที่ 2
      '345678', // รางวัลที่ 3
      '456789', // รางวัลที่ 4
      '567890', // รางวัลที่ 5
    ];

    return fakeLottoNumbers[rank - 1];
  }
}
