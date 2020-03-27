
import 'dart:async';

class SettingsBloc {
  double sliderValue = 15.0;
  bool hotValue = false;
  bool twiceValue = false;

  final _outputSlider = StreamController.broadcast();
  final _outputHot = StreamController.broadcast();
  final _outputTwice = StreamController.broadcast();

  Stream get sliderChange => _outputSlider.stream;
  Stream get hotChange => _outputSlider.stream;
  Stream get twiceChange => _outputSlider.stream;

  void onSliderChanged(double value) {
    sliderValue = value;
    _outputSlider.sink.add(null);
  }

  void onHotChanged(bool value) {
    hotValue = value;
    _outputSlider.sink.add(null);
  }

  void onTwiceChanged(bool value) {
    twiceValue = value;
    _outputSlider.sink.add(null);
  }
}