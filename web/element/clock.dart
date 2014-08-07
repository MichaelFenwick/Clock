library element.clock;

import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';
import '../model/clock.dart' as Model;
import 'clock-canvas.dart';

@CustomTag('clock-clock')
class Clock extends PolymerElement {

  @published Model.Clock model = new Model.Clock();
  @published bool editing = false;
  @published bool running = true;
  @published bool showDefaultSchemes = false;

  @published Map<String, List> get defaultSchemes => toObservable(Model.Clock.defaultSchemes);

  @published String saveButtonLabel = "Save";
  @published Function saveButtonAction;
  @published StreamController tickStreamController;

  @published Stream get tickStream => (tickStreamController is StreamController)
                                      ? tickStreamController.stream : null;

  StreamSubscription _tickSubscription;

  Clock.created() : super.created() {
    void tick() {
      window.animationFrame.then((timestamp) {
        if (running && !editing) {
          tickStreamController.add(new CustomEvent('tick', detail: timestamp));
        }
        tick();
      });
    }

    saveButtonAction = saveButtonAction is Function ? saveButtonAction : save;

    tickStreamController = new StreamController.broadcast(
        onListen: tick,
        onCancel: () => running = false,
        sync: true
        );
  }

  void attached() {
    _tickSubscription = tickStream.listen((Event e) {
      model.updatePeriodValues();
    });
  }

  void detached() {
    _tickSubscription.cancel();
    tickStreamController.close();
  }

  void removeClock(Event e, var detail, Element sender) {
    fire('removeclock', detail: {
        'clockModel': model
    }, onNode: sender);
  }

  void addPeriod(Event e, Object detail, Element sender) {
    model.addPeriod();
  }

  void removePeriod(Event e, Map detail, Element sender) {
    model.removePeriod(detail['periodModel']);
  }

  void setScheme(Event e, Map detail, Element sender) {
    model.periods.clear();
    model.periods.addAll(Model.Clock.defaultSchemes[sender.dataset['scheme']]);
  }

  void save(Event e, Object detail, Element sender) {
    editing = false;
  }

  void edit(Event e, Object detail, Element sender) {
    editing = true;
  }

}
