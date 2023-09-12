class MauModel {
  String id;
  String maMau;
  String tenMaMau;
  String tenLoaiXe;
  int thuTu;
  bool isSuDung;

  MauModel({
    required this.id,
    required this.maMau,
    required this.tenMaMau,
    required this.tenLoaiXe,
    required this.thuTu,
    required this.isSuDung,
  });

  factory MauModel.fromJson(Map<String, dynamic> json) => MauModel(
        id: json["id"],
        maMau: json["maMau"],
        tenMaMau: json["tenMaMau"],
        tenLoaiXe: json["tenLoaiXe"],
        thuTu: json["thuTu"],
        isSuDung: json["isSuDung"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "maMau": maMau,
        "tenMaMau": tenMaMau,
        "tenLoaiXe": tenLoaiXe,
        "thuTu": thuTu,
        "isSuDung": isSuDung,
      };
}
