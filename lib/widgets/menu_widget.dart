import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/config/config.dart';
import 'package:ghethanhpham_thaco/widgets/divider.dart';

class MenuWidget extends StatelessWidget {
  final Function(int) onMenuItemTap;

  const MenuWidget({super.key, required this.onMenuItemTap});

  // ignore: non_constant_identifier_names
  Widget MenuItem({
    required String text,
    IconData? icon,
    double? fontSize,
    int? index,
    BuildContext? context,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
        ),
      ),
      onTap: () {
        Navigator.pop(context!);
        onMenuItemTap(index!);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
          const DividerWidget(),
          ExpansionTile(
            title: const Text(
              'Nhập kho',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            leading: const Icon(
              Icons.import_export_sharp,
            ),
            children: [
              MenuItem(
                text: 'Nhập kho thành phẩm',
                fontSize: 17,
                index: 2,
                context: context,
                icon: Icons.add_circle,
              ),
              MenuItem(
                text: 'Nhập kho áo',
                fontSize: 17,
                index: 2,
                context: context,
                icon: Icons.add_circle,
              ),
              MenuItem(
                text: 'Nhập kho nệm',
                fontSize: 17,
                index: 2,
                context: context,
                icon: Icons.add_circle,
              ),
              MenuItem(
                text: 'Nhập kho bán lẻ',
                fontSize: 17,
                index: 2,
                context: context,
                icon: Icons.add_circle,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          ExpansionTile(
            title: const Text(
              'Xuất kho',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            leading: const Icon(Icons.import_export_sharp),
            children: [
              MenuItem(
                text: 'Xuất kho theo kệ',
                fontSize: 17,
                index: 2,
                context: context,
                icon: Icons.add_circle,
              ),
              MenuItem(
                text: 'Xuất kho theo chi tiết (BMW)',
                fontSize: 17,
                index: 2,
                context: context,
                icon: Icons.add_circle,
              ),
              MenuItem(
                text: 'Xuất kho bán lẻ',
                fontSize: 17,
                index: 2,
                context: context,
                icon: Icons.add_circle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
