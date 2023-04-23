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
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_todo/components/bluetooth_plus.dart';
import 'bluetooth_widget.dart';

// Bluetooth Blue
// import 'package:permission_handler/permission_handler.dart';
// import 'dart:convert';
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

  // Bluetooth
  // int selectedTile = -1;
  // FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  // List<BluetoothDevice> devicesList = [];
  // bool devicesDiscovered = false;
  // late StreamSubscription<List<ScanResult>> scanSubscription;
  // late String ssid;
  // late String password;

  @override
  void initState() {
    _pot_nameController = TextEditingController()..addListener(clearError);
    _pot_plantnameController = TextEditingController()..addListener(clearError);
    _wifiController = TextEditingController()..addListener(clearError);
    _passwordController = TextEditingController()..addListener(clearError);
    _nameBLEController = TextEditingController()..addListener(clearError);
    super.initState();
  }

  @override
  void dispose() {
    _pot_nameController.dispose();
    _pot_plantnameController.dispose();
    _nameBLEController.dispose();

    //bluetooth
    // _wifiController.dispose();
    // _passwordController.dispose();
    //
    // devicesList.clear();
    // devicesDiscovered = false;
    // scanSubscription.cancel();
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
      String wifi, String password) async {
    // confetti.fire();
    // clearError();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });

    List<String> potConnection = [wifi, password];
    // potConnection.add(wifi);
    // potConnection.add(password);
    const potMac = "10101010100101";
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
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //form fields
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
                            _passwordController.text);
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
                        CupertinoIcons.arrow_right,
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
