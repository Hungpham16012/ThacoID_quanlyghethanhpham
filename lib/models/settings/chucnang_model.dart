// ignore: implementation_imports
import 'package:flutter/src/widgets/basic.dart';

class ChucNangModel {
  String tenNhomChucNang;
  bool isNhapKho;
  int thuTu;
  List<ChucNangItemModel> lstChucNangs;

  ChucNangModel({
    required this.tenNhomChucNang,
    required this.isNhapKho,
    required this.thuTu,
    required this.lstChucNangs,
  });

  factory ChucNangModel.fromJson(Map<String, dynamic> json) {
    return ChucNangModel(
      tenNhomChucNang: json['tenNhomChucNang'].toString(),
      isNhapKho: json['isNhapKho'],
      thuTu: json['thuTu'],
      lstChucNangs: (json['lstChucNangs'] as List)
          .map((e) => ChucNangItemModel.fromJson(e))
          .toList(),
    );
  }

  get tenChucNang => null;

  get lstChuyenIds => null;

  map(Column Function(dynamic feature) param0) {}
}

class ChucNangItemModel {
  bool checked;
  String tenChucNang;
  bool isNhapKho;
  bool isNem;
  String maChucNang;
  int thuTu;
  List<ChuyenModel>? lstChuyenIds;
  String? selected;

  ChucNangItemModel({
    required this.checked,
    required this.tenChucNang,
    required this.isNhapKho,
    required this.isNem,
    required this.maChucNang,
    required this.thuTu,
    this.lstChuyenIds,
    this.selected = '',
  });

  factory ChucNangItemModel.fromJson(Map<String, dynamic> json) {
    List<ChuyenModel>? lstChuyenIds;
    if (json['lstChuyenIds'] is List) {
      lstChuyenIds = (json['lstChuyenIds'] as List)
          .map((e) => ChuyenModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      lstChuyenIds = null;
    }
    return ChucNangItemModel(
      checked: json['checked'],
      tenChucNang: json['tenChucNang'],
      isNhapKho: json['isNhapKho'],
      isNem: json['isNem'],
      maChucNang: json['maChucNang'],
      thuTu: json['thuTu'],
      lstChuyenIds: lstChuyenIds,
    );
  }
}

class ChuyenModel {
  String maChucNang;
  int thuTu;
  String tenChuyen;
  String chuyenId;

  ChuyenModel({
    required this.maChucNang,
    required this.thuTu,
    required this.tenChuyen,
    required this.chuyenId,
  });

  factory ChuyenModel.fromJson(Map<String, dynamic> json) {
    return ChuyenModel(
      maChucNang: json['maChucNang'],
      thuTu: json['thuTu'],
      tenChuyen: json['tenChuyen'],
      chuyenId: json['chuyenId'],
    );
  }
}
