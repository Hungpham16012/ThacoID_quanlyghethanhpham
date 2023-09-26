// ignore: file_names
class AoNemGheModel {
  String? nhapKhoAoNemId;
  String barCodeNemAoId;
  String? maKe;
  String maNemAo;
  String maCode;
  String tenNemAo;
  bool isNem;
  String? tenSanPham;
  String tenDongXe;
  String tenLoaiXe;
  String tenChiTiet;
  String? ngay;
  String? hoaChat1Id;
  String? hoaChat2Id;

  AoNemGheModel({
    this.nhapKhoAoNemId,
    required this.barCodeNemAoId,
    this.maKe,
    required this.maNemAo,
    required this.maCode,
    required this.tenNemAo,
    required this.isNem,
    this.tenSanPham,
    required this.tenDongXe,
    required this.tenLoaiXe,
    required this.tenChiTiet,
    this.ngay,
    this.hoaChat1Id,
    this.hoaChat2Id,
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
  Map<String, dynamic> toJson() => {
        "nhapKhoAoNemId": nhapKhoAoNemId,
        "barCodeNemAoId": barCodeNemAoId,
        "maKe": maKe,
        "maNemAo": maNemAo,
        "maCode": maCode,
        "tenNemAo": tenNemAo,
        "isNem": isNem,
        "tenSanPham": tenSanPham,
        "tenDongXe": tenDongXe,
        "tenLoaiXe": tenLoaiXe,
        "tenChiTiet": tenChiTiet,
        "ngay": ngay,
        "hoaChat1Id": hoaChat1Id,
        "hoaChat2Id": hoaChat2Id,
      };
}
