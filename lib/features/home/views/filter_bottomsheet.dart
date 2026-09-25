import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_colors.dart';
import '../controller/filter_bottomsheet_controller.dart';
class FilterBottomSheet extends ConsumerStatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  ConsumerState<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends ConsumerState<FilterBottomSheet> {
  late final TextEditingController _locationController;
  late final TextEditingController _postalCodeController;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(filterControllerProvider);
    _locationController = TextEditingController(text: filter.selectedLocation);
    _postalCodeController = TextEditingController(text: filter.postalCode);
  }

  @override
  void dispose() {
    _locationController.dispose();
    _postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(filterControllerProvider);
    final controller = ref.read(filterControllerProvider.notifier);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xffE3E7EC),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Servicio de filtro',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Location Input
              Text(
                'Ubicación',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _locationController,
                onChanged: controller.updateLocation,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'New York, USA',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Postal Code
              Text(
                'Código Postal',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _postalCodeController,
                onChanged: controller.updatePostalCode,
                style: GoogleFonts.inter(fontSize: 14),
                decoration: InputDecoration(
                  hintText: '10001',
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Categories Chips
              Text(
                'Categorías',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: state.categories.map((cat) {
                    final isSelected = state.selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => controller.selectCategory(cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.primary : Colors.white,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            cat,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // Ratings selection
              Text(
                'Calificaciones',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  final rating = 5 - index;
                  final isSelected = state.selectedRatings.contains(rating);

                  return InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () => controller.toggleRating(rating),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey.shade300,
                          width: isSelected ? 1.5 : 1,
                        ),
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
                      ),
                      child: Row(
                        children: [
                          Text('$rating', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 4),
                          const Icon(Icons.star, size: 14, color: Color(0xFFFFB800)),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              // Price Range Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Gama de precios', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                  Text(
                    '\$${state.minPrice.toInt()} - \$${state.maxPrice.toInt()}',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                  ),
                ],
              ),
              RangeSlider(
                values: RangeValues(state.minPrice, state.maxPrice),
                min: 0,
                max: 1000,
                activeColor: AppColors.primary,
                inactiveColor: Colors.grey.shade300,
                onChanged: (values) {
                  controller.updatePriceRange(values.start, values.end);
                },
              ),
              const SizedBox(height: 24),

              // Apply Action Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    //context.push(AppRoutes.services);
                  },
                  child: Text(
                    'Aplicar filtro',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}