import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/network/api_client.dart';
import '../models/service_item_model.dart';
import 'filter_bottomsheet_controller.dart';

class ServicesState {
  final bool isLoading;
  final List<ServiceItem> services;
  final String? errorMessage;

  const ServicesState({
    this.isLoading = false,
    this.services = const [],
    this.errorMessage,
  });

  ServicesState copyWith({
    bool? isLoading,
    List<ServiceItem>? services,
    String? errorMessage,
  }) {
    return ServicesState(
      isLoading: isLoading ?? this.isLoading,
      services: services ?? this.services,
      errorMessage: errorMessage,
    );
  }
}

class ServicesController extends Notifier<ServicesState> {
  @override
  ServicesState build() {
    Future.microtask(() => fetchFilteredServices());
    return const ServicesState();
  }

  Future<void> fetchFilteredServices() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final filterState = ref.read(filterControllerProvider);
      final queryParams = filterState.toQueryParameters();

      final uri = Uri.parse('https://api.manospro.app/api/v1/service')
          .replace(queryParameters: queryParams);

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken') ?? '';

      final network = NetworkCaller();
      final response = await network.getRequest(uri.toString(), token: token);

      if (response.isSuccess && response.responseData != null) {
        final rawData = response.responseData;
        final rawServices = (rawData is Map<String, dynamic> && rawData['services'] is List)
            ? rawData['services'] as List
            : (rawData is List ? rawData : []);

        final items = rawServices
            .whereType<Map<String, dynamic>>()
            .map(ServiceItem.fromJson)
            .toList();

        state = state.copyWith(isLoading: false, services: items);
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: response.errorMessage.isNotEmpty
              ? response.errorMessage
              : 'No services found',
          services: [],
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to fetch services: $e',
        services: [],
      );
    }
  }
}

final servicesControllerProvider =
NotifierProvider<ServicesController, ServicesState>(
  ServicesController.new,
);