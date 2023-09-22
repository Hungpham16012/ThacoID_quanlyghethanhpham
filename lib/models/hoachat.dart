class HoaChatModel {
  String id;
  String maHoaChat;
  String tenHoaChat;
  String soLot;
  String hanSuDung;
  String ngaySanXuat;

  HoaChatModel({
    required this.id,
    required this.maHoaChat,
    required this.tenHoaChat,
    required this.soLot,
    required this.hanSuDung,
    required this.ngaySanXuat,
  });

  factory HoaChatModel.fromJson(Map<String, dynamic> json) => HoaChatModel(
        id: json["id"],
        maHoaChat: json["maHoaChat"],
        tenHoaChat: json["tenHoaChat"],
        soLot: json["soLot"],
        hanSuDung: json["hanSuDung"],
        ngaySanXuat: json["ngaySanXuat"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "maHoaChat": maHoaChat,
        "tenHoaChat": tenHoaChat,
        "soLot": soLot,
        "hanSuDung": hanSuDung,
        "ngaySanXuat": ngaySanXuat,
      };
}
