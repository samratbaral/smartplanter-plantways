import 'package:flutter/material.dart';

import '../../model/plant.dart';
import '../components/plant_card.dart';
import '../components/bluetooth.dart';
import 'package:flutter_todo/components/add_planter_form.dart';


//HomePage => PlantPage
class PlantPage extends StatelessWidget {
  const PlantPage({super.key});

  @override
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
              // Padding(
              //   padding: const EdgeInsets.all(20),
              //   child: Text(
              //     "Recent Plants",
              //     style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              //         color: Colors.black, fontWeight: FontWeight.bold),
              //   ),
              // ),
              // ...recentPlants
              //     .map((plant) => Padding(
              //   padding: const EdgeInsets.only(
              //       left: 20, right: 20, bottom: 20),
              //   child: SecondaryPlantCard(
              //     name: plant.name,
              //     description: plant.description,
              //     iconsSrc: plant.iconSrc,
              //     colorl: plant.color,
              //   ),
              // ))
              //     .toList(),
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
