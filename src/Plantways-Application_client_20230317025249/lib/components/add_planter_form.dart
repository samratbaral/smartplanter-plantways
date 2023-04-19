import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

import 'package:flutter_todo/screens/welcome.dart';
import 'package:flutter_todo/realm/app_services.dart';
import 'package:flutter_todo/components/widgets.dart';
import 'package:flutter_todo/screens/plant_dashboard.dart';

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

  // bool _isLogin = true;
  String? _errorMessage;

  late TextEditingController _pot_nameController;
  late TextEditingController _pot_plantnameController;
  late TextEditingController _pot_mac_adrressController;
  late TextEditingController _humidityController;
  late TextEditingController _temperatureController;
  late TextEditingController _soilMoistureController;
  late TextEditingController _lightIntensityController;
  late TextEditingController _waterTankLevelController;
  late TextEditingController _levelSensorController;

  @override
  void initState() {
    _pot_nameController = TextEditingController()..addListener(clearError);
    _pot_plantnameController = TextEditingController()..addListener(clearError);
    _pot_mac_adrressController = TextEditingController()
      ..addListener(clearError);
    _humidityController = TextEditingController()..addListener(clearError);
    _temperatureController = TextEditingController()..addListener(clearError);
    _soilMoistureController = TextEditingController()..addListener(clearError);
    _lightIntensityController = TextEditingController()
      ..addListener(clearError);
    _waterTankLevelController = TextEditingController()
      ..addListener(clearError);
    _levelSensorController = TextEditingController()..addListener(clearError);

    super.initState();
  }

  @override
  void dispose() {
    _pot_nameController.dispose();
    _pot_plantnameController.dispose();
    _pot_mac_adrressController.dispose();
    _humidityController.dispose();
    _temperatureController.dispose();
    _soilMoistureController.dispose();
    _lightIntensityController.dispose();
    _waterTankLevelController.dispose();
    _levelSensorController.dispose();
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

  void AddInPlanter(
      BuildContext context,
      String pot_name,
      String pot_plantname,
      String pot_mac_adrress,
      int humidity,
      int temperature,
      String soilMoisture,
      String lightIntensity,
      String waterTankLevel,
      String levelSensor) async {
    // confetti.fire();
    // clearError();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    // final appServices = Provider.of<AppServices>(context, listen: false);
    // clearError();
    // await appServices.logInUserEmailPassword(email, password);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Adding New Planter and Plant'),
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
                    builder: (context) => const PlantDashboard(),
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
                    builder: (context) => const WelcomePage(),
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
                  "Planter Pot",
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
                      // if(value.contains('@')){
                      //   return "Error <Your Address>@<Service Address>.<Service Route>";
                      // }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your Pot Name',
                      labelText: 'Planter Pot',
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
                    // onSaved: (value) =>
                    //     _emailController = value as TextEditingController,
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
                      // if(value.contains('@')){
                      //   return "Error <Your Address>@<Service Address>.<Service Route>";
                      // }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your Plant Name',
                      labelText: 'Plant Name',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/email.svg"),
                      ),
                    ),
                    maxLength: 20,
                  ),
                ),
                const Text(
                  "Planter Mac Address",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    // onSaved: (value) =>
                    //     _emailController = value as TextEditingController,
                    controller: _pot_mac_adrressController,
                    keyboardType: TextInputType.name,
                    onSaved: (value) {
                      _pot_mac_adrressController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid Mac Address";
                      }
                      // if(value.contains('@')){
                      //   return "Error <Your Address>@<Service Address>.<Service Route>";
                      // }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your Planter Mac Address',
                      labelText: 'Planter Mac Address',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/email.svg"),
                      ),
                    ),
                    maxLength: 20,
                  ),
                ),
                const Text(
                  "Humidity",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    // onSaved: (value) =>
                    //     _emailController = value as TextEditingController,
                    controller: _humidityController,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _humidityController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid Humidity";
                      }
                      // if(value.contains('@')){
                      //   return "Error <Your Address>@<Service Address>.<Service Route>";
                      // }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Humidity',
                      labelText: 'Humidity',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/email.svg"),
                      ),
                    ),
                    maxLength: 20,
                  ),
                ),
                const Text(
                  "Temperature",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    // onSaved: (value) =>
                    //     _emailController = value as TextEditingController,
                    controller: _temperatureController,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _temperatureController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid Temperature";
                      }
                      // if(value.contains('@')){
                      //   return "Error <Your Address>@<Service Address>.<Service Route>";
                      // }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Temperature',
                      labelText: 'Temperature',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/email.svg"),
                      ),
                    ),
                    maxLength: 20,
                  ),
                ),
                const Text(
                  "Soil Moisture",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid Soil Moisture";
                      }
                      if (value.length < 8) {
                        return "Minimum 8 Characters required";
                      }

                      return null;
                    },
                    // onSaved: (value) =>
                    //     _passwordController = value as TextEditingController,
                    controller: _soilMoistureController,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _soilMoistureController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Enter Soil Moisture',
                      labelText: 'Soil Moisture',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/password.svg"),
                      ),
                    ),
                    maxLength: 30,
                  ),
                ),
                const Text(
                  "Light",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid Light";
                      }
                      if (value.length < 8) {
                        return "Minimum 8 Characters required";
                      }

                      return null;
                    },
                    // onSaved: (value) =>
                    //     _passwordController = value as TextEditingController,
                    controller: _lightIntensityController,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _lightIntensityController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Enter Light',
                      labelText: 'Light',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/password.svg"),
                      ),
                    ),
                    maxLength: 30,
                  ),
                ),

                const Text(
                  "Water Level",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid Water Level";
                      }
                      if (value.length < 8) {
                        return "Minimum 8 Characters required";
                      }

                      return null;
                    },
                    // onSaved: (value) =>
                    //     _passwordController = value as TextEditingController,
                    controller: _waterTankLevelController,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _waterTankLevelController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Enter Water Level',
                      labelText: 'Water Level',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/password.svg"),
                      ),
                    ),
                    maxLength: 30,
                  ),
                ),

                const Text(
                  "Level Height",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid Height Again";
                      }
                      if (value.length < 8) {
                        return "Minimum 8 Characters required";
                      }
                      return null;
                    },
                    // onSaved: (value) =>
                    //     _passwordController = value as TextEditingController,
                    controller: _levelSensorController,
                    keyboardType: TextInputType.number,
                    onSaved: (value) {
                      _levelSensorController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Enter Level Height',
                      labelText: 'Level Height',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/password.svg"),
                      ),
                    ),
                    maxLength: 30,
                  ),
                ),

                Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: ElevatedButton.icon(
                      // onPressed: () {
                      //   //Goes to sinIn function
                      //   singIn(context);
                      // },
                      onPressed: () {
                        //BuildContext context, String pot_name, String pot_plantname, String pot_mac_adrress, int humidity, int temperature, String soilMoisture, String lightIntensity, String waterTankLevel, String levelSensor
                        AddInPlanter(
                            context,
                            _pot_nameController.text,
                            _pot_plantnameController.text,
                            _pot_mac_adrressController.text,
                            _humidityController as int,
                            _temperatureController as int,
                            _soilMoistureController.text,
                            _lightIntensityController.text,
                            _waterTankLevelController.text,
                            _levelSensorController.text);
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
