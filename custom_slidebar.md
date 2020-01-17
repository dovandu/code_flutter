```dart
CustomPaint(
  painter: CustomPaintSlider(
      startPoints: startPoints, endPoints: endPoints, progress: _progress),
  child: SliderTheme(
    data: SliderTheme.of(context).copyWith(
      activeTrackColor: Colors.transparent,
      inactiveTrackColor: Colors.transparent,
      thumbColor: Colors.transparent,
      trackShape: CustomTrackShape(),
    ),
    child: Slider(
      value: _progress,
      onChanged: (progress) {
      },
    ),
  ),
);
class CustomPaintSlider extends CustomPainter {
  final List<Offset> startPoints;
  final List<Offset> endPoints;
  final double progress;
  CustomPaintSlider({this.startPoints, this.endPoints, this.progress: 0});
  @override
  void paint(Canvas canvas, Size size) {
    Paint activePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    Paint inactivePaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    int pointsActive = (startPoints.length * progress).round();
    for (int i = 0; i < startPoints.length; i++) {
      if (i <= pointsActive) {
        canvas.drawLine(startPoints[i], endPoints[i], activePaint);
      } else {
        canvas.drawLine(startPoints[i], endPoints[i], inactivePaint);
      }
    }
  }
  @override
  bool shouldRepaint(CustomPaintSlider oldDelegate) {
    return oldDelegate.progress != this.progress;
  }
}
```
