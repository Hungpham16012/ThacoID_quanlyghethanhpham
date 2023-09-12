class HistoryModal {
  // {
  //     "maChiTiet": null,
  //     "tenChiTiet": null,
  //     "maCode": "G01000000000115DSA7KHFR02232",
  //     "thoiGianNhap": "17:39 15/02/2023",
  //     "thoiGianHuy": ""
  //   },
  String maChiTiet;
  String tenChiTiet;
  String maCode;
  String thoiGianNhap;
  String thoiGianHuy;

  HistoryModal({
    required this.maChiTiet,
    required this.tenChiTiet,
    required this.maCode,
    required this.thoiGianNhap,
    required this.thoiGianHuy,
  });

  factory HistoryModal.fromJson(Map<String, dynamic> json) {
    return HistoryModal(
      maChiTiet: json["maChiTiet"],
      tenChiTiet: json["tenChiTiet"],
      maCode: json["maCode"],
      thoiGianNhap: json["thoiGianNhap"],
      thoiGianHuy: json["thoiGianHuy"],
    );
  }
}