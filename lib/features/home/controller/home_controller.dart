import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../models/service_item_model.dart';
import 'home_state.dart';

class HomeController extends Notifier<HomeState> {
  @override
  HomeState build() {
    // Automatically trigger initial load
    Future.microtask(() => fetchHomeServices());
    return const HomeState();
  }

  void selectCategory(int index) {
    if (state.selectedCategoryIndex == index) return;
    state = state.copyWith(selectedCategoryIndex: index);
    fetchHomeServices();
  }

  Future<void> fetchHomeServices() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final category = state.categories[state.selectedCategoryIndex];
      final isAll = category == 'Todas las categorías';

      // Clean query construction
      final queryParameters = <String, String>{
        'page': '1',
        'limit': '20',
      };
      if (!isAll) {
        queryParameters['category'] = category;
      }

      final uri = Uri.parse('http://10.0.20.33:5004/api/v1/service')
          .replace(queryParameters: queryParameters);

      final network = NetworkCaller();
      final response = await network.getRequest(uri.toString(), token: token);

      if (response.isSuccess && response.responseData != null) {
        final rawResult = response.responseData;
        final rawServices = (rawResult is Map<String, dynamic> && rawResult['services'] is List)
            ? rawResult['services'] as List
            : (rawResult is List ? rawResult : []);

        final services = rawServices
            .whereType<Map<String, dynamic>>()
            .map(ServiceItem.fromJson)
            .toList();

        state = state.copyWith(
          isLoading: false,
          services: services,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'Failed to load services',
          services: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Network error: $e',
        services: [],
      );
    }
  }
}

final homeControllerProvider = NotifierProvider<HomeController, HomeState>(
  HomeController.new,
);