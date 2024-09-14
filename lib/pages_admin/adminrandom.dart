import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:minipro/config/internal_config.dart';
import 'package:minipro/model/lotto_numbers.dart'; // Config for API endpoint

class Adminrandom extends StatefulWidget {
  const Adminrandom({Key? key}) : super(key: key);

  @override
  State<Adminrandom> createState() => _AdminrandomState();
}

class _AdminrandomState extends State<Adminrandom> {
  // List to hold winning Lotto numbers
  List<String?> winningNumbers = List.filled(5, null); // Create a list with 5 null entries

  // Randomize Lotto Numbers for all 5 prizes and Send to API
  Future<List<LottoNumbers>> randomizeAllPrizes() async {
    final String apiUrl = '$API_ENDPOINT/winningLotto'; // API URL

    try {
      // Send request to API without specific prize, let the API handle all 5 prizes
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'prizeMoney': [10000, 5000, 2500, 1000, 500], // Send the prize money for all 5 prizes
        }),
      );

      if (response.statusCode == 200) {
        // Parse response body
        final data = jsonDecode(response.body)['winningNumbers'] as List;

        // Convert JSON data into LottoNumbers model
        List<LottoNumbers> lottoNumbers = data.map((json) => LottoNumbers.fromJson(json)).toList();

        // Update winningNumbers list with lottoNumbers
        setState(() {
          for (int i = 0; i < lottoNumbers.length; i++) {
            winningNumbers[i] = lottoNumbers[i].lottoNum; // Update winning number in the list
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ส่งเลขและเงินรางวัลเรียบร้อยแล้ว')),
        );

        return lottoNumbers; // Return the list of LottoNumbers
      } else {
        final errorMsg = jsonDecode(response.body)['message'] ?? 'Failed to send prize details';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('Error occurred: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
      return []; // Return an empty list in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('LOTTO'),
            Icon(Icons.arrow_forward),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        'A',
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ยินดีต้อนรับกลับ',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text('Admin: Judy'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),

            // Display each prize with its winning number
            for (int i = 1; i <= 5; i++)
              LottoPrizeWidget(
                prizeNumber: i,
                winningNumber: winningNumbers[i - 1], // Pass the winning number
              ),

            // Add a single button to randomize all 5 prizes
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  randomizeAllPrizes(); // Call the function to randomize all prizes
                },
                child: Text('สุ่มรางวัลทั้งหมด 5 รางวัล'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LottoPrizeWidget extends StatelessWidget {
  final int prizeNumber;
  final String? winningNumber; // Pass winning number for display

  LottoPrizeWidget({
    required this.prizeNumber,
    required this.winningNumber,
  });

  int _getPrizeMoney(int prizeNumber) {
    switch (prizeNumber) {
      case 1:
        return 10000; // Prize 1: 10,000
      case 2:
        return 5000;  // Prize 2: 5,000
      case 3:
        return 2500;  // Prize 3: 2,500
      case 4:
        return 1000;  // Prize 4: 1,000
      case 5:
        return 500;   // Prize 5: 500
      default:
        return 0;     // Default prize money
    }
  }

  @override
  Widget build(BuildContext context) {
    final prizeMoney = _getPrizeMoney(prizeNumber);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'รางวัลที่ $prizeNumber',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  if (winningNumber != null)
                    Text(
                      'เลขที่สุ่มได้: $winningNumber\nเงินรางวัล: $prizeMoney',
                      style: TextStyle(color: Colors.yellow, fontSize: 14),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
