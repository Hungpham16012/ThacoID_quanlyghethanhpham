import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/config/config.dart';

class MenuWidget extends StatelessWidget {
  final Function(int) onMenuItemTap;

  const MenuWidget({Key? key, required this.onMenuItemTap});

  Widget MenuItem({
    required String text,
    IconData? icon,
    double? fontSize,
    int? index,
  }) {
    const color = Color.fromARGB(255, 0, 0, 0);
    const hoverColor = Color.fromARGB(221, 75, 75, 221);

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
      onTap: () {
        onMenuItemTap(index!); // Gọi callback function để chuyển chỉ mục
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
                index: 2, // Đặt chỉ mục tương ứng
              ),
              MenuItem(
                text: 'Nhập nệm ghế',
                fontSize: 17,
                index: 2, // Đặt chỉ mục tương ứng
              ),
              MenuItem(
                text: 'Nhập thành phẩm ghế',
                fontSize: 17,
                index: 2, // Đặt chỉ mục tương ứng
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
                index: 2, // Đặt chỉ mục tương ứng
              ),
              MenuItem(
                text: 'Xuất kho theo chi tiết (BMW)',
                fontSize: 17,
                index: 2, // Đặt chỉ mục tương ứng
              ),
              MenuItem(
                text: 'Xuất bán lẻ',
                fontSize: 17,
                index: 2, // Đặt chỉ mục tương ứng
              ),
            ],
          ),
        ],
      ),
    );
  }
}
