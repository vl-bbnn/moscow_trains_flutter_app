import 'dart:async';
import 'package:rxdart/rxdart.dart';

enum BackPanelType { search, settings, user, results, hello, thread }

class UIBloc {
  UIBloc() {
    backPanelTypeSink.add(BackPanelType.search);
    frontPanelOpenStream.listen((newValue) => _frontPanelOpen = newValue);
  }

  toggleFrontPanel() {
    frontPanelOpenSink.add(!_frontPanelOpen);
  }

  final _backPanelTypeController = BehaviorSubject<BackPanelType>();
  Sink<BackPanelType> get backPanelTypeSink => _backPanelTypeController.sink;
  Stream<BackPanelType> get backPanelTypeStream =>
      _backPanelTypeController.stream.asBroadcastStream();

  bool _frontPanelOpen = false;
  final _frontPanelOpenController = BehaviorSubject<bool>();
  Sink<bool> get frontPanelOpenSink => _frontPanelOpenController.sink;
  Stream<bool> get frontPanelOpenStream =>
      _frontPanelOpenController.stream.asBroadcastStream();

  close() {
    _backPanelTypeController.close();
    _frontPanelOpenController.close();
  }
}
