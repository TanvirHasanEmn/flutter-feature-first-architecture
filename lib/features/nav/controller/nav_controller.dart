import 'package:flutter_riverpod/flutter_riverpod.dart';

class NavController extends Notifier<int> {
  @override
  int build() => 0;

  void changePage(int index) {
    if (state != index) {
      state = index;
    }
  }
}

final navControllerProvider = NotifierProvider<NavController, int>(
  NavController.new,
);