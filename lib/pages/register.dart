import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minipro/config/internal_config.dart';
import 'package:minipro/pages/login.dart'; // นำเข้า LoginPage

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String errorText = '';
  final TextEditingController nameCtl = TextEditingController();
  final TextEditingController phoneCtl = TextEditingController();
  final TextEditingController emailCtl = TextEditingController();
  final TextEditingController bankCtl = TextEditingController();
  final TextEditingController passwordCtl1 = TextEditingController();
  final TextEditingController passwordCtl2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LOTTO', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo[900],
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
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Text(
                'สมัครสมาชิก',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('ชื่อ-นามสกุล'),
                    ],
                  ),
                  TextField(
                    controller: nameCtl,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('หมายเลขโทรศัพท์'),
                      ],
                    ),
                  ),
                  TextField(
                    controller: phoneCtl,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('อีเมล์'),
                      ],
                    ),
                  ),
                  TextField(
                    controller: emailCtl,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
                  ),
                  // const Padding(
                  //   padding: EdgeInsets.only(top: 15),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       Text('บัญชีธนาคาร'),
                  //     ],
                  //   ),
                  // ),
                  // TextField(
                  //   controller: bankCtl,
                  //   decoration: const InputDecoration(
                  //       border: OutlineInputBorder(
                  //           borderSide: BorderSide(width: 1))),
                  // ),
                  const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('รหัสผ่าน'),
                      ],
                    ),
                  ),
                  TextField(
                    controller: passwordCtl1,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1))),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FilledButton(
                          onPressed: register,
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Colors.indigo[900]),
                          ),
                          child: const Text('สมัครสมาชิก'),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(errorText),
          ],
        ),
      ),
    );
  }

  Future<void> register() async {
    if (nameCtl.text.isEmpty ||
        phoneCtl.text.isEmpty ||
        emailCtl.text.isEmpty ||
        passwordCtl1.text.isEmpty ||
        passwordCtl2.text.isEmpty) {
      setState(() {
        errorText = 'กรุณาใส่ข้อมูลให้ครบทุกช่อง';
      });
      return;
    }

    if (passwordCtl1.text != passwordCtl2.text) {
      setState(() {
        errorText = 'รหัสผ่านและการยืนยันรหัสผ่านไม่ตรงกัน!';
      });
      return;
    }

    final response = await http.post(
      Uri.parse('$API_ENDPOINT/register'), // ใช้ URL ของ API ของคุณที่นี่
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: jsonEncode({
        'username': nameCtl.text,
        'password': passwordCtl1.text,
        'email': emailCtl.text,
        'phone': phoneCtl.text,
        'img': '', // ถ้ามีฟิลด์นี้ให้ใส่ข้อมูลที่เหมาะสม
      }),
    );

    if (response.statusCode == 200) {
      log('Response body: ${response.body}');
      final data = jsonDecode(response.body);
      if (data['error'] == null) {
        // แสดง SnackBar เมื่อสมัครสมาชิกสำเร็จ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('สมัครสมาชิกสำเร็จ'),
            duration: Duration(seconds: 2), // ใช้ const กับ Duration
          ),
        );
        // นำทางไปยังหน้าล็อกอิน
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      } else {
        setState(() {
          errorText = data['error'];
        });
      }
    } else {
      setState(() {
        errorText = 'ไม่สามารถลงทะเบียนได้ ลองใหม่อีกครั้ง';
      });
    }
  }
}
