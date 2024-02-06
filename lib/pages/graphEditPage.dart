import 'dart:convert';

import 'package:alwrite/controllers/StatController.dart';
import 'package:alwrite/data/api.dart';
import 'package:alwrite/models/statModel.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:collection/collection.dart';
import 'package:web_image_downloader/web_image_downloader.dart';

class GraphEditPage extends StatelessWidget {
  GraphEditPage({super.key});

  final imageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // StatController statController = Get.find();
    final statController = Get.put(StatController());
    TextEditingController textarea = TextEditingController();

    statController.editGptLogs = [];
    statController.selectedGraphIndex = -1;

    return GetBuilder<StatController>(builder: (controller) {
      StatModel? selectedStat = controller.selectedStatIndex == -1
          ? null
          : controller.statList[controller.selectedStatIndex];

      if (selectedStat == null) {
        return Container();
      }
      // print(statController.rowDatas.length + 10000);
      return Scaffold(
          // floatingActionButton: FloatingActionButton(
          //   onPressed: () {
          //     statController.rangePageStarted("T186213000251988");
          //   },
          //   child: Icon(Icons.arrow_back),
          // ),
          appBar: AppBar(
            title: Text("그래프 그리기(${selectedStat!.STATBL_NM})"),
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  controller.currentPage = 3;
                  Navigator.of(context).pop();
                }),
          ),
          body: Row(children: [
            Container(
                width: 800,
                child: Column(
                  children: [
                    Container(
                        height: 550,
                        child: controller.isFetchingTable
                            ? Container(
                                width: 250,
                                height: 250,
                                child: SpinKitSquareCircle(
                                  color: Colors.blue,
                                  size: 100.0,
                                ))
                            : controller.editGptLogs.length != 0 &&
                                    controller.selectedGraphIndex != -1 &&
                                    controller.editGptLogs[controller
                                            .selectedGraphIndex]["data"] !=
                                        null &&
                                    controller.editGptLogs[controller
                                            .selectedGraphIndex]["data"] !=
                                        "err"
                                ? Column(children: [
                                    Expanded(
                                      child: Container(
                                        child: RepaintBoundary(
                                          key: imageKey,
                                          child: Image.network(
                                              "${API_URL}/graph/download/photo/" +
                                                  controller.editGptLogs[
                                                          controller
                                                              .selectedGraphIndex]
                                                      ["data"]),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          WebImageDownloader.downloadImage(
                                              imageKey, "${selectedStat!.STATBL_NM}.png");
                                        },
                                        child: Text(
                                          "저장",
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                    )
                                  ])
                                : Center(
                                    child: Text(
                                    "그래프를 만들어주세요.",
                                    style: TextStyle(fontSize: 20),
                                  ))),
                    Expanded(
                        child: controller.rowDatas.length == 0
                            ? Center(
                                child: Text(
                                "만족하는 데이터가 없습니다.",
                                style: TextStyle(fontSize: 20),
                              ))
                            : DataTable2(
                                columnSpacing: 12,
                                horizontalMargin: 12,
                                minWidth: 600,
                                columns: [
                                  DataColumn(
                                    label: Text('연도'),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text('항목'),
                                  ),
                                  DataColumn(
                                    label: Text('값'),
                                    numeric: true,
                                  ),
                                  DataColumn(
                                    label: Text('단위'),
                                  ),
                                ],
                                rows: controller.rowDatas
                                    .mapIndexed((index, data) => DataRow2(
                                            color: index % 2 == 0
                                                ? MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.grey[200]!)
                                                : MaterialStateColor
                                                    .resolveWith((states) =>
                                                        Colors.white),
                                            cells: [
                                              DataCell(
                                                  Text(data.year.toString())),
                                              DataCell(
                                                  Text(data.name.toString())),
                                              DataCell(
                                                  Text(data.value.toString())),
                                              DataCell(
                                                  Text(data.unit.toString())),
                                            ]))
                                    .toList()))
                  ],
                )),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "그래프 그리기",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            textarea.text = "";
                            controller.editGptLogs = [];
                            controller.selectedGraphIndex = -1;
                            controller.update();
                          },
                          child: Icon(
                            Icons.refresh,
                            size: 30,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        "그래프 종류 선택 :",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SegmentedButton<int>(
                          segments: [
                            ButtonSegment(
                                value: 0,
                                label: Text("막대 그래프"),
                                icon: Icon(Icons.bar_chart)),
                            ButtonSegment(
                                value: 1,
                                label: Text("꺾은선 그래프"),
                                icon: Icon(Icons.insights)),
                            ButtonSegment(
                                value: 2,
                                label: Text("원 그래프"),
                                icon: Icon(Icons.pie_chart)),
                            // SegmentedButton(segments: ["막대 그래프", "꺾은선 그래프", "원 그래프", "히트맵"]
                          ],
                          selected: <int>{
                            controller.selectedGraphTypeIndex
                          },
                          onSelectionChanged: (index) {
                            controller.selectedGraphTypeIndex = index.first;
                            controller.update();
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: double.infinity,
                    child: TextField(
                      controller: textarea,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: InputDecoration(
                          hintText:
                              "예 : 연도를 x축으로, 값을 y축으로 하는 막대 그래프를 그려줘. 가장 높은 막대는 빨간색으로, 나머지 막대는 회색으로 칠해.",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: Colors.grey[300]!))),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.isFetchingTable = true;
                        controller.editGptLogs
                            .add({"prompt": textarea.text, "data": null});
                        // print(controller.editGptLogs);
                        controller.update();
                        controller.getEditedGraph(
                            selectedStat.STATBL_ID, textarea.text);
                        // textarea.text = "";
                      },
                      child: Text(
                        "제출",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView(
                      children: controller.editGptLogs
                          .map(
                            (e) => Card(
                              color: controller.selectedGraphIndex ==
                                      controller.editGptLogs.indexOf(e)
                                  ? Colors.grey[200]
                                  : Colors.white,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 13),
                                child: Row(children: [
                                  e["data"] != null
                                      ? e["data"] != "err"
                                          ? Icon(
                                              Icons.check_circle,
                                              color: Colors.blue,
                                              size: 25,
                                            )
                                          : Icon(
                                              Icons.close,
                                              color: Colors.redAccent,
                                              size: 25,
                                            )
                                      : SpinKitThreeBounce(
                                          color: Colors.grey,
                                          size: 15,
                                        ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      e["prompt"],
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                  e["data"] != null && e["data"] != "err"
                                      ? InkWell(
                                          onTap: () {
                                            controller.selectedGraphIndex =
                                                controller.editGptLogs
                                                    .indexOf(e);
                                            controller.update();
                                          },
                                          child: Icon(
                                            Icons.image,
                                            color: Colors.grey,
                                            size: 25,
                                          ),
                                        )
                                      : Container()
                                ]),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ))
          ]));
    });
  }
}
