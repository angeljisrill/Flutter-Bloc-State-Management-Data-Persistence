import 'dart:convert';

class ItemModel {
  final String id;
  final String title;
  final bool isDone;

  ItemModel({required this.id, required this.title, this.isDone = false});

  ItemModel copyWith({String? title, bool? isDone}) {
    return ItemModel(
      id: id,
      title: title ?? this.title,
      isDone: isDone ?? this.isDone,
    );
  }

  Map<String, dynamic> toJson() => {"id": id, "title": title, "isDone": isDone};

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json["id"],
      title: json["title"],
      isDone: json["isDone"],
    );
  }

  static String encode(List<ItemModel> items) {
    return jsonEncode(items.map((e) => e.toJson()).toList());
  }

  static List<ItemModel> decode(String data) {
    if (data.isEmpty) return [];
    final List<dynamic> jsonList = jsonDecode(data) as List<dynamic>;
    return jsonList
        .map(
          (item) => ItemModel.fromJson(Map<String, dynamic>.from(item as Map)),
        )
        .toList();
  }
}
