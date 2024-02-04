class StatModel {
  final String? CATE_FULLNM;
  final String STATBL_ID;
  final String  STATBL_NM;
  final String?               DTACYCLE_NM;
  final String?                TOP_ORG_NM;
  final String?                ORG_NM;
  final String?                USR_NM;
  final String?                 LOAD_DATE;
  final String?                 OPEN_DATE;
  final String?                DATA_START_YY;
  final String?                DATA_END_YY;
  final String?                 STATBL_CMMT;
  final String?                 SRV_URL;


  StatModel({
    required this.CATE_FULLNM,
    required this.STATBL_ID,
    required this.STATBL_NM,
    required this.DTACYCLE_NM,
    required this.TOP_ORG_NM,
    required this.ORG_NM,
    required this.USR_NM,
    required this.LOAD_DATE,
    required this.OPEN_DATE,
    required this.DATA_START_YY,
    required this.DATA_END_YY,
    required this.STATBL_CMMT,
    required this.SRV_URL,
  });
  

  StatModel.fromJson(Map<String, dynamic> json)
      : CATE_FULLNM = json['CATE_FULLNM'],
        STATBL_ID = json['STATBL_ID'],
        STATBL_NM = json['STATBL_NM'],
        DTACYCLE_NM = json['DTACYCLE_NM'],
        TOP_ORG_NM = json['TOP_ORG_NM'],
        ORG_NM = json['ORG_NM'],
        USR_NM = json['USR_NM'],
        LOAD_DATE = json['LOAD_DATE'],
        OPEN_DATE = json['OPEN_DATE'],
        DATA_START_YY = json['DATA_START_YY'],
        DATA_END_YY = json['DATA_END_YY'],
        STATBL_CMMT = json['STATBL_CMMT'],
        SRV_URL = json['SRV_URL'];
}