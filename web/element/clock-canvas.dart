library element.clockCanvas;

import 'dart:html';
import 'dart:math';
import 'dart:async';
import '../model/clock.dart';
import '../model/period.dart';
import 'package:polymer/polymer.dart';

@CustomTag('clock-canvas')
class ClockCanvas extends PolymerElement {

  CanvasElement canvas;
  CanvasRenderingContext2D canvasContext;
  @published Clock clock;
  @published int width;
  @published int height;
  @published Stream tickStream;
  @published bool sweeping = true;
  StreamSubscription _tickSubscription;
  Point center;
  num radius;
  num tickLength;
  final int margin = 5;

  ClockCanvas.created() : super.created();

  void attached() {
    canvasContext = (shadowRoot.querySelector('canvas') as CanvasElement).context2D;

    _tickSubscription = tickStream.listen((Event e) {
      render();
    });
  }

  void detached() {
    _tickSubscription.cancel();
  }

  widthChanged(oldValue) {
    refreshCenter();
    refreshRadius();
    refreshTickLength();
  }

  heightChanged(oldValue) {
    refreshCenter();
    refreshRadius();
    refreshTickLength();
  }

  Point refreshCenter() => center = new Point(width / 2, height / 2);

  num refreshRadius() => radius = min(width, height) / 2 - margin;

  num refreshTickLength() => tickLength = radius / 10;

  void render() {
    canvasContext.clearRect(0, 0, width, height);
    _drawMajorTicks();
    if (clock.periods[1].max % clock.periods[0].max == 0
        && clock.periods[0].max < clock.periods[1].max) {
      _drawMinorTicks();
    }
    _drawHands();
    _drawClockFace();
  }

  void _drawClockFace() {
    canvasContext
      ..setStrokeColorRgb(0, 0, 0)
      ..lineWidth = 2
      ..beginPath()
      ..arc(center.x, center.y, radius, 0, 2 * PI)
      ..stroke()
      ..beginPath()
      ..arc(center.x, center.y, clock.periods.length * 2, 0, 2 * PI)
      ..fill();
  }

  void _drawMajorTicks() {
    num tickLength = radius / 10;
    for (int i = 0; i < clock.periods[0].max; i++) {
      num tickAngle = i / clock.periods[0].max * 2 * PI - PI / 2;

      Point edgePoint = new Point(
          center.x + radius * cos(tickAngle),
          center.y + radius * sin(tickAngle)
          );
      Point insidePoint = new Point(
          center.x + (radius - tickLength) * cos(tickAngle),
          center.y + (radius - tickLength) * sin(tickAngle)
          );

      canvasContext
        ..setStrokeColorRgb(0, 0, 0)
        ..lineWidth = 4
        ..beginPath()
        ..moveTo(edgePoint.x, edgePoint.y)
        ..lineTo(insidePoint.x, insidePoint.y)
        ..stroke();
    }
  }

  void _drawMinorTicks() {

    for (int i = 0; i < clock.periods[1].max; i++) {
      num tickAngle = i / clock.periods[1].max * 2 * PI - PI / 2;

      Point edgePoint = new Point(
          center.x + radius * cos(tickAngle),
          center.y + radius * sin(tickAngle)
          );
      Point insidePoint = new Point(
          center.x + (radius - tickLength) * cos(tickAngle),
          center.y + (radius - tickLength) * sin(tickAngle)
          );

      canvasContext
        ..setStrokeColorRgb(0, 0, 0)
        ..lineWidth = 1
        ..beginPath()
        ..moveTo(edgePoint.x, edgePoint.y)
        ..lineTo(insidePoint.x, insidePoint.y)
        ..stroke();
    }
  }

  void _drawHands() {
    for (int i = clock.periods.length - 1; i > 0; i--) {
      Period period = clock.periods[i];
      num value = clock.ticking ? period.intValue : period.value;
      num handAngle = value / period.max * 2 * PI - PI / 2;
      num handLength = (((i + 1) / (clock.periods.length)) + 0.85) * radius / 2;
      num handWidth = (clock.periods.length - i) * 2;
      Point handEdge = new Point(
          center.x + handLength * cos(handAngle),
          center.y + handLength * sin(handAngle)
          );

      canvasContext
        ..setStrokeColorRgb(255, 255, 255)
        ..lineWidth = handWidth + 2
        ..beginPath()
        ..moveTo(center.x, center.y)
        ..lineTo(handEdge.x, handEdge.y)
        ..stroke()
        ..setStrokeColorRgb(0, 0, 0)
        ..lineWidth = handWidth
        ..beginPath()
        ..moveTo(center.x, center.y)
        ..lineTo(handEdge.x, handEdge.y)
        ..stroke();
    }
  }

}
