import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minipro/model/users_login.dart';
import 'package:minipro/pages/cart.dart';
import 'package:minipro/pages/register.dart';
import 'package:minipro/pages/showlotto.dart';
import 'package:minipro/pages_admin/adminrandom.dart';
import 'package:minipro/config/internal_config.dart';
import 'package:minipro/config/config.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String errorText = '';
  TextEditingController usernameCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();

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
              padding: EdgeInsets.only(top: 150.0),
              child: Text(
                'เข้าสู่ระบบ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'ชื่อบัญชี',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  TextField(
                    controller: usernameCtl,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'รหัสผ่าน',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: passwordCtl,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(width: 1),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: misspassword,
                          child: const Text('ลืมรหัสผ่าน',
                              style: TextStyle(color: Colors.black)),
                        ),
                        TextButton(
                          onPressed: register,
                          child: const Text('สมัครสมาชิก',
                              style: TextStyle(color: Colors.black)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FilledButton(
                          onPressed: login,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.indigo[900]),
                          ),
                          child: const Text('เข้าสู่ระบบ'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(errorText, style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  void register() {
    log('This is Register button');
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterPage(),
      ),
    );
  }

  void misspassword() {
    // Functionality for forgot password can be implemented here
  }

Future<void> login() async {
  final username = usernameCtl.text;
  final password = passwordCtl.text;

  if (username.isEmpty || password.isEmpty) {
    setState(() {
      errorText = 'กรุณากรอกชื่อผู้ใช้และรหัสผ่าน';
    });
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('$API_ENDPOINT/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      if (responseData.containsKey('message') &&
          responseData.containsKey('user_id') &&
          responseData.containsKey('types')) {
        
        final userLogin = UserLogin.fromJson(responseData);

        if (userLogin.types == 'customer') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ShowlottoPage(userId: userLogin.userId),
            ),
          );
        // } else if (userLogin.types == 'admin') {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //       builder: (context) => Adminrandom(userId: userLogin.userId),
        //     ),
        //   );
        } else {
          setState(() {
            errorText = 'ประเภทผู้ใช้ไม่ถูกต้อง';
          });
        }
      } else {
        setState(() {
          errorText = 'ข้อมูลการตอบกลับจากเซิร์ฟเวอร์ไม่ถูกต้อง';
        });
      }
    } else {
      setState(() {
        errorText = 'เกิดข้อผิดพลาดในการเข้าสู่ระบบ';
      });
    }
  } catch (e) {
    setState(() {
      errorText = 'ไม่สามารถเข้าสู่ระบบได้ ลองอีกครั้ง';
    });
    log('Login error: $e');
  }
}

}
