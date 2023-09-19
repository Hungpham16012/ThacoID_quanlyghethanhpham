import 'dart:ffi';

import 'package:ghethanhpham_thaco/models/scan.dart';

class ExportModel {
  String id;
  String maKe;
  String maLot;
  String tenLoaiXe;
  String tenDongXe;
  String tenSanPham;
  List<ScanModel> listChiTietKe;
  String? ngay;
  bool isXuat;

  ExportModel({
    required this.id,
    required this.maKe,
    required this.maLot,
    required this.tenLoaiXe,
    required this.tenDongXe,
    required this.tenSanPham,
    this.ngay,
    required this.listChiTietKe,
    required this.isXuat,
  });

  factory ExportModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> listChiTietKeJson = json['listChiTietKe'];
    List<ScanModel> listChiTietKe = listChiTietKeJson
        .map((itemJson) => ScanModel.fromJson(itemJson))
        .toList();
    return ExportModel(
      id: json['id'],
      maKe: json['maKe'],
      maLot: json['maLot'],
      tenLoaiXe: json['tenLoaiXe'],
      tenDongXe: json['tenDongXe'],
      tenSanPham: json['tenSanPham'],
      ngay: json['ngay'],
      listChiTietKe: listChiTietKe,
      isXuat: json['isXuat'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'maKe': maKe,
        'maLot': maLot,
        'tenLoaiXe': tenLoaiXe,
        'tenDongXe': tenDongXe,
        'tenSanPham': tenSanPham,
        'ngay': ngay,
        'listChiTietKe': listChiTietKe
            .map(
              (chiTietKe) => chiTietKe.toJson(),
            )
            .toList(),
        'isXuat': isXuat,
      };
}
