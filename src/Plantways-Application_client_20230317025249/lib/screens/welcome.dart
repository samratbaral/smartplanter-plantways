import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter_todo/components/animated_btn.dart';
import 'package:flutter_todo/components/sign_in_dialog.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  late RiveAnimationController _btnAnimationController;
  late RiveAnimationController _btnAnimationController2;

  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: true,
    );
    _btnAnimationController2 = OneShotAnimation(
      "active",
      autoplay: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            // left: 100,
            // width: MediaQuery.of(context).size.width,
            // height: MediaQuery.of(context).size.height,
            // bottom: 100,
            // height: 100,
            child: Image.asset(
              "assets/backgrounds/grass-border.jpg",
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: MediaQuery.of(context).size.width,
                  sigmaY: MediaQuery.of(context).size.height),
              child: const SizedBox(),
            ),
          ),
          const RiveAnimation.asset(
            "assets/RiveAssets/plantways.riv",
          ),
          Positioned.fill(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 16, sigmaY: 18),
                child: const SizedBox()),
          ),
          AnimatedPositioned(
            top: isShowSignInDialog ? -50 : 0,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            duration: const Duration(milliseconds: 260),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    SizedBox(
                      width: 460,
                      child: Column(
                        children: const [
                          Text(
                            "Plantways",
                            style: TextStyle(
                              fontSize: 60,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Poppins",
                              height: 1.3,
                            ),
                          ),
                          SizedBox(height: 1),
                          Text(
                            "Smart App thats connects to your Smart Planter.",
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    SizedBox(
                      width: 250,
                      child: Column(
                        children: const [
                          Text(
                            "Growth Takes Time.",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    SizedBox(
                      width: 250,
                      child: Column(
                        children: const [
                          Text(
                            "Don’t Skip Watering.",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    SizedBox(
                      width: 350,
                      child: Column(
                        children: const [
                          Text(
                            "Take Care of Your Plant.",
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    AnimatedBtn(
                      btnAnimationController: _btnAnimationController,
                      press: () {
                        _btnAnimationController.isActive = true;

                        Future.delayed(
                          const Duration(milliseconds: 800),
                          () {
                            setState(() {
                              isShowSignInDialog = true;
                            });
                            //goes to sign_in_dialog.dart
                            showCustomDialog(
                              context,
                              onValue: (_) {
                                setState(() {
                                  isShowSignInDialog = false;
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                    AnimatedBtn2(
                      btnAnimationController2: _btnAnimationController2,
                      press: () {
                        _btnAnimationController2.isActive = true;

                        Future.delayed(
                          const Duration(milliseconds: 800),
                          () {
                            setState(() {
                              isShowSignInDialog = true;
                            });
                            //goes to sign_in_dialog.dart
                            showCustomDialog2(
                              context,
                              onValue: (_) {
                                setState(() {
                                  isShowSignInDialog = false;
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                          "Complete setup to see the best result for your plant. Includes access to 15+ plants, 5+ facts about plant, 5 sensor data to make sure your plant is healthy."),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
