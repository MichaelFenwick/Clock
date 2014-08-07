library model.clock;

import 'period.dart';
import 'package:polymer/polymer.dart';

class Clock extends Observable {

  @observable List<Period> periods = toObservable([]);
  @published bool ticking = false;
  static final Map<String, List<Period>> defaultSchemes = {
      'Standard': PERIODS_STANDARD,
      'Binary': PERIODS_BINARY,
      'Decimal': PERIODS_DECIMAL,
      'Hex': PERIODS_HEX
  };

  static final List<Period> PERIODS_STANDARD = [
    new Period(24),
    new Period(60),
    new Period(60),
  ];

  static final List<Period> PERIODS_BINARY = [
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
    new Period(2),
  ];

  static final List<Period> PERIODS_DECIMAL = [
    new Period(10),
    new Period(100),
    new Period(100),
  ];

  static final List<Period> PERIODS_HEX = [
    new Period(16),
    new Period(16),
    new Period(16),
    new Period(16),
  ];

  Clock([List<Period> periods]) {
    if (periods is List<Period>) {
      this.periods = toObservable(periods);
    }
  }

  Clock.fromClock(Clock clock) {
    clock.periods.forEach((period) {
      periods.add(new Period.fromPeriod(period));
    });
    ticking = clock.ticking;
  }

  void addPeriod([Period period]) {
    periods.add(period is Period ? period : new Period());
  }

  void removePeriod(Period period) {
    periods.remove(period);
  }

  void updatePeriodValues() {
    int ticksPerDay = periods.fold(1, (value, period) => value * period.max);
    int currentTime = getTimeAsTickCount(ticksPerDay);

    for (int i = 0; i < periods.length; i++) {
      int ticksPerPeriod = periods.getRange(i+1, periods.length).fold(1, (value, period) => value * period.max);
      periods[i].value = (currentTime * 1000) / (ticksPerPeriod * 1000) % periods[i].max;
      periods[i].intValue = (currentTime * 1000) ~/ (ticksPerPeriod * 1000) % periods[i].max;
    }
  }

  num getTimeAsTickCount(int ticksPerDay) {
    DateTime now = new DateTime.now();
    return ((now.millisecond / 1000 + now.second + 60 * now.minute + 3600 * now.hour) / 86400 * ticksPerDay);
  }

  String toString() {
    StringBuffer stringBuffer = new StringBuffer();
    stringBuffer.write("Clock:\n  ");
    stringBuffer.writeAll(periods, '\n  ');
    return stringBuffer.toString();
  }

}
