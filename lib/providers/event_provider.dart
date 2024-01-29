
import 'dart:collection';

import 'package:flutter/cupertino.dart';

import '../entity/event.dart';

class EventProvider extends ChangeNotifier {

  final List<Event> _events = [];

  UnmodifiableListView<Event> get events => UnmodifiableListView(_events);

  void addEvent(Event event) {
    _events.add(event);
    notifyListeners();
  }

  void deleteEvent(Event event) {
    _events.remove(event);
    notifyListeners();
  }

  void updateEvent(Event event) {
    int index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
      notifyListeners();
    }
  }



}