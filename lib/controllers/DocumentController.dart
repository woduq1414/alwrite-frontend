import 'package:alwrite/data/api.dart';
import 'package:alwrite/models/documentModel.dart';
import 'package:alwrite/models/lawModel.dart';
import 'package:alwrite/models/tableModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alwrite/models/statModel.dart';

class DocumentController extends GetxController {
  final GetConnect _getConnect = GetConnect(timeout: Duration(seconds: 60));

  String targetString = "";

  bool isFetchingLaw = false;
  bool isFetchingDocument = false;
  List<LawModel> lawList = [];
  List<DocumentModel> documentList = [];

  Future<void> started() async {
    print("@@@00");

    if(targetString == ""){
      targetString = "안전";
    }
    getLawList();
    getDocumentList();
  }

  Future<void> getLawList() async {
    lawList = await fetchLawList();
    isFetchingLaw = false;
    update();
  }

  Future<List<LawModel>> fetchLawList() async {
    print("@@@111");
    final response = await _getConnect
        .post('${API_URL}/document/similar_law', {'text': targetString});

    if (response.statusCode == 200) {
      lawList = [];
      for (var item in response.body["laws"]) {
        lawList.add(LawModel.fromJson(item));
      }
      return lawList;
    } else {
      print(response.statusCode);
      return [];
    }
  }

  Future<void> getDocumentList() async {
    documentList = await fetchDocumentList();
    isFetchingDocument = false;
    update();
  }

  Future<List<DocumentModel>> fetchDocumentList() async {
    print("@@@111");
    final response = await _getConnect
        .post('${API_URL}/document/similar_document', {'text': targetString});

    if (response.statusCode == 200) {
      documentList = [];
      for (var item in response.body["documents"]) {
        documentList.add(DocumentModel.fromJson(item));
      }
      return documentList;
    } else {
      print(response.statusCode);
      return [];
    }
  }
}
