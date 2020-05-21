class InfoModel {
  final String id;
  final String url;
  final DateTime expire;

  InfoModel({this.id, this.url, this.expire});

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
        id: json['id'],
        url: json['url'],
        expire: DateTime.parse(json['expire']));
  }

  Map<String, dynamic> toJson() {
    return {'id': this.id, 'url': this.url, 'expire': this.expire.toString()};
  }
}
