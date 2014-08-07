library element.app;

import 'dart:html';
import 'package:polymer/polymer.dart';
import '../model/clock.dart';

@CustomTag('clock-app')
class App extends PolymerElement {

  @published Clock creationClock = new Clock(Clock.PERIODS_STANDARD);
  @published List<Clock> clocks = toObservable([]);

  App.created() : super.created();

  void createClock(Event e, Map detail, Element sender) {
    clocks.add(new Clock.fromClock(creationClock));
  }

  void createClockFromTemplate(Event e, Map detail, Element sender) {
    clocks.add(new Clock(detail['template']));
  }

  void removeClock(Event e, Map detail, Element sender) {
    clocks.remove(detail['clockModel']);
  }

}