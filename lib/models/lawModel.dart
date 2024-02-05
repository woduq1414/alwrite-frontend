class LawModel {
  final String title;
  final String url;

   LawModel({
    required this.title,
    required this.url,
   });

    LawModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        url = json['url'];
}