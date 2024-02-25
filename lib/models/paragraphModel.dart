import 'package:alwrite/models/documentModel.dart';
import 'package:alwrite/models/lawModel.dart';

class ParagraphModel {
  String text;
  List<dynamic> data;

  ParagraphModel({
    required this.text,
    required this.data,
  });

  factory ParagraphModel.fromJson(Map<String, dynamic> json) {
    String text_;
    List<dynamic> data_ = [];
    
    text_ = json['text'];
    if(json.containsKey("documents")){
      data_ = json['documents'].map((e) => DocumentModel.fromJson(e)).toList();
    }else if(json.containsKey("laws")){
      data_ = json['laws'].map((e) => LawModel.fromJson(e)).toList();
    }

    return ParagraphModel(
      text: text_,
      data: data_,
    );
  }
}
