// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class TaxiFareUi extends StatefulWidget {
  const TaxiFareUi({super.key});

  @override
  State<TaxiFareUi> createState() => _TaxiFareUiState();
}

class _TaxiFareUiState extends State<TaxiFareUi> {
  final TextEditingController _distanceController = TextEditingController();
  final TextEditingController _trafficController = TextEditingController();

  String _fareValue = '0.00';

  void _calculateFare() {
    // 1. ตรวจสอบความว่างก่อนทำงาน หากช่องใดช่องหนึ่งว่างให้แสดง SnackBar แจ้งเตือนทันที
    if (_distanceController.text.isEmpty || _trafficController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.warning, color: Colors.white),
              SizedBox(width: 8),
              Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // 2. เมื่อกรอกครบแล้ว ค่อยดึงค่ามาคำนวณต่อตามปกติ
    double distance = double.tryParse(_distanceController.text) ?? 0.0;
    double trafficTime = double.tryParse(_trafficController.text) ?? 0.0;

    if (distance > 0) {
      double fare = 0.0;

      if (distance <= 1) {
        fare += 35.0;
      } else if (distance <= 10) {
        fare += 35.0 + (distance - 1) * 6.50;
      } else if (distance <= 20) {
        fare += 35.0 + (9 * 6.50) + (distance - 10) * 7.00;
      } else if (distance <= 40) {
        fare += 35.0 + (9 * 6.50) + (10 * 7.00) + (distance - 20) * 8.00;
      } else if (distance <= 60) {
        fare += 35.0 + (9 * 6.50) + (10 * 7.00) + (20 * 8.00) + (distance - 40) * 8.50;
      } else if (distance <= 80) {
        fare += 35.0 + (9 * 6.50) + (10 * 7.00) + (20 * 8.00) + (20 * 8.50) + (distance - 60) * 9.00;
      } else {
        fare += 35.0 + (9 * 6.50) + (10 * 7.00) + (20 * 8.00) + (20 * 8.50) + (20 * 9.00) + (distance - 80) * 10.50;
      }

      fare += trafficTime * 3.00;

      setState(() {
        _fareValue = fare.toStringAsFixed(2);
      });
    }
  }

  void _resetForm() {
    setState(() {
      _distanceController.clear();
      _trafficController.clear();
      _fareValue = '0.00';
    });
  }

  @override
  void dispose() {
    _distanceController.dispose();
    _trafficController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8FA),
      appBar: AppBar(
        title: Text(
          'Taxi Fare',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 24.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/taxi.png',
                  height: 180.0,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Center(
                child: Text(
                  'คำนวณค่าโดยสารแท็กซี่',
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      'ระยะทาง (กิโลเมตร)',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 24.0, 
                      height: 24.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: _distanceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'กรุณากรอกระยะทาง',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    Text(
                      'เวลารถติด (นาที)',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: 24.0, 
                      height: 24.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: _trafficController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'กรุณากรอกเวลารถติด',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 20.0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              ElevatedButton(
                onPressed: _calculateFare,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'คำนวณค่าโดยสาร',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(
                height: 15.0,
              ),
              ElevatedButton(
                onPressed: _resetForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'ยกเลิก',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF2CC),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      'ค่าโดยสารแท็กซี่',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      _fareValue,
                      style: TextStyle(
                        color: const Color.fromARGB(255, 253, 28, 11),
                        fontSize: 36.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 4.0,
                    ),
                    Text(
                      'บาท',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
