// ignore: file_names
class AoNemGheModel {
  String nhapKhoAoNemId;
  String barCodeNemAoId;
  String? maKe;
  String maNemAo;
  String maCode;
  String tenNemAo;
  bool isNem;
  String? tenSanPham;
  String? tenDongXe;
  String? tenLoaiXe;
  String tenChiTiet;
  String ngay;

  AoNemGheModel({
    required this.nhapKhoAoNemId,
    required this.barCodeNemAoId,
    this.maKe,
    required this.maNemAo,
    required this.maCode,
    required this.tenNemAo,
    required this.isNem,
    this.tenSanPham,
    this.tenDongXe,
    this.tenLoaiXe,
    required this.tenChiTiet,
    required this.ngay,
  });

  factory AoNemGheModel.fromJson(Map<String, dynamic> json) {
    return AoNemGheModel(
      nhapKhoAoNemId: json['nhapKhoAoNemId'],
      barCodeNemAoId: json['barCodeNemAoId'],
      maKe: json['maKe'],
      maNemAo: json['maNemAo'],
      maCode: json['maCode'],
      tenNemAo: json['tenNemAo'],
      isNem: json['isNem'],
      tenSanPham: json['tenSanPham'],
      tenDongXe: json['tenDongXe'],
      tenLoaiXe: json['tenLoaiXe'],
      tenChiTiet: json['tenChiTiet'],
      ngay: json['ngay'],
    );
  }
}
