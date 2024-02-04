import 'package:alwrite/controllers/DocumentController.dart';
import 'package:alwrite/controllers/StatController.dart';
import 'package:alwrite/models/statModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DocumentSimilarPage extends StatelessWidget {
  const DocumentSimilarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final documentController = Get.put(DocumentController());

    return GetBuilder<StatController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(title: Text("인용문 찾기")),
          body: Row(
            children: [
              Container(
                width: 350,
                child: Column(children: [
                  Text("검색어", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  
                ],),
              ),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(bottom: 6),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Container() ))
            ],
          ));
    });
  }
}


