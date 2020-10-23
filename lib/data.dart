class Data {
  int pageid;
  String title;
  AdditionalDetailsModel thumbnail;

  Data({
    this.pageid,
    this.title,
    this.thumbnail,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageid'] = this.pageid;
    data['title'] = this.title;
    data['thumbnail'] = this.thumbnail;

    return data;
  }

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      pageid: json['pageid'],
      title: json['title'],
      thumbnail: json.containsKey('thumbnail')
          ? AdditionalDetailsModel.fromJson(json["thumbnail"])
          : null,
    );
  }
}

class DataModel {
  List<Data> list;

  DataModel({this.list});
}

class AdditionalDetailsModel {
  dynamic source;

  AdditionalDetailsModel({this.source});

  factory AdditionalDetailsModel.fromJson(Map<String, dynamic> json) {
    return AdditionalDetailsModel(
      source: json["source"],
    );
  }
}
