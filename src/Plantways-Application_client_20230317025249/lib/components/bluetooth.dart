/*import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
//import 'package:flutter_todo/main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:provider/provider.dart';
import 'package:realm/realm.dart';

class Bluetooth extends StatefulWidget {
  const Bluetooth({
    Key? key,
  }) : super(key: key);
  @override
  State<Bluetooth> createState() => _BluetoothState();
}

class _BluetoothState extends State<Bluetooth> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  List<BluetoothDevice> devicesList = [];
  bool devicesDiscovered = false;
  //bool permGranted = false;
  int selectedTile = -1;
  late BluetoothCharacteristic characteristicToWrite;
  late BluetoothDevice connectedDevice;
  late StreamSubscription<List<ScanResult>> scanSubscription;

  late TextEditingController myController;
  late TextEditingController myController3;

  late String ssid;
  late String password;
  //late BluetoothDevice device;

  @override
  void initState() {
    myController = TextEditingController();
    myController3 = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    myController.dispose();
    myController3.dispose();
    devicesList.clear();
    devicesDiscovered = false;
    scanSubscription.cancel();
    super.dispose();
  }

  Future<void> startScan() async {
    var status = await Permission.bluetoothScan.request();
    var connectStatus = await Permission.bluetoothConnect.request();
    if (status.isGranted && connectStatus.isGranted) {
      flutterBlue.startScan(timeout: Duration(seconds: 3));

      scanSubscription = flutterBlue.scanResults.listen((results) {
        for (ScanResult result in results) {
          if (!devicesList.contains(result.device)) {
            setState(() {
              devicesList.add(result.device);
              devicesDiscovered = true;
            });
          }
        }
      });
      flutterBlue.stopScan();
    } else {
      print('Error scanning');
    }
  }

  Future<bool> connect(BluetoothDevice device) async {
    Future<bool> isConnected = Future.value(true);

    await device.connect().timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        isConnected = Future.value(false);
      },
    );
    // await device.connect();

    String serviceUUID;
    String characteristicUUID;
    if (await isConnected) {
      List<BluetoothService> services = await device.discoverServices();
      for (BluetoothService service in services) {
        print('Service UUID: ${service.uuid.toString()}');
        List<BluetoothCharacteristic> characteristics = service.characteristics;
        for (BluetoothCharacteristic characteristic in characteristics) {
          print('Characteristic UUID: ${characteristic.uuid.toString()}');
          try {
            if (characteristic.properties.read) {
              List<int> value = await characteristic.read();
              String stringValue = utf8.decode(value);
              print('Characteristic value: $stringValue');
              if (stringValue == 'WRITE_HERE') {
                serviceUUID = service.uuid.toString();
                characteristicUUID = characteristic.uuid.toString();
                characteristicToWrite = characteristic;
                print('Stored service UUID: $serviceUUID');
                print('Stored characteristic UUID: $characteristicUUID');
              }
            }
          } catch (e) {
            print('Failed to read characteristic');
          }
        }
      }
    }
    // isConnected = Future.value(true);

    return isConnected;
  }

  void showMessage(bool isConnected) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isConnected
          ? "Connected to device!"
          : "Could not connect to device!"),
      behavior: SnackBarBehavior.floating,
      backgroundColor: isConnected ? Colors.green : Colors.red,
    ));
  }

  Future<void> write(String ssid, String password) async {
    String data = '$ssid,$password';
    await characteristicToWrite.write(data.codeUnits);
  }

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context, listen: false);
    bool isConnected;
    return Scaffold(
        appBar: AppBar(
          title: Text('Bluetooth Devices'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        key: _formKey,
        body: Column(
          children: [
            Text('1) Start Bluetooth scan and connect to your device'),
            devicesDiscovered
                ? Container(
                    height: 300,
                    width: 600,
                    decoration: BoxDecoration(
                        border: Border.all(width: 5, color: Colors.black)),
                    child: ListView.builder(
                        itemCount: devicesList.length,
                        itemBuilder: (BuildContext context, int index) {
                          BluetoothDevice device = devicesList[index];
                          return ListTile(
                            title: Text(device.name),
                            subtitle: Text(device.id.toString()),
                            selected: index == selectedTile,
                            selectedTileColor: Colors.lightBlue,
                            onTap: () async {
                              setState(() {
                                selectedTile = index;
                                connectedDevice = device;
                                print(connectedDevice);
                              });
                              isConnected = await connect(device);
                              showMessage(isConnected);
                            },
                          );
                        }),
                  )
                : FloatingActionButton(
                    onPressed: startScan,
                    child: Text('Start Scan'),
                  ),
            const Text('2) Enter Wi-Fi SSID and password'),
            SizedBox(
              height: 25,
            ),
            TextField(
              controller: myController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter SSID',
              ),
            ),
            SizedBox(
              height: 25,
            ),
            TextField(
              controller: myController3,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter Password',
              ),
            ),
            SizedBox(
              height: 75,
            ),
            Consumer<RealmServices>(builder: (context, realmServices, child) {
              return ElevatedButton(
                  onPressed: () => save(realmServices, context), child: null);
            }),
            /*ElevatedButton(onPressed: (){
            setState(() {
              ssid = myController.text;
              password = myController3.text;
              myController.clear();
              myController3.clear();
            });
            print('Network SSID: $ssid');
            print('Network password: $password');
            write(ssid, password);

        },
        child: Text('Enter')
        )*/
          ],
        ));
  }

  void save(RealmServices realmServices, BuildContext context) {
    setState(() {
      ssid = myController.text;
      password = myController3.text;
      myController.clear();
      myController3.clear();
    });
    write(ssid, password);
    // realmServices.createUser
    //   (connectedDevice.name, connectedDevice.id.toString(),
    //     50, 70, "55%", "full_sunlight", "low", "priority_high");\

    Navigator.pop(context);
  }
}
*/