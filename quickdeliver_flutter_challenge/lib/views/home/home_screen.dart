import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:quickdeliver_flutter_challenge/views/home/package_track.dart';
import 'package:quickdeliver_flutter_challenge/views/home/user_profile.dart';

import '../../core/app_colors.dart';
import 'home_ui.dart';

class AppHome extends StatefulWidget {
  const AppHome({super.key});

  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _selectedIndex = 0;

  final List _pages = [HomePage(), PackagesScreen(), UserProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: NavigationBar(
          backgroundColor: AppColors.background,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home_copy), label: 'Home'),
            NavigationDestination(
                icon: Icon(Iconsax.box_search_copy), label: 'Packages'),
            NavigationDestination(
                icon: Icon(Iconsax.user_copy), label: 'Profile'),
          ],
        ),
        backgroundColor: AppColors.background,
        body: _pages[_selectedIndex]);
  }
}
