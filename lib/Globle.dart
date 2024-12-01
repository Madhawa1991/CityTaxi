
class GlobalData {
  static GlobalData _instance = GlobalData._internal();

  bool loginStatus = false;

  factory GlobalData() => _instance;
  GlobalData._internal();

}