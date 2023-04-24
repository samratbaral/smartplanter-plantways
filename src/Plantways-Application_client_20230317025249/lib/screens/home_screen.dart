import 'package:flutter/material.dart';
import 'package:flutter_todo/components/bluetooth_plus.dart';
import 'dart:ui';
import '../../model/plant.dart';
import '../components/plant_card.dart';
import 'package:rive/rive.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/components/animated_btn.dart';
import 'package:flutter_todo/components/add_planter_dialog.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:flutter_todo/components/app_bar.dart';

import 'package:flutter_todo/components/plant_list.dart';
import 'package:flutter_todo/components/widgets.dart';
import 'package:realm/realm.dart';
import '../components/bluetooth.dart';
import 'package:flutter_todo/components/add_planter_form.dart';

//HomePage => PlantPage
class PlantPage extends StatefulWidget {
  const PlantPage({Key? key}) : super(key: key);

  @override
  State<PlantPage> createState() => _PlantPageState();
}

class _PlantPageState extends State<PlantPage> {
  late RiveAnimationController _btnAnimationController3;
  bool isShowSignInDialog = false;

  @override
  void initState() {
    _btnAnimationController3 = OneShotAnimation(
      "active",
      autoplay: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final realmServices = Provider.of<RealmServices>(context);
    if (Provider.of<RealmServices?>(context, listen: false) == null) {
      return Container();
    } else {
      return Scaffold(
        appBar: TodoAppBar(),
        body: Stack(
          children: [
            Positioned(
              width: MediaQuery.of(context).size.width * 1.7,
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
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Text(
                              "Plants",
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium!
                                  .copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                              //SelectCatagory(),
                            ),
                          ),
                          AnimatedBtn3(
                            btnAnimationController3: _btnAnimationController3,
                            press: () {
                              _btnAnimationController3.isActive = true;
                              Future.delayed(
                                const Duration(milliseconds: 800),
                                () {
                                  setState(() {
                                    isShowSignInDialog = true;
                                  });
                                  //goes to sign_in_dialog.dart
                                  showCustomDialog3(
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
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child:
                                Text("Click Add Planter to Setup New Plant."),
                          ),
                          Container(
                              height: 575,
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    //changed this from row to column
                                    // children: const [
                                    //   PlantList(),
                                    // ],

                                    // Plant List
                                    children: plants
                                        .map(
                                          (plant) => Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10,
                                                bottom: 10,
                                                right: 10),
                                            child: PlantCard(
                                              plantName: plant.plantName,
                                              potName: plant.potName,
                                              potMac: plant.potMac,
                                              potConnection:
                                                  plant.potConnection,
                                              potSensorData:
                                                  plant.potSensorData,
                                              name: plant.name,
                                              description: plant.description,
                                              iconSrc: plant.iconSrc,
                                              color: plant.color,
                                              temperature:
                                                  plant.temperature.toString(),
                                              humidity:
                                                  plant.humidity.toString(),
                                              light: plant.light,
                                              water: plant.water,
                                              soil: plant.soil,
                                            ),
                                          ),
                                          // child: PlantPage(),
                                        )
                                        .toList(),
                                    // Plant List
                                  )))
                        ],
                      ),
                    )

                    // realmServices.isWaiting ? waitingIndicator() : Container(),
                    ),
              ),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton.small(
        //   onPressed: () {
        //     // Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothPage()));
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //             builder: (context) => const FlutterBlueApp()));
        //   },
        //   backgroundColor: Colors.black,
        //   child: const Icon(Icons.search),
        // ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      );
    }
  }
}

/*
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(55),
                child: Text(
                  "Plants",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  //SelectCatagory(),
                ),
              ),
              SingleChildScrollView(
                //scrollDirection: Axis.horizontal,
                child: Column(
                  //changed this from row to column
                  children: plants
                      .map(
                        (plant) => Padding(
                          padding: const EdgeInsets.only(left: 25, bottom: 10),
                          child: PlantCard(
                            name: plant.name,
                            description: plant.description,
                            iconSrc: plant.iconSrc,
                            color: plant.color,
                            temperature: plant.temperature.toString(),
                            humidity: plant.humidity.toString(),
                            light: plant.light,
                            water: plant.water,
                          ),
                        ),
                        // child: PlantPage(),
                      )
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "Recent Plants",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
              ...recentPlants
                  .map((plant) => Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, bottom: 20),
                child: SecondaryPlantCard(
                  name: plant.name,
                  description: plant.description,
                  iconsSrc: plant.iconSrc,
                  colorl: plant.color,
                ),
              ))
                  .toList(),
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.large(onPressed: (){
        // Navigator.push(context, MaterialPageRoute(builder: (context) => BluetoothPage()));
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPlanterForm()));
      },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
*/
