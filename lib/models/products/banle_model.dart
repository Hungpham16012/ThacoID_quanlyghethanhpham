class BanLeModel {
  String hangHoaId;
  String maCode;
  bool isNhapKho;
  String donHangBanLeChiTietId;
  String tenHangHoa;
  String maHangHoa;
  String tenSanPham;
  String maSanPham;
  String maSoNoiBo;
  String tenDongXe;
  String tenLoaiXe;
  String tenDonViTinh;
  String? nhapXuatKhoId;
  String? ngay;

  BanLeModel({
    required this.hangHoaId,
    required this.maCode,
    required this.isNhapKho,
    required this.donHangBanLeChiTietId,
    required this.tenHangHoa,
    required this.maHangHoa,
    required this.tenSanPham,
    required this.maSanPham,
    required this.maSoNoiBo,
    required this.tenDongXe,
    required this.tenLoaiXe,
    required this.tenDonViTinh,
    this.nhapXuatKhoId,
    this.ngay,
  });

  factory BanLeModel.fromJson(Map<String, dynamic> json) => BanLeModel(
        hangHoaId: json["hangHoaId"],
        maCode: json["maCode"],
        isNhapKho: json["isNhapKho"],
        donHangBanLeChiTietId: json["donHangBanLeChiTietId"],
        tenHangHoa: json["tenHangHoa"],
        maHangHoa: json["maHangHoa"],
        tenSanPham: json["tenSanPham"],
        maSanPham: json["maSanPham"],
        maSoNoiBo: json["maSoNoiBo"],
        tenDongXe: json["tenDongXe"],
        tenLoaiXe: json["tenLoaiXe"],
        tenDonViTinh: json["tenDonViTinh"],
        nhapXuatKhoId: json["nhapXuatKhoId"],
        ngay: json["ngay"],
      );

  Map<String, dynamic> toJson() => {
        "hangHoaId": hangHoaId,
        "maCode": maCode,
        "isNhapKho": isNhapKho,
        "donHangBanLeChiTietId": donHangBanLeChiTietId,
        "tenHangHoa": tenHangHoa,
        "maHangHoa": maHangHoa,
        "tenSanPham": tenSanPham,
        "maSanPham": maSanPham,
        "maSoNoiBo": maSoNoiBo,
        "tenDongXe": tenDongXe,
        "tenLoaiXe": tenLoaiXe,
        "tenDonViTinh": tenDonViTinh,
        "nhapXuatKhoId": nhapXuatKhoId,
        "ngay": ngay,
      };
}
