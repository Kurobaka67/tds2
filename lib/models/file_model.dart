import 'dart:convert';

List<FileModel> fileModelFromJson(String str) =>
    List<FileModel>.from(json.decode(str).map((x) => FileModel.fromJson(x)));

String fileModelToJson(List<FileModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FileModel {
  FileModel({
    required this.id,
    required this.base64,
  });

  int id;
  String base64;

  factory FileModel.fromJson(Map<String, dynamic> json) => FileModel(
    id: json["group_id"],
    base64: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "group_id": id,
    "file": base64,
  };
}