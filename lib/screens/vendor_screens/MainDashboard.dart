import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leez/constants/colors.dart';
import 'package:leez/screens/user_screens/account.dart';
import 'package:leez/screens/vendor_screens/inbox.dart';
import 'package:leez/screens/vendor_screens/taskday2.dart';

import 'addlistingpage.dart';

class MainDashboard extends StatefulWidget {
  @override
  _MainDashboardState createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(), // Your existing screen (would redesign similarly)
    AddListingPage(),
    ChatLauncherScreen(),
    MenuScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: _pages[_currentIndex],
        bottomNavigationBar: _buildPremiumNavBar(),
      ),
    );
  }

  Widget _buildPremiumNavBar() {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.black.withOpacity(0.08), width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 0,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(0.4),
        selectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          letterSpacing: -0.2,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.home_outlined, size: 24),
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.home_filled, size: 24),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.add_circle_outline, size: 24),
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.add_circle, size: 24),
            ),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.person_outline, size: 24),
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.message, size: 24),
            ),
            label: "Inbox",
          ),
          BottomNavigationBarItem(
            icon: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.person_outline, size: 24),
            ),
            activeIcon: Container(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.person, size: 24),
            ),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
