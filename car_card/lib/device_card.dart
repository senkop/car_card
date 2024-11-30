import 'package:car_card/car_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Device Card Example'),
        ),
        body: Center(
          child: DeviceCard(
            device: Device(
              name: 'Device 1',
              lastRow: LastRow(
                ignition: true,
                status: 'moving',
                time: DateTime.now().millisecondsSinceEpoch,
              ),
            ),
            onTap: () {
              print('Device card tapped');
            },
          ),
        ),
      ),
    );
  }
}