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
      tenNhomChucNang: json["tenNhomChucNang"].toString(),
      isNhapKho: json["isNhapKho"],
      thuTu: json["thuTu"],
      lstChucNangs: (json['lstChucNangs'] as List)
          .map((e) => ChucNangItemModel.fromJson(e))
          .toList(),
    );
  }
}

class ChucNangItemModel {
  String chuyenId;
  String tenChucNang;
  bool checked;
  int thuTu;

  ChucNangItemModel({
    required this.chuyenId,
    required this.tenChucNang,
    required this.checked,
    required this.thuTu,
  });

  factory ChucNangItemModel.fromJson(Map<String, dynamic> json) {
    return ChucNangItemModel(
      chuyenId: json["chuyenId"].toString(),
      tenChucNang: json["tenChucNang"].toString(),
      checked: json["checked"],
      thuTu: json["thuTu"],
    );
  }
}
