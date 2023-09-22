class HistoryModal {
  String maChiTiet;
  String tenChiTiet;
  String maCode;
  DateTime nhap;
  String thoiGianNhap;
  String thoiGianHuy;
  bool isNemAo;

  HistoryModal({
    required this.maChiTiet,
    required this.tenChiTiet,
    required this.maCode,
    required this.nhap,
    required this.thoiGianNhap,
    required this.thoiGianHuy,
    required this.isNemAo,
  });

  factory HistoryModal.fromJson(Map<String, dynamic> json) => HistoryModal(
        maChiTiet: json["maChiTiet"],
        tenChiTiet: json["tenChiTiet"],
        maCode: json["maCode"],
        nhap: DateTime.parse(json["nhap"]),
        thoiGianNhap: json["thoiGianNhap"],
        thoiGianHuy: json["thoiGianHuy"],
        isNemAo: json["isNemAo"],
      );
}
