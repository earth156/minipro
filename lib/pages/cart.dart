import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minipro/config/internal_config.dart';
import 'package:minipro/model/lotto_numbers.dart';
import 'package:minipro/pages/Resultslotto.dart';
import 'package:minipro/pages/wallet.dart';
import 'package:minipro/pages/showlotto.dart';
import 'package:minipro/pages/profilecus.dart';

class CartPage extends StatefulWidget {
  final int userId; // รับ userId เป็นพารามิเตอร์

  const CartPage({super.key, required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedIndex = 0; // สถานะของ BottomNavigationBar
  bool _isCartEnabled = false; // สถานะของปุ่มตะกร้าสินค้า
  late Future<List<LottoNumbers>> _lottoNumbersFuture; // Future สำหรับเก็บข้อมูลล็อตโต้
  List<LottoNumbers> lottoNumbers = []; // ลิสต์เก็บข้อมูลล็อตโต้

  @override
  void initState() {
    super.initState();
    // แสดงค่า userId ใน log
    log('Received userId: ${widget.userId}');
    // เรียกใช้ฟังก์ชันเพื่อดึงข้อมูลล็อตโต้
    _lottoNumbersFuture = showlottoInCart();
  }

Future<List<LottoNumbers>> showlottoInCart() async {
  final String apiUrl = '$API_ENDPOINT/showlottoInCart/${widget.userId}'; // ใช้ userId ในการสร้าง URL

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> lottoList = data['lottoNumbers'] as List<dynamic>;

      if (lottoList.isEmpty) {
        // ถ้าไม่มีข้อมูลล็อตโต้ให้แสดงข้อความ
        return []; // หรือแสดงข้อความเตือนตามที่ต้องการ
      }

      lottoNumbers = lottoList
          .map((item) => LottoNumbers.fromJson(item))
          .toList();

      // ใช้ข้อมูลล็อตโต้
      return lottoNumbers;
    } else if (response.statusCode == 404) {
      // ถ้าไม่พบข้อมูลจาก API
      throw Exception('ไม่พบข้อมูลล็อตโต้สำหรับผู้ใช้');
    } else {
      throw Exception('ไม่สามารถดึงข้อมูลล็อตโต้ได้');
    }
  } catch (e) {
    // ใช้ข้อความที่เหมาะสมกับกรณีที่เกิดข้อผิดพลาด
    throw Exception('ข้อผิดพลาด: $e');
  }
}



Future<void> soldLotto(int lottoId) async {
  final String apiUrl = '$API_ENDPOINT/soldLotto/${widget.userId}';

  // ข้อมูลที่จะส่งในคำขอ POST
  final Map<String, dynamic> requestBody = {'lotto_id': lottoId};
  
  // แปลงข้อมูลเป็น JSON
  final String requestBodyJson = jsonEncode(requestBody);

  // แสดงข้อมูลที่ส่งไปในล็อก
  print('Request URL: $apiUrl');
  print('Request Body: $requestBodyJson');

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: requestBodyJson,
    );

    // ตรวจสอบสถานะการตอบกลับ
    if (response.statusCode == 200) {
      print('อัปเดตสถานะการขายสำเร็จ');
      // ไม่ต้องทำการดึงข้อมูลล็อตโต้ที่อัปเดตแล้ว
    } else {
      final responseBody = jsonDecode(response.body);
      print('เกิดข้อผิดพลาด: ${responseBody['error']}');
      throw Exception('Failed to update lotto status');
    }
  } catch (e) {
    print('Error: $e');
    throw Exception('Error: $e');
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
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0), // เพิ่ม padding รอบ UI หลัก
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // จัดตำแหน่งข้อความให้ชิดซ้าย
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: _isCartEnabled
                        ? () {
                            log('ตะกร้าสินค้า'); // ฟังก์ชันที่ทำงานเมื่อกดปุ่ม
                          }
                        : null, // ถ้า _isCartEnabled เป็น false จะปิดการใช้งานปุ่ม
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.indigo[900]), // กำหนดสีของปุ่ม
                    ),
                    child: const Text(
                      'ตะกร้าสินค้า',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20), // ช่องว่างระหว่างปุ่มและข้อความ
                const Text(
                  ': เลือกล็อตเตอรี่ที่คุณต้องการชำระ หรือเลือกทั้งหมดเพื่อชำระทั้งหมด',
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 20), // ช่องว่างระหว่างข้อความ
                const Align(
                  alignment: Alignment.centerRight, // จัดข้อความให้อยู่ด้านขวาสุด
                  child: Text(
                    'จำนวนสินค้าขณะนี้:  2 รายการ', // อัปเดตจำนวนสินค้าขณะนี้
                    style: TextStyle(fontSize: 13),
                  ),
                ),
                const SizedBox(height: 20), // ช่องว่างระหว่างข้อความ

                // กรอบแสดงรายการการซื้อ Lotto ในแต่ละแถว
                FutureBuilder<List<LottoNumbers>>(
                  future: _lottoNumbersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('เกิดข้อผิดพลาด: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('ไม่มีข้อมูลล็อตโต้ในตะกร้า'));
                    } else {
                      final lottoNumbers = snapshot.data!;
                      return Column(
                        children: lottoNumbers.map((lotto) {
                          return Container(
                            padding: const EdgeInsets.all(15.0),
                            width: double.infinity, // กว้างเต็มพื้นที่
                            decoration: BoxDecoration(
                              color: Colors.white, // สีพื้นหลังของกรอบ
                              borderRadius: BorderRadius.circular(10.0), // ขอบมุมโค้ง
                              border: Border.all(
                                color: Colors.black, // สีขอบของกรอบ
                                width: 2.0, // ความหนาของขอบ
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'หมายเลข: ${lotto.lottoNum}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),
                                const SizedBox(width: 20), // ช่องว่างระหว่างจำนวนและราคา
                                Text(
                                  'ราคา ${lotto.price} บาท', // แสดงราคาของล็อตโต้
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.indigo[900], // สีพื้นหลังของ Container
                borderRadius: BorderRadius.circular(10.0), // ขอบมุมโค้ง
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'รวม: 300 บาท', // อัปเดตจำนวนรวมให้ตรงกับราคาสินค้า
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  const SizedBox(width: 10), // ช่องว่างระหว่างราคาและปุ่ม
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        // เรียกใช้ฟังก์ชัน soldLotto สำหรับแต่ละรายการในตะกร้า
                        for (var lotto in lottoNumbers) {
                          await soldLotto(lotto.lottoId);
                        }

                        // แสดงข้อความเมื่อชำระเงินสำเร็จ
                        log('ชำระเงินเรียบร้อยแล้ว');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('ชำระเงินสำเร็จ')),
                        );

                        // อัปเดตข้อมูลล็อตโต้ในตะกร้า
                        // setState(() {
                        //   _lottoNumbersFuture = fetchUpdatedLottoNumbers();
                        // });
                      } catch (e) {
                        log('เกิดข้อผิดพลาด: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('เกิดข้อผิดพลาดในการชำระเงิน')),
                        );
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor: MaterialStateProperty.all(Colors.indigo[900]),
                    ),
                    child: const Text(
                      'ชำระเงิน',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
              MaterialPageRoute(builder: (context) => ShowlottoPage(userId: widget.userId)), // นำทางไป ShowlottoPage
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WalletPage(userId: widget.userId)), // นำทางไป WalletPage
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilecusPage(userId: widget.userId)), // นำทางไป ProfilecusPage
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ResultLottoPage(userId: widget.userId)), // นำทางไป ResultLottoPage
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
