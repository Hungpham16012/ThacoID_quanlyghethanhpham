import 'package:flutter/material.dart';

import 'package:linhkiennhua_thaco/config/config.dart';
import 'package:linhkiennhua_thaco/pages/history/history.dart';
import 'package:linhkiennhua_thaco/pages/home/main.dart';
import 'package:linhkiennhua_thaco/pages/setting/setting.dart';
import 'package:linhkiennhua_thaco/ultis/sign_out.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final tabs = [
    const MainPage(),
    const HistoryPage(),
    const SettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Image(image: AssetImage(Config.logoId), width: 140),
        actions: [
          Container(
            margin: const EdgeInsets.only(top: 21),
            child: Text(
              "Full Name",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 10),
          InkWell(
            onTap: () => openLogoutDialog(context),
            child: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: tabs[_currentIndex],
      // BottomNavigationBar
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timelapse),
            label: 'Lịch sử',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Cấu hình',
          )
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
