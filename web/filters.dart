library filters;

import 'package:polymer_expressions/filter.dart';

class StringToInt extends Transformer<String, int> {
  String forward(int i) => '$i';
  int reverse(String str) {
    try {
      return int.parse(str);
    }
    catch (e) {
      return 0;
    }
  }

}
