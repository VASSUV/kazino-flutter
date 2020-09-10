import 'dart:async';

import 'package:moneywheel/domain/Counter.dart';

class MainBloc {
  // ignore: close_sinks
  final output = StreamController.broadcast();

  void onTap(int position) {
    Counter.shared.add(position);
    output.sink.add(null);
  }

  void undo() {
    Counter.shared.back();
    output.sink.add(null);
  }

  void clean() {
    Counter.shared.clean();
    output.sink.add(null);
  }
}