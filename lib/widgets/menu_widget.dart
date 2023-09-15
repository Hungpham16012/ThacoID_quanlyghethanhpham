import 'package:flutter/material.dart';

import 'package:ghethanhpham_thaco/config/config.dart';
import 'package:ghethanhpham_thaco/pages/home.dart';
import 'package:ghethanhpham_thaco/pages/setting/setting.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Image(
              image: const AssetImage(Config.logoId),
              width: MediaQuery.of(context).size.width - 200,
              height: MediaQuery.of(context).size.width - 300,
              fit: BoxFit.contain,
            ),
            ExpansionTile(
              title: const Text(
                'Nhập kho',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              leading: const Icon(
                Icons.import_export_sharp,
              ),
              children: [
                MenuItem(
                  text: 'Nhập áo ghế',
                  fontSize: 17,
                  onClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      ),
                    );
                  },
                ),
                MenuItem(
                  text: 'Nhập nệm ghế',
                  fontSize: 17,
                  onClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      ),
                    );
                  },
                ),
                MenuItem(
                  text: 'Nhập thành phẩm ghế',
                  fontSize: 17,
                  onClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            ExpansionTile(
              title: const Text(
                'Xuất kho',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
              ),
              leading: const Icon(Icons.import_export_sharp),
              children: [
                MenuItem(
                  text: 'Xuất kho theo kệ',
                  fontSize: 17,
                  onClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      ),
                    );
                  },
                ),
                MenuItem(
                  text: 'Xuất kho theo chi tiết (BMW)',
                  fontSize: 17,
                  onClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      ),
                    );
                  },
                ),
                MenuItem(
                  text: 'Xuất bán lẻ',
                  fontSize: 17,
                  onClicked: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Widget MenuItem({
  required String text,
  IconData? icon,
  double? fontSize,
  VoidCallback? onClicked,
}) {
  const color = Color.fromARGB(255, 0, 0, 0);
  const hoverColor = Colors.black87;

  return ListTile(
    leading: Icon(icon),
    title: Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
      ),
    ),
    hoverColor: hoverColor,
    onTap: onClicked,
  );
}
