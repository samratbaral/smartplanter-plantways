import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/components/bluetooth.dart';

import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:flutter_todo/screens/home_screen.dart';

// Bluetooth Blue +
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_todo/components/bluetooth_plus.dart';
import 'bluetooth_widget.dart';

// Bluetooth Blue
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
// import 'dart:io';
// import 'dart:math';

class AddPlanterForm extends StatefulWidget {
  const AddPlanterForm({
    Key? key,
  }) : super(key: key);

  @override
  State<AddPlanterForm> createState() => _AddPlanterFormState();
}

class _AddPlanterFormState extends State<AddPlanterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;
  late SMITrigger confetti;
  bool isShowLoading = false;
  bool isShowConfetti = false;
  String? _errorMessage;
  late TextEditingController _pot_nameController;
  late TextEditingController _pot_plantnameController;
  late TextEditingController _wifiController;
  late TextEditingController _passwordController;
  late TextEditingController _nameBLEController;
  late TextEditingController _macBLEController;

  // Bluetooth
  int selectedTile = -1;
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<BluetoothDevice> devicesList = [];
  bool devicesDiscovered = false;
  late BluetoothCharacteristic characteristicToWrite;
  late BluetoothDevice connectedDevice;
  late String macAddress;
  late String deviceName;
  late StreamSubscription<List<ScanResult>> scanSubscription;

  @override
  void initState() {
    _pot_nameController = TextEditingController()..addListener(clearError);
    _pot_plantnameController = TextEditingController()..addListener(clearError);
    _wifiController = TextEditingController()..addListener(clearError);
    _passwordController = TextEditingController()..addListener(clearError);
    _nameBLEController = TextEditingController()..addListener(clearError);
    _macBLEController = TextEditingController()..addListener(clearError);
    super.initState();
  }

  @override
  void dispose() {
    _pot_nameController.dispose();
    _pot_plantnameController.dispose();
    _wifiController.dispose();
    _passwordController.dispose();
    _nameBLEController.dispose();
    _macBLEController.dispose();

    //bluetooth
    // _wifiController.dispose();
    // _passwordController.dispose();
    devicesList.clear();
    devicesDiscovered = false;
    scanSubscription.cancel();
    super.dispose();
  }

  void _onCheckRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, 'State Machine 1');

    artboard.addController(controller!);
    error = controller.findInput<bool>('Error') as SMITrigger;
    success = controller.findInput<bool>('Check') as SMITrigger;
    reset = controller.findInput<bool>('Reset') as SMITrigger;
  }

  void _onConfettiRiveInit(Artboard artboard) {
    StateMachineController? controller =
        StateMachineController.fromArtboard(artboard, "State Machine 1");
    artboard.addController(controller!);

    confetti = controller.findInput<bool>("Trigger explosion") as SMITrigger;
  }

  void addInPlanter(BuildContext context, String plantName, String potName,
      String wifi, String password, String id, String name) async {
    // confetti.fire();
    // clearError();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });

    List<String> potConnection = [name,"YOUTHOUGHT", "NOWIFIHERE"];
    // potConnection.add(wifi);
    // potConnection.add(password);
    String potMac = id;
    const potSensor = {
      "Low Humidity",
      "Low Light",
      "Dry Soil",
      "Low Level",
      "Good Temperature"
    };
    final realmServices = Provider.of<RealmServices>(context, listen: false);
    clearError();
    await realmServices.createItem(
        plantName, false, potName, potMac, potSensor, potConnection);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Connect New Smart Planter'),
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(MediaQuery.of(context).size.width),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );

          success.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false;
              });
              confetti.fire();
              // Navigate & hide confetti
              Future.delayed(const Duration(seconds: 1), () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //  Goes to homepage.dart
                    builder: (context) => const PlantPage(),
                  ),
                );
              });
            },
          );
        } else {
          error.fire();
          Future.delayed(
            const Duration(seconds: 2),
            () {
              setState(() {
                isShowLoading = false;
              });
              reset.fire();
              Future.delayed(const Duration(seconds: 3), () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    //  Goes to welcome.dart
                    builder: (context) => const PlantPage(),
                  ),
                );
              });
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isConnected;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    '1) Start Bluetooth scan and connect to your device'),
                devicesDiscovered
                    ? Container(
                        height: 300,
                        width: 300,
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
                                    macAddress = connectedDevice.id.toString();
                                    deviceName = connectedDevice.name;
                                    print("MAC ADDRESS: $macAddress");
                                  });
                                  isConnected = await connect(device);
                                  showMessage(isConnected);
                                  // _nameBLEController = connectedDevice as TextEditingController;
                                  // _macBLEController = connectedDevice.id.toString() as TextEditingController;
                                },
                              );
                            }),
                      )
                    : FloatingActionButton(
                        onPressed: startScan,
                        child: const Text('Start Scan'),
                      ),
                //form fields
                // Padding(
                //   padding: const EdgeInsets.only(top: 8, bottom: 8),
                //   child: TextFormField(
                //     controller: _nameBLEController,
                //     onSaved: (connectedDevice) {
                //       _nameBLEController.text = connectedDevice!;
                //     },
                //     textInputAction: TextInputAction.done,
                //   ),
                // ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 8, bottom: 8),
                //   child: TextFormField(
                //     controller: _macBLEController,
                //     onSaved: (connectedDevice) {
                //       _macBLEController.text = connectedDevice!;
                //     },
                //     textInputAction: TextInputAction.done,
                //   ),
                // ),
                const Text(
                  "Pot Name",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    // onSaved: (value) =>
                    //     _emailController = value as TextEditingController,
                    controller: _pot_nameController,
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      _pot_nameController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid Pot Name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your Pot Name',
                      labelText: 'Pot Name',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/email.svg"),
                      ),
                    ),
                    maxLength: 20,
                  ),
                ),
                const Text(
                  "Plant Name",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    controller: _pot_plantnameController,
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      _pot_plantnameController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid Plant Name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your Plant Name',
                      labelText: 'Plant Name',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/password.svg"),
                      ),
                    ),
                    maxLength: 20,
                  ),
                ),
                const Text(
                  "Wifi",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    controller: _wifiController,
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      _wifiController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid WiFi Name";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your WiFi',
                      labelText: 'WiFi',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/password.svg"),
                      ),
                    ),
                    maxLength: 20,
                  ),
                ),
                const Text(
                  "Password",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      _passwordController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid WiFi Password";
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your WiFi Password',
                      labelText: 'Password',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/password.svg"),
                      ),
                    ),
                    maxLength: 20,
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        addInPlanter(
                          context,
                          _pot_nameController.text,
                          _pot_plantnameController.text,
                          _wifiController.text,
                          _passwordController.text,
                          macAddress.toLowerCase(),
                          deviceName
                          // connectedDevice.name, connectedDevice.id.toString(),
                        );
                        write(/*macAddress,*/ _wifiController.text, _passwordController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(41, 171, 135, 30),
                        minimumSize: const Size(double.infinity, 56),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                          ),
                        ),
                      ),
                      icon: const Icon(
                        CupertinoIcons.arrow_down_square_fill,
                        color: Color.fromRGBO(0, 102, 0, 90),
                      ),
                      // Sign In Name
                      label: const Text("Add Planter Pot"),
                      // Text(_isLogin ? 'Sign In' : 'Sign Up'),
                    )),
              ],
            ),
          ),
        ),
        isShowLoading
            ? CustomPositioned(
                child: RiveAnimation.asset(
                  'assets/RiveAssets/check.riv',
                  fit: BoxFit.cover,
                  onInit: _onCheckRiveInit,
                ),
              )
            : const SizedBox(),
        isShowConfetti
            ? CustomPositioned(
                scale: 6,
                child: RiveAnimation.asset(
                  "assets/RiveAssets/confetti.riv",
                  onInit: _onConfettiRiveInit,
                  fit: BoxFit.cover,
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Future<void> startScan() async {
    var status = await Permission.bluetoothScan.request();
    var connectStatus = await Permission.bluetoothConnect.request();
    if (status.isGranted && connectStatus.isGranted) {
      flutterBlue.startScan(timeout: const Duration(seconds: 3));

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

  Future<void> write(/*String mac,*/ String ssid, String password) async {
    String data = '$ssid,$password';
    await characteristicToWrite.write(data.codeUnits);
  }

  void clearError() {
    if (_errorMessage != null) {
      setState(() {
        // Reset error message when user starts typing
        _errorMessage = null;
      });
    }
  }
}

class CustomPositioned extends StatelessWidget {
  const CustomPositioned({super.key, this.scale = 1, required this.child});

  final double scale;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 100,
            width: 100,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
