import 'package:alwrite/controllers/DocumentController.dart';
import 'package:alwrite/controllers/StatController.dart';
import 'package:alwrite/models/statModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class DocumentWritePage extends StatelessWidget {
  const DocumentWritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final documentController = Get.put(DocumentController());
    TextEditingController textarea = TextEditingController();
    return GetBuilder<DocumentController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(title: Text("인용문 찾기")),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("작성하는 글을 입력해주시면, 관련 법률과 사설을 찾아드립니다.",
                  style: TextStyle(fontSize: 18, )),
              SizedBox(
                height: 8,
              ),
              Expanded(
                child: TextField(
                  controller: textarea,
                  keyboardType: TextInputType.multiline,
                  maxLines: 50,
                  decoration: InputDecoration(
                      hintText: "글을 입력해주세요.",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey[300]!))),
                ),
              ),
              SizedBox(height: 8,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    documentController.targetString = textarea.text;
                    GoRouter.of(context).go("/document/result");
                  },
                  child: Text(
                    "다음",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
