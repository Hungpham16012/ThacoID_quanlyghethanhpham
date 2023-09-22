class HistoryModel {
  // {
  //     "maChiTiet": null,
  //     "tenChiTiet": null,
  //     "maCode": "G01000000000115DSA7KHFR02232",
  //       isNemGhe de phan biet mau
  //     "thoiGianNhap": "17:39 15/02/2023",
  //     "thoiGianHuy": ""
  //   }
  String maChiTiet;
  String tenChiTiet;
  String maCode;
  DateTime nhap;
  String thoiGianNhap;
  String thoiGianHuy;
  bool isNemAo;

  HistoryModel({
    required this.maChiTiet,
    required this.tenChiTiet,
    required this.maCode,
    required this.nhap,
    required this.thoiGianNhap,
    required this.thoiGianHuy,
    required this.isNemAo,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        maChiTiet: json["maChiTiet"],
        tenChiTiet: json["tenChiTiet"],
        maCode: json["maCode"],
        nhap: DateTime.parse(json["nhap"]),
        thoiGianNhap: json["thoiGianNhap"],
        thoiGianHuy: json["thoiGianHuy"],
        isNemAo: json["isNemAo"],
      );
}
