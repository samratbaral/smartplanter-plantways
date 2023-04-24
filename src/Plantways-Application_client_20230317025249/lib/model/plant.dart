import 'package:flutter/material.dart';
import 'package:flutter_todo/components/todo_item.dart';
import 'package:flutter_todo/components/widgets.dart';
import 'package:flutter_todo/realm/schemas.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todo/realm/realm_services.dart';
import 'package:realm/realm.dart';

class Plant {
  // late Realm realm;
  final String name, description, iconSrc;
  final Color color;
  final int temperature, humidity;
  final String light, water, level, soil;
  final String plantName, potName, potMac;
  final List<String> potConnection;
  final Set<String> potSensorData;

  Plant({
    required this.plantName,
    required this.potName,
    required this.potMac,
    required this.potConnection,
    required this.potSensorData,
    required this.name,
    required this.description,
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.water,
    required this.level,
    required this.soil,
    this.iconSrc = "assets/icons/code.svg", // change into plant icon
    this.color = const Color.fromRGBO(
        41, 171, 135, 1.0), //Jungle Green #29ab87 | rgb(41,171,135)
  });
}

final List<Plant> plants = [];




//
// final List<Plant> plants = [
//   Plant(
//     name: "Sunflower",
//     description: "Sunflowers are native primarily to North and South America,"
//         "and some species are cultivated as ornamentals for their"
//         "spectacular size and flower heads and for their edible seeds.",
//     iconSrc: "assets/icons/flower.svg",
//     color: const Color.fromRGBO(41, 175, 135, 0.88),
//     temperature: 44,
//     humidity: 40,
//     light: "10 %",
//     water: "100 %",
//     level: "Low",
//   ),
//   Plant(
//     name: "Jasmin",
//     description:
//         "The plants are native to tropical and to some temperate areas "
//         "of the Old World. Several are cultivated as ornamentals.",
//     iconSrc: "assets/icons/flower.svg",
//     color: const Color.fromRGBO(41, 175, 55, 0.88),
//     temperature: 35,
//     humidity: 65,
//     light: "10 %",
//     water: "100 %",
//     level: "Good",
//   ),
//   Plant(
//     name: "Lily",
//     description:
//         "The plants are native to tropical and to some temperate areas "
//         "of the Old World. Several are cultivated as ornamentals.",
//     color: const Color.fromRGBO(41, 175, 10, 0.88),
//     iconSrc: "assets/icons/leaf.svg",
//     temperature: 35,
//     humidity: 55,
//     light: "10 %",
//     water: "100 %",
//     level: "Low",
//   ),
//   Plant(
//     name: "Tulip",
//     description:
//         "The plants are native to tropical and to some temperate areas "
//         "of the Old World. Several are cultivated as ornamentals.",
//     color: const Color.fromRGBO(41, 175, 10, 0.88),
//     iconSrc: "assets/icons/leaf.svg",
//     temperature: 35,
//     humidity: 40,
//     light: "10 %",
//     water: "100 %",
//     level: "Good",
//   ),
// ];

// final List<Plant> recentPlants = [
//   Plant(
//       name: "Sunflower",
//       description: "Hi, Sunflower",
//       iconSrc: "assets/icons/flower.svg"),
//   Plant(
//       name: "Lily", description: "Hi, Lily", iconSrc: "assets/icons/leaf.svg"),
//   Plant(
//       name: "Rose", description: "Hi, Rose", iconSrc: "assets/icons/flower.svg")
// ];
