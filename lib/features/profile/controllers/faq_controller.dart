import 'package:flutter_riverpod/flutter_riverpod.dart';

class FaqController extends Notifier<int> {
  @override
  int build() => -1; // -1 means all items collapsed

  void toggleFaq(int index) {
    state = (state == index) ? -1 : index;
  }
}

final faqControllerProvider = NotifierProvider<FaqController, int>(
  FaqController.new,
);