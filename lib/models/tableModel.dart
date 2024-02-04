class TableModel {
  final int year;
  final String name;
  final String unit;
  final double value;

  TableModel({
    required this.year,
    required this.name,
    required this.unit,
    required this.value,
  });

  TableModel.fromJson(Map<String, dynamic> json)
      : year = int.parse(json['WRTTIME_IDTFR_ID']),
        name = json['ITM_NM'],
        unit = json['UI_NM'],
        value = json['DTA_VAL'];


  // toJSon
  Map<String, dynamic> toJson() => {
        'year': year,
        'name': name,
        'unit': unit,
        'value': value,
      };
}