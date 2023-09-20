class NhomChucNangModel {
  String tenNhomChucNang;
  bool isNhapKho;
  int thuTu;
  List<ChucNang> lstChucNangs;

  NhomChucNangModel({
    required this.tenNhomChucNang,
    required this.isNhapKho,
    required this.thuTu,
    required this.lstChucNangs,
  });

  factory NhomChucNangModel.fromJson(Map<String, dynamic> json) {
    List<ChucNang> chucNangs = (json['lstChucNangs'] as List)
        .map((chucNang) => ChucNang.fromJson(chucNang))
        .toList();

    return NhomChucNangModel(
      tenNhomChucNang: json['tenNhomChucNang'],
      isNhapKho: json['isNhapKho'],
      thuTu: json["thuTu"],
      lstChucNangs: chucNangs,
    );
  }
}

class ChucNang {
  bool checked;
  String tenChucNang;
  bool isNhapKho;
  bool isNem;
  String maChucNang;
  int thuTu;
  List<Chuyen>? lstChuyenIds;

  ChucNang({
    required this.checked,
    required this.tenChucNang,
    required this.isNhapKho,
    required this.isNem,
    required this.maChucNang,
    required this.thuTu,
    this.lstChuyenIds,
  });

  factory ChucNang.fromJson(Map<String, dynamic> json) {
    List<Chuyen>? chuyenIds = (json['lstChuyenIds'] as List)
        .map((chuyenId) => Chuyen.fromJson(chuyenId))
        .toList();

    return ChucNang(
      checked: json['checked'],
      tenChucNang: json['tenChucNang'],
      isNhapKho: json['isNhapKho'],
      isNem: json['isNem'],
      maChucNang: json['maChucNang'],
      thuTu: json['thuTu'],
      lstChuyenIds: chuyenIds,
    );
  }
}

class Chuyen {
  String maChucNang;
  int thuTu;
  String tenChuyen;
  String chuyenId;

  Chuyen({
    required this.maChucNang,
    required this.thuTu,
    required this.tenChuyen,
    required this.chuyenId,
  });

  factory Chuyen.fromJson(Map<String, dynamic> json) {
    return Chuyen(
      maChucNang: json['maChucNang'],
      thuTu: json['thuTu'],
      tenChuyen: json['tenChuyen'],
      chuyenId: json['chuyenId'],
    );
  }
}
