import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'filter_state.dart';

class FilterController extends Notifier<FilterState> {
  @override
  FilterState build() => const FilterState();

  void updateLocation(String location) {
    state = state.copyWith(selectedLocation: location);
  }

  void updatePostalCode(String postalCode) {
    state = state.copyWith(postalCode: postalCode);
  }

  void selectCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void toggleRating(int rating) {
    final ratings = List<int>.from(state.selectedRatings);
    if (ratings.contains(rating)) {
      ratings.remove(rating);
    } else {
      ratings.add(rating);
    }
    state = state.copyWith(selectedRatings: ratings);
  }

  void updatePriceRange(double min, double max) {
    state = state.copyWith(minPrice: min, maxPrice: max);
  }

  void reset() {
    state = const FilterState();
  }
}

final filterControllerProvider =
NotifierProvider<FilterController, FilterState>(
  FilterController.new,
);