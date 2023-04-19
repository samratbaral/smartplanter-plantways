import 'package:flutter/material.dart';
import 'package:flutter_todo/components/todo_item.dart';
import 'package:flutter_todo/components/widgets.dart';
import 'package:flutter_todo/realm/schemas.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:realm/realm.dart';

import 'dart:math';
import 'package:rive/rive.dart';
import 'package:flutter_todo/screens/widget_tree.dart';
import 'package:flutter_todo/theme.dart';
import '../../model/menu.dart';
import 'package:flutter_todo/components/menu_btn.dart';
import 'package:flutter_todo/components/side_bar.dart';

class TodoList extends StatefulWidget {
  const TodoList({Key? key}) : super(key: key);

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> with SingleTickerProviderStateMixin {

  bool isSideBarOpen = false;

  Menu selectedBottonNav = bottomNavItems.first;
  Menu selectedSideMenu = sidebarMenus.first;

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
        body:
        Stack(
      children: [
        Column(
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
            // styledBox(
            //   context,
            //   isHeader: true,
            //   child: Row(
            //     children: [
            //       const Expanded(
            //         child: Text("All Plants", textAlign: TextAlign.right),
            //       ),
            //       Switch(
            //         value: realmServices.showAll,
            //         onChanged: (value) async {
            //           if (realmServices.offlineModeOn) {
            //             infoMessageSnackBar(context,
            //                     "Switching subscriptions does not affect Realm data when the sync is offline.")
            //                 .show(context);
            //           }
            //           await realmServices.switchSubscription(value);
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            // Expanded(
            //   child: Padding(
            //     padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            //     child: StreamBuilder<RealmResultsChanges<Item>>(
            //       stream: realmServices.realm
            //           .query<Item>("TRUEPREDICATE SORT(_id ASC)")
            //           .changes,
            //       builder: (context, snapshot) {
            //         final data = snapshot.data;
            //
            //         if (data == null) return waitingIndicator();
            //
            //         final results = data.results;
            //         return ListView.builder(
            //           shrinkWrap: true,
            //           itemCount: results.realm.isClosed ? 0 : results.length,
            //           itemBuilder: (context, index) => results[index].isValid
            //               ? TodoItem(results[index])
            //               : Container(),
            //         );
            //       },
            //     ),
            //   ),
            // ),
            // styledBox(
            //   context,
            //   child: Container(
            //       margin: const EdgeInsets.fromLTRB(15, 0, 40, 15),
            //       child: const Text(
            //         "Log in with the same account on another device to see your list sync in realm-time.",
            //         textAlign: TextAlign.left,
            //       )),
            // ),
          ],
        ),
        // realmServices.isWaiting ? waitingIndicator() : Container(),
      ],
    ),
    );
  }
}
