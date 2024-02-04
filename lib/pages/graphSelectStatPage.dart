import 'package:alwrite/controllers/StatController.dart';
import 'package:alwrite/models/statModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

class GraphSelectStatPage extends StatelessWidget {
  const GraphSelectStatPage({super.key});

  @override
  Widget build(BuildContext context) {
    final statController = Get.put(StatController());

    // if (statController.currentPage != 0) {
    //   return Container();
    // }

    statController.started();
    return GetBuilder<StatController>(builder: (controller) {
      StatModel? selectedStat = controller.selectedStatIndex == -1
          ? null
          : controller.statList[controller.selectedStatIndex];

      return Scaffold(
          appBar: AppBar(title: Text("사용할 통계 선택")),
          body: Row(
            children: [
              Container(
                width: 350,
                child: ListView.builder(
                    itemCount: controller.statList.length,
                    itemBuilder: ((context, index) {
                      return Card(
                          child: InkWell(
                        onTap: () {
                          controller.selectedStatIndex = index;
                          controller.update();
                        },
                        child: ListTile(
                            title: Text(controller.statList[index].STATBL_NM)),
                      ));
                    })),
              ),
              selectedStat == null
                  ? Container()
                  : Expanded(
                      child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.only(bottom: 6),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selectedStat.STATBL_NM,
                            style: TextStyle(
                                fontSize: 35, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          StatDetailRow(
                              label: "분류", value: selectedStat.CATE_FULLNM),
                          StatDetailRow(
                              label: "관련 부서", value: selectedStat.TOP_ORG_NM),
                          StatDetailRow(
                              label: "정보 공개 시작일",
                              value: selectedStat.OPEN_DATE),
                          StatDetailRow(
                              label: "정보 갱신일", value: selectedStat.LOAD_DATE),
                          selectedStat.DATA_START_YY != null &&
                                  selectedStat.DATA_END_YY != null
                              ? StatDetailRow(
                                  label: "정보 보유 기간",
                                  value:
                                      "${selectedStat.DATA_START_YY} ~ ${selectedStat.DATA_END_YY}")
                              : Container(),
                          StatDetailRow(
                              label: "통계 설명", value: selectedStat.STATBL_CMMT),
                          StatDetailRow(
                              label: "URL", value: selectedStat.SRV_URL),
                          Spacer(),
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.currentPage = 1;
                                GoRouter.of(context).go("/graph/range");
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
            ],
          ));
    });
  }
}

class StatDetailRow extends StatelessWidget {
  const StatDetailRow({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null) return Container();
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            decoration: BoxDecoration(
                border: Border(
                    right: BorderSide(
                        color: Color.fromARGB(255, 255, 160, 160), width: 2))),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 20,
              ), // 0~9
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              value!,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
