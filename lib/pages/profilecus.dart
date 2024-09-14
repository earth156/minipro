import 'dart:convert';
import 'dart:developer'; // นำเข้าเพื่อใช้ log
import 'dart:io'; // สำหรับจัดการไฟล์รูปภาพ
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // นำเข้า image_picker
import 'package:http/http.dart' as http;
import 'package:minipro/config/internal_config.dart';
import 'package:minipro/model/editUser.dart';
import 'package:minipro/model/users_login.dart';
import 'package:minipro/pages/wallet.dart';
import 'package:minipro/pages/showlotto.dart';
import 'package:minipro/pages/Resultslotto.dart';

class ProfilecusPage extends StatefulWidget {
  final int userId; // รับ userId เป็นพารามิเตอร์

  const ProfilecusPage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilecusPage> createState() => ProfilecusPageState();
}

class ProfilecusPageState extends State<ProfilecusPage> {
  final TextEditingController nameCtl = TextEditingController();
  final TextEditingController phoneCtl = TextEditingController();
  final TextEditingController emailCtl = TextEditingController();
  final TextEditingController passwordCtl1 = TextEditingController();
  final TextEditingController passwordCtl2 = TextEditingController();

  int _selectedIndex = 0; // กำหนดค่าเริ่มต้นให้กับ _selectedIndex
  File? _image; // ตัวแปรสำหรับเก็บไฟล์รูปภาพ
  final ImagePicker _picker = ImagePicker(); // ตัวเลือกการเลือกรูปภาพ

  @override
  void initState() {
    super.initState();

    // แสดงค่า userId ที่ได้รับ
    log('userId ที่ได้รับ: ${widget.userId}');
    
    showUser(); // เรียกใช้ฟังก์ชันเพื่อดึงข้อมูลผู้ใช้
  }

  // ฟังก์ชันเพื่อเลือกภาพจากแกลเลอรี
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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
      ),
      body: Stack(
        children: [
          // พื้นหลังสีขาว
          Container(
            color: Colors.white,
          ),
          // พื้นหลังสีน้ำเงิน
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 150.0,
              color: Colors.indigo[900], // สีพื้นหลังด้านบน
            ),
          ),
          // วงกลมโปรไฟล์พร้อมการเลือกภาพ
          Positioned(
            top: 80.0,
            left: MediaQuery.of(context).size.width / 2 - 70.0,
            child: GestureDetector(
              onTap: _pickImage, // เรียกใช้ฟังก์ชันเลือกรูปภาพเมื่อกด
              child: ClipOval(
                child: Container(
                  width: 130.0,
                  height: 130.0,
                  color: Colors.blueGrey[200],
                  child: _image == null
                      ? const Center(
                          child: Icon(
                            Icons.person,
                            size: 60.0,
                            color: Colors.white,
                          ),
                        )
                      : Image.file(
                          _image!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
          ),
          // ข้อความโปรไฟล์
          const Positioned(
            top: 30.0,
            left: 0.0,
            right: 15.0,
            child: Center(
              child: Text(
                'โปรไฟล์',
                style: TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            top: 200.0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text('ชื่อ-นามสกุล'),
                  ),
                  TextField(
                    controller: nameCtl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text('หมายเลขโทรศัพท์'),
                  ),
                  TextField(
                    controller: phoneCtl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text('อีเมล์'),
                  ),
                  TextField(
                    controller: emailCtl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Text('รหัสผ่าน'),
                  ),
                  TextField(
                    controller: passwordCtl1,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('ยืนยันรหัสผ่าน'),
                      ],
                    ),
                  ),
                  TextField(
                    controller: passwordCtl2,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // เช็คการยืนยันรหัสผ่าน
                        if (passwordCtl1.text != passwordCtl2.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('รหัสผ่านไม่ตรงกัน')),
                          );
                        } else {
                          // เรียกใช้ฟังก์ชัน editUser เพื่ออัปเดตข้อมูล
                          editUser();
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.yellow[700],
                        ),
                      ),
                      child: const Text(
                        'แก้ไขข้อมูล',
                        style: TextStyle(color: Colors.white),
                      ),
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ShowlottoPage(userId: widget.userId),
              ),
            );
          } else if (index == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WalletPage(userId: widget.userId),
              ),
            );
          } else if (index == 2) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultLottoPage(userId: widget.userId),
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

  Future<void> showUser() async {
    final String apiUrl = '$API_ENDPOINT/showUser/${widget.userId}'; // ใช้ URL ที่รองรับการดึงข้อมูลตาม userId

    // ตรวจสอบและล็อกค่า apiUrl
    print('Calling API with URL: $apiUrl');

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // แปลงข้อมูล JSON ที่ได้รับเป็น Map
        final Map<String, dynamic> data = jsonDecode(response.body);

        // ตรวจสอบข้อมูลที่ได้รับจาก API
        print('Received data: $data');

        // สร้าง UserLogin จากข้อมูลที่ได้รับ
        final UserLogin user = UserLogin.fromJson(data);

        // เติมข้อมูลใน TextEditingController
        nameCtl.text = user.username;
        phoneCtl.text = user.phone;
        emailCtl.text = user.email;
        passwordCtl1.text = user.password; // แสดงรหัสผ่านที่ดึงมาจาก API ใน passwordCtl1
      } else {
        print('เกิดข้อผิดพลาดในการดึงข้อมูล: รหัสสถานะ ${response.statusCode}');
      }
    } catch (e) {
      print('ข้อผิดพลาดในการดึงข้อมูล: $e');
    }
  }

Future<void> editUser() async {
  final String apiUrl = '$API_ENDPOINT/editUser/${widget.userId}';

  // สร้างอ็อบเจ็กต์ของ EditUser โดยใช้ค่าจาก TextEditingController
  final EditUser updatedUser = EditUser(
    userId: widget.userId,
    username: nameCtl.text,
    password: passwordCtl1.text,
    email: emailCtl.text,
    phone: phoneCtl.text,
    img: '', // ปล่อยเป็นค่าว่างหากไม่เปลี่ยนแปลง
    types: 'customer',
    money: '2500',
  );

  // สร้าง request และเพิ่ม fields ต่างๆ
  final request = http.Request('PUT', Uri.parse(apiUrl))
    ..headers['Content-Type'] = 'application/json'
    ..body = jsonEncode(updatedUser.toJson());

  // แสดงค่าที่จะส่งไปใน log
  print('Sending request to $apiUrl with data: ${updatedUser.toJson()}');
  
  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      print('User updated successfully: $responseBody');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ข้อมูลถูกแก้ไขแล้ว')),
      );
    } else {
      final responseBody = await response.stream.bytesToString();
      print('Failed to update user: ${response.statusCode}, $responseBody');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่สามารถอัปเดตข้อมูลได้')),
      );
    }
  } catch (e) {
    print('Error updating user: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('เกิดข้อผิดพลาดในการอัปเดตข้อมูล')),
    );
  }
}


}
