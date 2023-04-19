import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_todo/screens/welcome.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/realm/app_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';
import 'package:flutter_todo/screens/homepage.dart';
import 'package:flutter_todo/screens/plant_dashboard.dart';

class SignInForm extends StatefulWidget {
  const SignInForm({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late SMITrigger error;
  late SMITrigger success;
  late SMITrigger reset;
  late SMITrigger confetti;
  bool isShowLoading = false;
  bool isShowConfetti = false;

  // bool _isLogin = true;
  String? _errorMessage;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;


  @override
  void initState() {
    _emailController = TextEditingController()..addListener(clearError);
    _passwordController = TextEditingController()..addListener(clearError);
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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

  void singIn(BuildContext context, String email, String password) async {
    // confetti.fire();
    // clearError();
    setState(() {
      isShowConfetti = true;
      isShowLoading = true;
    });
    final appServices = Provider.of<AppServices>(context, listen: false);
    clearError();
    await appServices.logInUserEmailPassword(email, password);
    Future.delayed(
      const Duration(seconds: 1),
      () {
        if (_formKey.currentState!.validate()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Processing Credential'),
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
              Future.delayed(const Duration(seconds: 3), () {
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

  // void singUp(BuildContext context, String email, String password) {
  //   inspect(context);
  //   inspect(email);
  //   inspect(password);
  //   // confetti.fire();
  //   setState(() {
  //     isShowConfetti = true;
  //     isShowLoading = true;
  //   });
  //   Future.delayed(
  //     const Duration(seconds: 1),
  //         () {
  //       if (_formKey.currentState!.validate()) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: const Text('Processing Credential'),
  //             backgroundColor: Colors.green,
  //             shape: RoundedRectangleBorder(
  //               borderRadius:
  //               BorderRadius.circular(MediaQuery.of(context).size.width),
  //             ),
  //             behavior: SnackBarBehavior.floating,
  //           ),
  //         );
  //         success.fire();
  //         Future.delayed(
  //           const Duration(seconds: 2),
  //               () {
  //             setState(() {
  //               isShowLoading = false;
  //             });
  //             final appServices = Provider.of<AppServices>(context, listen: false);
  //             appServices.registerUserEmailPassword(email, password);
  //             confetti.fire();
  //             // Navigate & hide confetti
  //             Future.delayed(const Duration(seconds: 3), () {
  //               // Navigator.pop(context);
  //               Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                   //  Goes to homepage.dart
  //                   builder: (context) => const HomePage(),
  //                   // Goes to entry_point.dart
  //                   // builder: (context) => const EntryPoint(),
  //                   // Goes to Realm Default Login Page
  //                   // builder: (context) => LogIn(),
  //                 ),
  //               );
  //             });
  //           },
  //         );
  //       } else {
  //         error.fire();
  //         Future.delayed(
  //           const Duration(seconds: 2),
  //               () {
  //             setState(() {
  //               isShowLoading = false;
  //             });
  //             reset.fire();
  //           },
  //         );
  //       }
  //     },
  //   );
  // }

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
                  "Email",
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: TextFormField(
                    // onSaved: (value) =>
                    //     _emailController = value as TextEditingController,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) {
                      _emailController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid Email";
                      }
                      // if(value.contains('@')){
                      //   return "Error <Your Address>@<Service Address>.<Service Route>";
                      // }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email Here',
                      labelText: 'Email',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SvgPicture.asset("assets/icons/email.svg"),
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
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Try Password Again";
                      }
                      if (value.length < 8) {
                        return "Minimum 8 Characters required";
                      }

                      return null;
                    },
                    // onSaved: (value) =>
                    //     _passwordController = value as TextEditingController,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    onSaved: (value) {
                      _passwordController.text = value!;
                    },
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      hintText: 'Enter 8 Characters or Longer',
                      labelText: 'Password',
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
                        singIn(context, _emailController.text,
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
                      label: const Text("Sign In"),
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
