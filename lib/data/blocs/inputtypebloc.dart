import 'package:rxdart/rxdart.dart';

enum Input { departure, arrival }

class InputTypeBloc {
  InputTypeBloc() {
    type.add(Input.departure);
  }

  switchTypes() {
    switch (type.value) {
      case Input.departure:
        type.add(Input.arrival);
        break;
      case Input.arrival:
        type.add(Input.departure);
        break;
    }
  }

  final type = BehaviorSubject<Input>();

  close() {
    type.close();
  }
}
