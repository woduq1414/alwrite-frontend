import 'dart:convert';
import 'dart:ui';

import 'package:alwrite/data/api.dart';
import 'package:alwrite/models/documentModel.dart';
import 'package:alwrite/models/lawModel.dart';
import 'package:alwrite/models/paragraphModel.dart';
import 'package:alwrite/models/tableModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alwrite/models/statModel.dart';

class DocumentController extends GetxController {
  final GetConnect _getConnect = GetConnect(timeout: Duration(seconds: 60));

  String targetString = "";

  bool isFetchingLaw = false;
  bool isFetchingDocument = false;


  List<ParagraphModel> lawParagraphList = [];
  
  List<ParagraphModel> documentParagraphList = [];

  Future<void> started() async {
    print("@@@00");

    if (targetString == "") {
      targetString = "안전";
    }
    getLawList();
    getDocumentList();
  }

  Future<void> getLawList() async {
    lawParagraphList = await fetchLawList();
    isFetchingLaw = false;
    update();
  }

  Future<List<ParagraphModel>> fetchLawList() async {
    print("@@@111");
    final response = await _getConnect
        .post('${API_URL}/document/similar_law', {'text': targetString});

    // final response = json.decode("""{"success":true,"paragraphs":[{"text":"통일","laws":[{"title":"통일교육 지원법","url":"https://www.law.go.kr/LSW/lsSc.do?query= 통일교육 지원법 "},{"title":"민주평화통일자문회의법","url":"https://www.law.go.kr/LSW/lsSc.do?query= 민주평화통일자문회의법 "},{"title":"무역조정 지원 등에 관한 법률","url":"https://www.law.go.kr/LSW/lsSc.do?query= 무역조정 지원 등에 관한 법률 "},{"title":"대체역의 편입 및 복무 등에 관한 법률","url":"https://www.law.go.kr/LSW/lsSc.do?query= 대체역의 편입 및 복무 등에 관한 법률 "},{"title":"국민투표법","url":"https://www.law.go.kr/LSW/lsSc.do?query= 국민투표법 "}]},{"text":"청소년","laws":[{"title":"청소년복지 지원법","url":"https://www.law.go.kr/LSW/lsSc.do?query= 청소년복지 지원법 "},{"title":"청소년활동 진흥법","url":"https://www.law.go.kr/LSW/lsSc.do?query= 청소년활동 진흥법 "},{"title":"학교 밖 청소년 지원에 관한 법률","url":"https://www.law.go.kr/LSW/lsSc.do?query= 학교 밖 청소년 지원에 관한 법률 "},{"title":"청소년 기본법","url":"https://www.law.go.kr/LSW/lsSc.do?query= 청소년 기본법 "},{"title":"청소년 보호법","url":"https://www.law.go.kr/LSW/lsSc.do?query= 청소년 보호법 "}]}]}""");

    if (response.statusCode == 200) {
      lawParagraphList = [];
      for (var item in response.body["paragraphs"]) {
        lawParagraphList.add(ParagraphModel.fromJson(item));
      }
      return lawParagraphList;
    } else {
      print(response.statusCode);
      return [];
    }
  }

  Future<void> getDocumentList() async {
    documentParagraphList = await fetchDocumentList();
    isFetchingDocument = false;
    update();
  }

  Future<List<ParagraphModel>> fetchDocumentList() async {
    print("@@@111");
    final response = await _getConnect
        .post('${API_URL}/document/similar_document', {'text': targetString});


    // final response = json.decode("""{"success":true,"paragraphs":[{"text":"통일","documents":[{"title":"통일교육의 쟁점과 과제:초등학교 학교교육을 중심으로","writer":"함규진","date":"2015","from":"국회입법조사처 학술지(입법과 정책)","url":"https://www.kci.go.kr/kciportal/landing/article.kci?arti_id=ART002002980","reference":"함규진 (2015). 통일교육의 쟁점과 과제:초등학교 학교교육을 중심으로. 입법과 정책. 7(1), 83-105."},{"title":"북한 급변사태 시 독일식 합의통일의 적용: 당위성과 과제 검토","writer":"박휘락","date":"2020","from":"국회입법조사처 학술지(입법과 정책)","url":"https://www.kci.go.kr/kciportal/landing/article.kci?arti_id=ART002617863","reference":"박휘락 (2020). 북한 급변사태 시 독일식 합의통일의 적용: 당위성과 과제 검토. 입법과 정책. 12(2), 119-144."},{"title":"통일의식조사를 통한 사회통일교육 활성화방안 연구: 전라북도 사례를 중심으로","writer":"오재록,윤향미","date":"2015","from":"국회입법조사처 학술지(입법과 정책)","url":"https://www.kci.go.kr/kciportal/landing/article.kci?arti_id=ART002003073","reference":"오재록,윤향미 (2015). 통일의식조사를 통한 사회통일교육 활성화방안 연구: 전라북도 사례를 중심으로. 입법과 정책. 7(1), 107-129."},{"title":"미일 안보협의위원회(2+2) 주요 내용과 시사점","writer":"박명희","date":"2021-04-08","from":"국회입법조사처 연구보고서 (이슈와논점)","url":"https://www.nars.go.kr/report/view.do?page=1&cmsCode=CM0018&categoryId=&searchType=TITLE&searchKeyword=&brdSeq=34240","reference":"박명희 (2021). 미일 안보협의위원회(2+2) 주요 내용과 시사점. 국회입법조사처 연구보고서 (이슈와논점)."},{"title":"일본 국회 ICT 활용 논의와 시사점","writer":"김유정","date":"2020-12-30","from":"국회입법조사처 연구보고서 (이슈와논점)","url":"https://www.nars.go.kr/report/view.do?page=1&cmsCode=CM0018&categoryId=&searchType=TITLE&searchKeyword=&brdSeq=32919","reference":"김유정 (2020). 일본 국회 ICT 활용 논의와 시사점. 국회입법조사처 연구보고서 (이슈와논점)."}]},{"text":"청소년","documents":[{"title":"청소년 가출과 자살위험 - 정책적 함의","writer":"김준홍","date":"2012","from":"국회입법조사처 학술지(입법과 정책)","url":"https://www.kci.go.kr/kciportal/landing/article.kci?arti_id=ART001972640","reference":"김준홍 (2012). 청소년 가출과 자살위험 - 정책적 함의. 입법과 정책. 4(2), 111-134."},{"title":"청년이 미래다","writer":"지성호","date":"2022-12-22","from":"국회미래연구원 미래칼럼","url":"https://nafi.re.kr/new/contribution.do?mode=view&articleNo=4074&article.offset=0&articleLimit=10","reference":"지성호 (2022). 청년이 미래다. 국회미래연구원 미래칼럼."},{"title":"청소년 사이버 폭력 발생 구조 분석을 통한 지능정보사회의 사이버 위기관리 방안에 관한 연구","writer":"진상기","date":"2018","from":"국회입법조사처 학술지(입법과 정책)","url":"https://www.kci.go.kr/kciportal/landing/article.kci?arti_id=ART002376940","reference":"진상기 (2018). 청소년 사이버 폭력 발생 구조 분석을 통한 지능정보사회의 사이버 위기관리 방안에 관한 연구. 입법과 정책. 10(2), 451-478."},{"title":"'실패해도 괜찮아' 지속 가능한 청년문화예술을 위해","writer":"유정주","date":"2022-02-23","from":"국회미래연구원 미래칼럼","url":"https://www.nafi.re.kr/new/contribution.do?mode=view&articleNo=3138&article.offset=0&articleLimit=10","reference":"유정주 (2022). '실패해도 괜찮아' 지속 가능한 청년문화예술을 위해. 국회미래연구원 미래칼럼."},{"title":"청소년마약류사범의 효과적인 재범예방을 위한실증분석: 서울지방경찰청 과학수사관을 중심으로","writer":"김태우,유수동,한형서","date":"2020","from":"국회입법조사처 학술지(입법과 정책)","url":"https://www.kci.go.kr/kciportal/landing/article.kci?arti_id=ART002617869","reference":"김태우,유수동,한형서 (2020). 청소년마약류사범의 효과적인 재범예방을 위한실증분석: 서울지방경찰청 과학수사관을 중심으로. 입법과 정책. 12(2), 317-338."}]}]}""");

    if (response.statusCode == 200) {
      documentParagraphList = [];
      for (var item in response.body["paragraphs"]) {
        documentParagraphList.add(ParagraphModel.fromJson(item));
      }
      return documentParagraphList;
    } else {
      print(response.statusCode);
      return [];
    }
  }
}
