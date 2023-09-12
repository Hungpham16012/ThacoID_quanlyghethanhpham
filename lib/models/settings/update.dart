class UpdateApp {
  String id;
  String maPhienBan;
  String fileName;
  String fileUrl;
  String nguoiTao;
  String ngayTao;
  bool isSuDung;

  UpdateApp({
    required this.id,
    required this.maPhienBan,
    required this.fileName,
    required this.fileUrl,
    required this.nguoiTao,
    required this.ngayTao,
    required this.isSuDung,
  });

  factory UpdateApp.fromJson(Map<String, dynamic> json) {
    return UpdateApp(
      id: json['id'].toString(),
      maPhienBan: json['maPhienBan'].toString(),
      fileName: json['file_Name'].toString(),
      fileUrl: json['file_Url'].toString(),
      ngayTao: json['nguoiTao'].toString(),
      nguoiTao: json['nguoiTao'].toString(),
      isSuDung: json['isSuDung'],
    );
  }
}
