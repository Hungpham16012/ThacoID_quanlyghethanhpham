import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:ghethanhpham_thaco/blocs/user_bloc.dart';
import 'package:ghethanhpham_thaco/config/config.dart';
import 'package:ghethanhpham_thaco/pages/history/history.dart';
import 'package:ghethanhpham_thaco/pages/home/main.dart';
import 'package:ghethanhpham_thaco/pages/setting/setting.dart';
import 'package:ghethanhpham_thaco/ultis/sign_out.dart';
import 'package:ghethanhpham_thaco/widgets/menu_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, featureName}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late UserBloc _userBloc;
  String _fullName = "No name";

  final pages = [
    const MainPage(),
    const HistoryPage(),
    const SettingPage(),
  ];

  // GlobalKey for managing Navigator
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

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
        title: const Image(
          image: AssetImage(Config.logoId),
          width: 140,
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
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
      drawer: MenuWidget(
        // Pass the onMenuItemTap callback
        onMenuItemTap: (index) {
          _navigatorKey.currentState!.pushReplacement(
            MaterialPageRoute(builder: (context) => pages[index]),
          );
        },
      ),
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => pages[_currentIndex],
          );
        },
      ),
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
          ),
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
