import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? randomValueCharacteristic;
  int randomValue = 0;

  @override
  void initState() {
    super.initState();
    requestPermissions();
    startScan();
  }

  // Request necessary Bluetooth permissions for Android 12+
  void requestPermissions() async {
    await Permission.bluetoothAdvertise.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
  }

  // Start scanning for BLE devices
  void startScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        if (r.device.name == 'Nano33IoT') {
          connectToDevice(r.device);
          flutterBlue.stopScan();
          break;
        }
      }
    });
  }

  // Connect to the BLE device
  void connectToDevice(BluetoothDevice device) async {
    await device.connect();
    setState(() {
      connectedDevice = device;
    });

    discoverServices();
  }

  // Discover BLE services and characteristics
  void discoverServices() async {
    if (connectedDevice == null) return;

    List<BluetoothService> services = await connectedDevice!.discoverServices();
    for (BluetoothService service in services) {
      if (service.uuid.toString() == "12345678-1234-5678-1234-56789abcdef0") {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid.toString() == "abcdef01-1234-5678-1234-56789abcdef0") {
            randomValueCharacteristic = characteristic;
            listenForRandomValues();
          }
        }
      }
    }
  }

  // Listen to BLE notifications for random values
  void listenForRandomValues() async {
    if (randomValueCharacteristic == null) return;

    await randomValueCharacteristic!.setNotifyValue(true);
    randomValueCharacteristic!.value.listen((value) {
      setState(() {
        randomValue = value[0];  // Assuming single byte random value
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Nano 33 IoT BLE Example'),
        ),
        body: Center(
          child: connectedDevice != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Connected to ${connectedDevice!.name}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Random Value: $randomValue',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              : Text(
                  'Scanning for devices...',
                  style: TextStyle(fontSize: 20),
                ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    connectedDevice?.disconnect();
    super.dispose();
  }
}
