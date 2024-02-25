class LawModel {
  final String title;
  final String url;
  final String reference;

   LawModel({
    required this.title,
    required this.url,
    required this.reference,
   });

    LawModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        url = json['url'],
        reference = json['reference'];
}