import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:progress_soft/data/app_constant.dart';
import 'package:progress_soft/view/home/home_screen.dart';
import 'package:progress_soft/view/profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    ProfileScreen(
      mobileNumber: getStorage.read('phoneNumber') ?? '',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'home'.tr,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person),
            label: 'profile'.tr,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: appConstant.primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
