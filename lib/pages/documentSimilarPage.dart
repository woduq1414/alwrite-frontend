import 'dart:ui';

import 'package:alwrite/controllers/DocumentController.dart';
import 'package:alwrite/controllers/StatController.dart';
import 'package:alwrite/models/paragraphModel.dart';
import 'package:alwrite/models/statModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DocumentSimilarPage extends StatelessWidget {
  DocumentSimilarPage({super.key});
  final List<Tab> myTabs = <Tab>[
    Tab(text: '법'),
    Tab(text: '사설'),
  ];

  @override
  Widget build(BuildContext context) {
    final documentController = Get.put(DocumentController());
    TextEditingController textarea = TextEditingController();
    documentController.isFetchingDocument = true;
    documentController.isFetchingLaw = true;
    // documentController.update();
    documentController.started();
    return GetBuilder<DocumentController>(builder: (controller) {
      return DefaultTabController(
        length: myTabs.length,
        child: Builder(builder: (BuildContext context) {
          final TabController tabController = DefaultTabController.of(context)!;
          tabController.addListener(() {
            if (!tabController.indexIsChanging) {
              print(tabController.index);
              // add code to be executed on TabBar change
            }
          });
          return Scaffold(
            appBar: AppBar(
              title: Text("인용문 찾기"),
              bottom: TabBar(
                // controller: tabController,
                tabs: myTabs,
              ),
            ),
            body: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                width: double.infinity,
                child: TabBarView(
                  // controller: tabController,
                  children: myTabs.map((Tab tab) {
                    if (tab.text == "법") {
                      return controller.isFetchingLaw
                          ? SpinKitSquareCircle(
                              color: Colors.blue,
                              size: 100.0,
                            )
                          : ListView.builder(
                              itemCount: controller.lawParagraphList.length,
                              itemBuilder: ((context, index) {
                                ParagraphModel paragraph =
                                    controller.lawParagraphList[index];
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 240, 240, 240),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 0),
                                        margin: EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          "> " + paragraph.text,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Column(
                                          children: paragraph.data.map((law) {
                                        int idx = paragraph.data.indexOf(law);
                                        return Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: InkWell(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              onTap: () {
                                                launchUrl(Uri.parse(law.url));
                                              },
                                              child: ListTile(
                                                title: Text(
                                                    paragraph.data[idx].title),
                                                trailing: InkWell(
                                                  child: Icon(Icons.copy),
                                                  onTap: () {
                                                    Clipboard.setData(
                                                        ClipboardData(
                                                            text: paragraph
                                                                .data[idx]
                                                                .reference));
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "참고문헌 텍스트가 클립보드에 복사되었습니다.",
                                                        toastLength:
                                                            Toast.LENGTH_SHORT,
                                                        gravity:
                                                            ToastGravity.CENTER,
                                                        timeInSecForIosWeb: 1,
                                                        backgroundColor:
                                                            Colors.blue,
                                                        textColor: Colors.black,
                                                        fontSize: 16.0);
                                                  },
                                                ),
                                              ),
                                            ));
                                      }).toList())
                                    ],
                                  ),
                                );
                              }));
                    } else {
                      return controller.isFetchingDocument
                          ? SpinKitSquareCircle(
                              color: Colors.blue,
                              size: 100.0,
                            )
                          : ListView.builder(
                              itemCount: controller.documentParagraphList.length,
                              itemBuilder: ((context, index) {
                                ParagraphModel paragraph =
                                    controller.documentParagraphList[index];
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 5),
                                  margin: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 240, 240, 240),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 0),
                                        margin: EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          "> " + paragraph.text,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Column(
                                          children: paragraph.data.map((doc) {
                                        int idx = paragraph.data.indexOf(doc);
                                        return Card(
                                            child: InkWell(
                                          onTap: () {
                                            launchUrl(Uri.parse(
                                                paragraph.data[idx].url));
                                          },
                                          child: ListTile(
                                            title: Text(paragraph.data[idx].title),
                                            subtitle: Text(
                                              paragraph.data[idx].writer +
                                                  " | " +
                                                  paragraph.data[idx].date +
                                                  " | " +
                                                  paragraph.data[idx].from,
                                              style: TextStyle(fontSize: 12),
                                            ),
                                            trailing: InkWell(
                                              child: Icon(Icons.copy),
                                              onTap: () {
                                                Clipboard.setData(ClipboardData(
                                                    text: paragraph
                                                        .data[idx].reference));
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "참고문헌 텍스트가 클립보드에 복사되었습니다.",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.CENTER,
                                                    timeInSecForIosWeb: 1,
                                                    backgroundColor:
                                                        Colors.blue,
                                                    textColor: Colors.black,
                                                    fontSize: 16.0);
                                              },
                                            ),
                                          ),
                                        ));
                                      }).toList())
                                    ],
                                  ),
                                );
                              }));
                    }
                  }).toList(),
                )),
          );
        }),
      );
    });
  }
}
