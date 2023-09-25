import 'package:flutter/material.dart';
import 'package:ghethanhpham_thaco/blocs/app_bloc.dart';
import 'package:ghethanhpham_thaco/blocs/hoachat_bloc.dart';
import 'package:ghethanhpham_thaco/models/products/hoachat_model.dart';
import 'package:provider/provider.dart';

class HienThiHoaChat extends StatefulWidget {
  const HienThiHoaChat({super.key});

  @override
  State<HienThiHoaChat> createState() => _HienThiHoaChatState();
}

class _HienThiHoaChatState extends State<HienThiHoaChat> {
  List<HoaChatModel?> _listHoaChatISO = [];
  List<HoaChatModel?> _listHoaChatPoly = [];
  late HoaChatBloc _hoaChatBloc;
  late AppBloc _appBloc;
  String selectedOption = "Hoa Chat 1";

  @override
  void initState() {
    super.initState();
    _appBloc = Provider.of<AppBloc>(context, listen: false);
    _hoaChatBloc = Provider.of<HoaChatBloc>(context, listen: false);
  }

  void getDataHoaChat(String mahoachat) {
    _hoaChatBloc.getDataHoaChat(mahoachat).then((_) {
      setState(() {
        if (mahoachat == 'ISO') {
          _listHoaChatISO = _hoaChatBloc.listHoaChatISO;
        }
        if (mahoachat == 'POLY') {
          _listHoaChatPoly = _hoaChatBloc.listHoaChatPoly;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedOption,
      onChanged: (String? newValue) {
        setState(() {
          selectedOption = newValue!;
        });
      },
      items: <String>[
        'Hoa Chat 1',
        'Hoa Chat 2',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
