library element.period;

import 'dart:html';
import 'dart:math';
import 'package:polymer/polymer.dart';
import '../model/period.dart' as Model;
import '../filters.dart';

@CustomTag('clock-period')
class Period extends PolymerElement {

  @published Model.Period model = new Model.Period();
  @published bool editing = false;
  @published int index;
  @published String separator = ":";
  final StringToInt asInt = new StringToInt();

  Period.created() : super.created();

  void removePeriod(Event e, var detail, Element sender) {
    fire('removeperiod', detail: {
        'periodModel': model
    }, onNode: sender);
  }

  String leftPad(value) {
    int width = (log(model.max) / log(10)).ceil();

    return value.toString().padLeft(width, '0');
  }

}