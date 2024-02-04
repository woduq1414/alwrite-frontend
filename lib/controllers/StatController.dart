import 'package:alwrite/data/api.dart';
import 'package:alwrite/models/tableModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alwrite/models/statModel.dart';

class StatController extends GetxController {
  final GetConnect _getConnect = GetConnect(
    timeout: Duration(seconds: 60)
  );

  int currentPage = 0;

  List<StatModel> statList = [];

  List<TableModel> rowDatas = [];
  List<Map<String, dynamic>> rangeGptLogs = [];
  List<Map<String, dynamic>> editGptLogs = [];

  int selectedGraphTypeIndex = 0;

  int selectedGraphIndex = -1;

  bool isFetchingTable = false;

  int selectedStatIndex = -1;
  Future<void> started() async {
    print("@@@00");
    await getStatList();
  }

  Future<void> getStatList() async {
    statList = await fetchStatList();
    update();
  }

  Future<List<StatModel>> fetchStatList() async {
    print("@@@111");
    final response = await _getConnect.get(
      '${API_URL}/graph/stat/list',
    );

    if (response.statusCode == 200) {
      final List<StatModel> statList = [];
      for (var item in response.body["data"]) {
        statList.add(StatModel.fromJson(item));
      }
      return statList;
    } else {
      print(response.statusCode);
      return [];
    }
  }

  Future<void> rangePageStarted(String STATBL_ID) async {
    print('ff');
    await getRowList(STATBL_ID);
  }

  Future<void> getRowList(String STATBL_ID) async {
    rangeGptLogs = [];
    rowDatas = await fetchTable(STATBL_ID);
    isFetchingTable = false;
    update();
  }

  Future<List<TableModel>> fetchTable(String STATBL_ID) async {
    final response = await _getConnect.get(
      '${API_URL}/graph/stat/data?statbl_id=$STATBL_ID',
    );

    if (response.statusCode == 200) {
      final List<TableModel> rowDatas1 = [];
      for (var item in response.body["data"]) {
        rowDatas1.add(TableModel.fromJson(item));
      }

      return rowDatas1;
    } else {
      print(response.statusCode);
      return [];
    }
  }

  Future<void> getUpdatedRowList(String STATBL_ID, String prompt) async {
    rowDatas = await postGptRange(STATBL_ID, prompt);
    isFetchingTable = false;
    update();
  }

  Future<List<TableModel>> postGptRange(String STATBL_ID, String prompt) async {
    print(rangeGptLogs);
    final response = await _getConnect.post('${API_URL}/graph/stat/gpt/range', {
      "statbl_id": STATBL_ID,
      "prompt": prompt,
      "stat_data": rowDatas.map((e) => e.toJson()).toList()
    });

    if (response.statusCode == 200) {
      final List<TableModel> rowDatas1 = [];
      for (var item in response.body["data"]) {
        rowDatas1.add(TableModel.fromJson(item));
      }

      rangeGptLogs[rangeGptLogs.length - 1]["len"] = rowDatas1.length;
      print(rangeGptLogs);
      return rowDatas1;
    } else {
      print(response.statusCode);
      return [];
    }
  }

  Future<String> getEditedGraph(String STATBL_ID, String prompt) async {
    String result =
        await postGptEdit(STATBL_ID, prompt, selectedGraphTypeIndex);
    isFetchingTable = false;
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@");

    update();
    return result;
  }

  Future<String> postGptEdit(
      String STATBL_ID, String prompt, int selectedGraphTypeIndex) async {
    final response = await _getConnect.post('${API_URL}/graph/stat/gpt/edit', {
      "statbl_id": STATBL_ID,
      "prompt": prompt,
      "graph_type": selectedGraphTypeIndex,
      "stat_data": rowDatas.map((e) => e.toJson()).toList()
    });
    

    if (response.statusCode == 200) {
      print(response.body["time"]);
      editGptLogs[editGptLogs.length - 1]["data"] = response.body["data"];
      selectedGraphIndex = editGptLogs.length - 1;
      print(editGptLogs[editGptLogs.length - 1]["data"]);
      return response.body["data"];
    } else {
      print(response.statusCode);
      editGptLogs[editGptLogs.length - 1]["data"] = "err";
      return "";
    }
  }
}
