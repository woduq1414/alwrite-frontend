import 'package:alwrite/controllers/DocumentController.dart';
import 'package:alwrite/controllers/StatController.dart';
import 'package:alwrite/models/statModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher_web/url_launcher_web.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';


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
                              itemCount: controller.lawList.length,
                              itemBuilder: ((context, index) {
                                Uri _url =
                                    Uri.parse(controller.lawList[index].url);
                                return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(5),
                                      onTap: () {
                                        launchUrl(_url);
                                      },
                                      child: ListTile(
                                        title: Text(
                                            controller.lawList[index].title),
                                        trailing: Icon(Icons.chevron_right),
                                      ),
                                    ));
                              }));
                    } else {
                      return controller.isFetchingDocument
                          ? SpinKitSquareCircle(
                              color: Colors.blue,
                              size: 100.0,
                            )
                          : ListView.builder(
                              itemCount: controller.documentList.length,
                              itemBuilder: ((context, index) {
                                Uri _url =
                                    Uri.parse(controller.lawList[index].url);
                                return Card(
                                    child: InkWell(
                                  onTap: () {
                                    launchUrl(_url);
                                  },
                                  child: ListTile(
                                    title: Text(
                                        controller.documentList[index].title),
                                    subtitle: Text(
                                      controller.documentList[index].writer +
                                          " | " +
                                          controller.documentList[index].date +
                                          " | " +
                                          controller.documentList[index].from,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    trailing: InkWell(
                                      child: Icon(Icons.copy),
                                      onTap: () {
                                        Clipboard.setData(ClipboardData(text: controller.documentList[index].reference));
                                      },
                                    ),
                                  ),
                                ));
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
