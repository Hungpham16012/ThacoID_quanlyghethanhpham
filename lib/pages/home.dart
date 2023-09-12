import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/blocs/user_bloc.dart';

import 'package:ghethanhpham_thaco/config/config.dart';
import 'package:ghethanhpham_thaco/pages/history/history.dart';
import 'package:ghethanhpham_thaco/pages/home/main.dart';
import 'package:ghethanhpham_thaco/pages/setting/setting.dart';
// import 'package:ghethanhpham_thaco/pages/settings/settings.dart';
import 'package:ghethanhpham_thaco/ultis/sign_out.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late UserBloc _userBloc;
  String _fullName = "No name";

  final tabs = [
    const MainPage(),
    const HistoryPage(),
    const SettingPage(),
  ];

  @override
  void initState() {
    super.initState();
    _userBloc = Provider.of<UserBloc>(context, listen: false);
    setState(() {
      _fullName = _userBloc.name!;
    });
  }

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
              _fullName,
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
