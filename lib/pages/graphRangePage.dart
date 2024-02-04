import 'package:alwrite/controllers/StatController.dart';
import 'package:alwrite/models/statModel.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

class GraphRangePage extends StatelessWidget {
  const GraphRangePage({super.key});

  @override
  Widget build(BuildContext context) {
    // StatController statController = Get.find();

    // get current position of GoRouter
    final route = ModalRoute.of(context);

    final statController = Get.put(StatController());

    if (statController.currentPage != 1 && statController.currentPage != 3) {
      return Container();
    }
    TextEditingController textarea = TextEditingController();

    if (statController.currentPage == 1) {
      statController.rowDatas = [];
      statController.isFetchingTable = true;
      statController.rangePageStarted(
          statController.statList[statController.selectedStatIndex].STATBL_ID);
    }

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
            title: Text("통계 데이터 확인(${selectedStat!.STATBL_NM})"),
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back),
                onPressed: () {
                  controller.currentPage = 0;
                  Navigator.of(context).pop();
                }),
          ),
          body: Row(children: [
            Container(
                width: 800,
                child: controller.isFetchingTable
                    ? Container(
                        width: 250,
                        height: 250,
                        child: SpinKitSquareCircle(
                          color: Colors.blue,
                          size: 100.0,
                        ))
                    : controller.rowDatas.length == 0
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
                                            ? MaterialStateColor.resolveWith(
                                                (states) => Colors.grey[200]!)
                                            : MaterialStateColor.resolveWith(
                                                (states) => Colors.white),
                                        cells: [
                                          DataCell(Text(data.year.toString())),
                                          DataCell(Text(data.name.toString())),
                                          DataCell(Text(data.value.toString())),
                                          DataCell(Text(data.unit.toString())),
                                        ]))
                                .toList())),
            Expanded(
                child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "그래프에 사용할 데이터 선택",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      InkWell(
                          onTap: () {
                            textarea.text = "";
                            controller.isFetchingTable = true;
                            controller.update();
                            controller.getRowList(selectedStat.STATBL_ID);
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
                  Container(
                    width: double.infinity,
                    child: TextField(
                      controller: textarea,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      decoration: InputDecoration(
                          hintText: "예 : 2014~2017년 사이의 항목이 '합계'인 데이터를 뽑아줘",
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
                        controller.rangeGptLogs
                            .add({"prompt": textarea.text, "len": -1});
                        controller.update();
                        controller.getUpdatedRowList(
                            selectedStat.STATBL_ID, textarea.text);
                        textarea.text = "";
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
                      children: controller.rangeGptLogs
                          .map(
                            (e) => Card(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 13),
                                child: Row(children: [
                                  e["len"] >= 0
                                      ? Icon(
                                          Icons.check_circle,
                                          color: Colors.blue,
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
                                  e["len"] >= 0
                                      ? Text(
                                          e["len"].toString() + " 행",
                                          style: TextStyle(
                                              fontSize: 14, color: Colors.grey),
                                        )
                                      : Container()
                                ]),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.currentPage = 2;
                        GoRouter.of(context).go("/graph/range/edit");
                      },
                      child: Text(
                        "다음",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ))
          ]));
    });
  }
}
