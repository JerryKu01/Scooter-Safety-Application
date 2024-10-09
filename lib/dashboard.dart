import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scooter_safety_application/MapPage.dart';
import 'package:scooter_safety_application/userPage.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int selectedPageIndex = 0;
  final List<Widget> pages = [
    MapPage(),
    UserPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TrackTrail"),
        elevation: 2,
      ),
      body: Center(child: pages[selectedPageIndex],),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedPageIndex,
        onDestinationSelected: (int index){
          setState(() {
            selectedPageIndex = index;
          });
        },
        elevation: 2,
        destinations: [
          NavigationDestination(
              icon: Icon(selectedPageIndex == 0 ? Icons.home : Icons.home_outlined),
              label: "Home"
          ),
          NavigationDestination(
              icon: Icon(selectedPageIndex == 2 ? Icons.grid_view_rounded : Icons.grid_view_outlined),
              label: "Me"
          )
        ],
      ),
    );
  }
}