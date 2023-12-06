import 'sqlite.dart';

class BMICalculator{

  static const String _tblName = "bmi";

  String username ;
  double weight ;
  double height ;
  String gender ;
  String status ;

  BMICalculator(this.username, this.weight, this.height, this.gender, this.status);

  BMICalculator.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        height = json['height'] as double,
        weight = json['weight'] as double,
        gender = json['gender'] as String,
        status = json['status'] as String;

  Map<String, dynamic> toJson() => {'username': username, 'height': height, 'weight': weight, 'gender': gender, 'status': status};

  Future<bool> save() async {
    return await sqlite().insert(_tblName, toJson()) != 0;
  }

  static Future<List<BMICalculator>> loadAll() async {
    List<BMICalculator> result = [];

    List<Map<String, dynamic>> localResult = await sqlite().queryAll(_tblName);
    for (var item in localResult) {
      result.add(BMICalculator.fromJson(item));
    }

    return result;
  }
}