// import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_todo/components/widgets.dart';
import 'package:flutter_todo/components/plant_userdata.dart';
import 'package:rive/rive.dart';
import 'package:flutter_todo/screens/widget_tree.dart';
import 'package:flutter_todo/theme.dart';
import '../../model/menu.dart';
// import 'package:flutter_todo/components/animated_btn.dart';
import 'package:flutter_todo/components/menu_btn.dart';
import 'package:flutter_todo/components/side_bar.dart';
import 'package:flutter_todo/model/plant.dart';
// import 'package:flutter_todo/components/sign_in_dialog.dart';

import 'package:flutter_todo/realm/schemas.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:realm/realm.dart';

class PlantDashboard extends StatefulWidget {
  const PlantDashboard({super.key});

  @override
  State<PlantDashboard> createState() => _PlantDashboardState();
}

class _PlantDashboardState extends State<PlantDashboard>
    with SingleTickerProviderStateMixin {

  bool isSideBarOpen = false;
  late RiveAnimationController _btnAnimationController3;
  // bool isShowAddPlant = false
  Menu selectedBottonNav = bottomNavItems.first;
  Menu selectedSideMenu = sidebarMenus.first;
  
  //late RealmResults<PlantUserData> results;
  late SMIBool isMenuOpenInput;

  void updateSelectedBtmNav(Menu menu) {
    if (selectedBottonNav != menu) {
      setState(() {
        selectedBottonNav = menu;
      });
    }
  }

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    _btnAnimationController3 = OneShotAnimation(
      "active",
      autoplay: true,
    );
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..addListener(
        () {
          setState(() {});
        },
      );
    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.fastOutSlowIn));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor2,
      body: Stack(
        children: [
          AnimatedPositioned(
            width: 288,
            height: MediaQuery.of(context).size.height,
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 0 : -288,
            top: 0,
            child: const SideBar(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                  1 * animation.value - 30 * (animation.value) * pi / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: const ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(24),
                  ),
                  // goes to home_screen.dart
                  child: WidgetTree(),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            left: isSideBarOpen ? 220 : 0,
            top: 16,
            child: MenuBtn(
              press: () {
                isMenuOpenInput.value = !isMenuOpenInput.value;

                if (_animationController.value == 0) {
                  _animationController.forward();
                } else {
                  _animationController.reverse();
                }

                setState(
                  () {
                    isSideBarOpen = !isSideBarOpen;
                  },
                );
              },
              riveOnInit: (artboard) {
                final controller = StateMachineController.fromArtboard(
                    artboard, "State Machine");

                artboard.addController(controller!);

                isMenuOpenInput =
                    controller.findInput<bool>("isOpen") as SMIBool;
                isMenuOpenInput.value = true;
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 220, 16, 220),
              child: StreamBuilder<RealmResultsChanges<PlantUserData>>(
                stream: realmServices.realm
                    .query<PlantUserData>("TRUEPREDICATE SORT(_id ASC)")
                    .changes,
                builder: (context, snapshot) {
                  final data = snapshot.data;

                  if (data == null) return waitingIndicator();

                  final results = data.results;
                 
                  return ListView.builder(
                    shrinkWrap: false,
                    itemCount: results.realm.isClosed ? 0 : results.length,
                    itemBuilder: (context, index) => results[index].isValid
                        ? TodoItem(results[index])
                        : Container(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
