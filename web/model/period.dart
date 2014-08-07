library model.period;

import 'package:polymer/polymer.dart';

class Period extends Observable {

  @published num value = 0;
  @published num intValue = 0;
  @published int max;

  Period([this.max = 10]);

  Period.fromPeriod(Period period) {
    max = period.max;
  }

  int incrementValue() => value = (value + 1) % max;

  String toString() => "value: $value, max: $max";

}
