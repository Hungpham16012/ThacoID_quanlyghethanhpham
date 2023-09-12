// To parse this JSON data, do
//
//     final ScanModel = ScanModelFromJson(jsonString);

import 'dart:convert';

ScanModel scanModelFromJson(String str) => ScanModel.fromJson(json.decode(str));

String scanModelToJson(ScanModel data) => json.encode(data.toJson());

class ScanModel {
  String nhapXuatKhoId;
  String chiTietId;
  String chuyenId;
  String barCodeId;
  String tenChiTiet;
  String tenLoaiXe;
  String tenDongXe;
  String maCode;
  String ngay;
  bool isNhapKho;

  ScanModel({
    required this.nhapXuatKhoId,
    required this.chiTietId,
    required this.chuyenId,
    required this.barCodeId,
    required this.tenChiTiet,
    required this.tenLoaiXe,
    required this.tenDongXe,
    required this.maCode,
    required this.ngay,
    required this.isNhapKho,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        nhapXuatKhoId: json["nhapXuatKhoId"],
        chiTietId: json["chiTietId"],
        chuyenId: json["chuyenId"],
        barCodeId: json["barCodeId"],
        tenChiTiet: json["tenChiTiet"],
        tenLoaiXe: json["tenLoaiXe"],
        tenDongXe: json["tenDongXe"],
        maCode: json["maCode"],
        ngay: json["ngay"],
        isNhapKho: json["isNhapKho"],
      );

  Map<String, dynamic> toJson() => {
        "nhapXuatKhoId": nhapXuatKhoId,
        "chiTietId": chiTietId,
        "chuyenId": chuyenId,
        "barCodeId": barCodeId,
        "tenChiTiet": tenChiTiet,
        "tenLoaiXe": tenLoaiXe,
        "tenDongXe": tenDongXe,
        "maCode": maCode,
        "ngay": ngay,
        "isNhapKho": isNhapKho,
      };
}
