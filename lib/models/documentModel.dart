class DocumentModel {
  final String title;
  final String writer;
  final String date;
  final String from;
  final String reference;
  final String url;

   DocumentModel({
    required this.title,
    required this.writer,
    required this.date,
    required this.from,
    required this.reference,
    required this.url,
   });

    DocumentModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        writer = json['writer'],
        date = json['date'],
        from = json['from'],
        reference = json['reference'],
        url = json['url'];
}