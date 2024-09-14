import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minipro/config/internal_config.dart';
import 'package:minipro/model/lotto_numbers.dart';
import 'package:minipro/pages/Resultslotto.dart';
import 'package:minipro/pages/profilecus.dart';
import 'package:minipro/pages/sumsearch.dart';
import 'package:minipro/pages/cart.dart';
import 'package:minipro/pages/wallet.dart'; // นำเข้า WalletPage

class ShowlottoPage extends StatefulWidget {
  const ShowlottoPage({Key? key, required this.userId}) : super(key: key);
  final int userId; // รับค่า userId จากการล็อกอิน

  @override
  State<ShowlottoPage> createState() => _ShowlottoPageState();
}

class _ShowlottoPageState extends State<ShowlottoPage> {
  String searchQuery = '';
  int _selectedIndex = 0;
  List<LottoNumbers> _lottoNumbers = [];

  @override
  void initState() {
    super.initState();
    log('userId ที่ได้รับจากการล็อกอิน: ${widget.userId}');
    Showlotto(); // เรียกฟังก์ชัน Showlotto
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 300,
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SumsearchPage(userId: widget.userId)),
                          );
                        },
                      ),
                      filled: true,
                      fillColor: Colors.indigo[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    FilledButton(
                      onPressed: Showlotto,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            Colors.indigo[900]), // กำหนดสีของปุ่ม
                      ),
                      child: const Text('ทั้งหมด'),
                    ),
                    const SizedBox(width: 16.0),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                child: ListView.builder(
                  itemCount: _lottoNumbers.length,
                  itemBuilder: (context, index) {
                    final lotto = _lottoNumbers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'หมายเลข: ${lotto.lottoNum}',
                              style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'ราคา: ${lotto.price} บาท',
                              style: const TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.add_shopping_cart, color: Colors.indigo),
                          onPressed: () {
                            log('Add to cart button pressed for lotto number: ${lotto.lottoNum}');
                            lottoToCart(lotto); // เรียกใช้ฟังก์ชัน lottoToCart
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.shopping_cart, size: 30),
                      onPressed: () {
                        log('Shopping cart button pressed');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CartPage(userId: widget.userId), // ส่ง userId ที่ถูกต้อง
                          ),
                        );
                      },
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
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WalletPage(userId: widget.userId), // ส่ง userId
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilecusPage(userId: widget.userId), // ส่ง userId
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResultLottoPage(userId: widget.userId), // ส่ง userId
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

  Future<void> Showlotto() async {
    try {
      log('เรียกใช้ API สำหรับ userId: ${widget.userId}');
      final response = await http.get(Uri.parse('$API_ENDPOINT/showlotto'));
      if (response.statusCode == 200) {
        log('ข้อมูล: ${response.body}');
        final data = jsonDecode(response.body) as List<dynamic>; // แปลงข้อมูลจาก JSON เป็น List

        // แปลง List ของ JSON เป็น List ของ LottoNumbers
        List<LottoNumbers> lottoNumbers = lottoNumbersFromJson(jsonEncode(data));
        log('ข้อมูลที่ได้รับ: $lottoNumbers');
        
        setState(() {
          _lottoNumbers = lottoNumbers; // บันทึกข้อมูลใน state ของคุณ
        });
      } else {
        log('ข้อผิดพลาด: ${response.statusCode}');
      }
    } catch (e) {
      log('ข้อผิดพลาด: $e');
    }
  }

Future<void> lottoToCart(LottoNumbers lotto) async {
  final String apiUrl = '$API_ENDPOINT/lottoToCart/${widget.userId}'; // ใช้ API endpoint ของคุณ

  // แสดงค่า userId และค่าที่ส่งไปใน request
  log('userId: ${widget.userId}');
  log('lottoId: ${lotto.lottoId}');
  log('lottoNum: ${lotto.lottoNum}');
  log('price: ${lotto.price}');

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'lotto_id': lotto.lottoId, // ส่ง lotto_id ผ่าน body
        // ไม่จำเป็นต้องส่งข้อมูลอื่น ๆ หากไม่ต้องการ
      }),
    );

    // แสดงสถานะการตอบกลับของ API
    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    if (response.statusCode == 200) {
      log('Lotto number added to cart successfully');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CartPage(userId: widget.userId), // ส่ง userId
        ),
      );
    } else {
      log('Failed to add lotto number to cart: ${response.body}');
    }
  } catch (e) {
    log('Error: $e');
  }
}

}
