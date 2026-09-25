import '../models/promo_item_model.dart';
import '../models/service_item_model.dart';

class HomeState {
  final bool isLoading;
  final int selectedCategoryIndex;
  final List<String> categories;
  final List<ServiceItem> services;
  final List<PromoItem> promoCards;
  final String? errorMessage;

  const HomeState({
    this.isLoading = false,
    this.selectedCategoryIndex = 0,
    this.categories = const [
      'Todas las categorías',
      'Electricista',
      'Plomería',
      'Cuadro',
      'Carpinteros',
      'AC Reparar',
    ],
    this.services = const [],
    this.promoCards = const [
      PromoItem(
        backgroundImage: 'assets/images/promo_card1.png',
        title: '30% OFF',
        subtitle: 'On First Plumbing Service',
        ladyImage: 'assets/images/promolady.png',
      ),
      PromoItem(
        backgroundImage: 'assets/images/promo_card2.png',
        title: '30% OFF',
        subtitle: 'On First Electrical Service',
        ladyImage: 'assets/images/promolady.png',
      ),
      PromoItem(
        backgroundImage: 'assets/images/promo_card1.png',
        title: '30% OFF',
        subtitle: 'On First AC Repair',
        ladyImage: 'assets/images/promolady.png',
      ),
      PromoItem(
        backgroundImage: 'assets/images/promo_card2.png',
        title: '30% OFF',
        subtitle: 'On First Painting Service',
        ladyImage: 'assets/images/promolady.png',
      ),
    ],
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoading,
    int? selectedCategoryIndex,
    List<ServiceItem>? services,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      selectedCategoryIndex: selectedCategoryIndex ?? this.selectedCategoryIndex,
      categories: categories,
      services: services ?? this.services,
      promoCards: promoCards,
      errorMessage: errorMessage,
    );
  }
}