class FilterState {
  final String selectedLocation;
  final String postalCode;
  final String selectedCategory;
  final List<String> categories;
  final List<int> selectedRatings;
  final double minPrice;
  final double maxPrice;

  const FilterState({
    this.selectedLocation = '',
    this.postalCode = '',
    this.selectedCategory = 'Todas las categorías',
    this.categories = const [
      'Todas las categorías',
      'Albañilería',
      'Plomería',
      'Electricidad',
      'Pintura',
      'Carpintería',
      'Jardinería',
      'Limpieza',
      'Mecánica',
      'Herrería',
      'Gasista',
      'Cerrajería',
      'Fletes / Mudanzas',
      'Refrigeración / Aire acondicionado',
    ],
    this.selectedRatings = const [],
    this.minPrice = 0.0,
    this.maxPrice = 1000.0,
  });

  FilterState copyWith({
    String? selectedLocation,
    String? postalCode,
    String? selectedCategory,
    List<int>? selectedRatings,
    double? minPrice,
    double? maxPrice,
  }) {
    return FilterState(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      postalCode: postalCode ?? this.postalCode,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      categories: categories,
      selectedRatings: selectedRatings ?? this.selectedRatings,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
    );
  }

  Map<String, String> toQueryParameters() {
    final params = <String, String>{};
    if (postalCode.trim().isNotEmpty) {
      params['postcode'] = postalCode.trim();
    }
    if (selectedLocation.trim().isNotEmpty) {
      params['location'] = selectedLocation.trim();
    }
    if (selectedCategory != 'Todas las categorías' &&
        selectedCategory != 'Categorías') {
      params['category'] = selectedCategory;
    }
    if (selectedRatings.isNotEmpty) {
      params['rating'] = selectedRatings.first.toString();
    }
    params['minPrice'] = minPrice.toInt().toString();
    params['maxPrice'] = maxPrice.toInt().toString();
    return params;
  }
}