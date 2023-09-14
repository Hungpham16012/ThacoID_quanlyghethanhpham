import 'package:intl/intl.dart';

class KeScanModel {
  String keId;
  String maKe;
  String maLot;
  String tenLoaiXe;
  String tenDongXe;
  String tenSanPham;
  DateTime createdDate;
  List<ChiTietKe> chiTietKe;

  KeScanModel({
    required this.keId,
    required this.maKe,
    required this.maLot,
    required this.tenLoaiXe,
    required this.tenDongXe,
    required this.tenSanPham,
    required this.createdDate,
    required this.chiTietKe,
  });
  Map<String, dynamic> toJson() {
    return {
      'keId': keId,
      'maKe': maKe,
      'maLot': maLot,
      'tenLoaiXe': tenLoaiXe,
      'tenDongXe': tenDongXe,
      'tenSanPham': tenSanPham,
      'CreatedDate': createdDate.toIso8601String(),
      'chiTietKe': chiTietKe.map((chiTiet) => chiTiet.toJson()).toList(),
    };
  }

  factory KeScanModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> chiTietKeList = json['chiTietKe'];
    List<ChiTietKe> chiTietKe =
        chiTietKeList.map((dynamic item) => ChiTietKe.fromJson(item)).toList();

    return KeScanModel(
      keId: json['keId'],
      maKe: json['maKe'],
      maLot: json['maLot'],
      tenLoaiXe: json['tenLoaiXe'],
      tenDongXe: json['tenDongXe'],
      tenSanPham: json['tenSanPham'],
      createdDate:
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(json['CreatedDate']),
      chiTietKe: chiTietKe,
    );
  }
}

class ChiTietKe {
  String chiTietKeId;
  String maKe;
  String maLot;
  String tenLoaiXe;
  String tenDongXe;
  String tenSanPham;
  String maCode;
  String tenChiTiet;
  String tenDonViTinh;
  int soLuong;
  DateTime createdDate;

  ChiTietKe({
    required this.chiTietKeId,
    required this.maKe,
    required this.maLot,
    required this.tenLoaiXe,
    required this.tenDongXe,
    required this.tenSanPham,
    required this.maCode,
    required this.tenChiTiet,
    required this.tenDonViTinh,
    required this.soLuong,
    required this.createdDate,
  });

  factory ChiTietKe.fromJson(Map<String, dynamic> json) {
    return ChiTietKe(
      chiTietKeId: json['chiTietKeId'],
      maKe: json['maKe'],
      maLot: json['maLot'],
      tenLoaiXe: json['tenLoaiXe'],
      tenDongXe: json['tenDongXe'],
      tenSanPham: json['tenSanPham'],
      maCode: json['maCode'],
      tenChiTiet: json['tenChiTiet'],
      tenDonViTinh: json['tenDonViTinh'],
      soLuong: json['soLuong'],
      createdDate:
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").parse(json['CreatedDate']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'chiTietKeId': chiTietKeId,
      'maKe': maKe,
      'maLot': maLot,
      'tenLoaiXe': tenLoaiXe,
      'tenDongXe': tenDongXe,
      'tenSanPham': tenSanPham,
      'maCode': maCode,
      'tenChiTiet': tenChiTiet,
      'tenDonViTinh': tenDonViTinh,
      'soLuong': soLuong,
      'CreatedDate': createdDate.toIso8601String(),
    };
  }
}
