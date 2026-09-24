import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/nav_controller.dart';


// Placeholder / Destination feature views:
// In your project, import the actual views:
// import '../../home/views/home_view.dart';
// import '../../bookings/views/my_booking_view.dart';
// import '../../chat/views/all_messages_view.dart';
// import '../../profile/views/user_profile_view.dart';

class MainNavView extends ConsumerWidget {
  const MainNavView({super.key});

  static const List<Widget> _screens = [
    Center(child: Text('Home View')),
    Center(child: Text('Bookings View')),
    Center(child: Text('Messages View')),
    Center(child: Text('Profile View')),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navControllerProvider);
    final controller = ref.read(navControllerProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        height: 72,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              offset: const Offset(0, -3),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavIconItem(
              selectedPath: 'assets/icons/nav11.png',
              unselectedPath: 'assets/icons/nav1.png',
              index: 0,
              currentIndex: currentIndex,
              onTap: () => controller.changePage(0),
            ),
            _NavIconItem(
              selectedPath: 'assets/icons/nav22.png',
              unselectedPath: 'assets/icons/nav2.png',
              index: 1,
              currentIndex: currentIndex,
              onTap: () => controller.changePage(1),
            ),
            _NavIconItem(
              selectedPath: 'assets/icons/nav33.png',
              unselectedPath: 'assets/icons/nav3.png',
              index: 2,
              currentIndex: currentIndex,
              onTap: () => controller.changePage(2),
            ),
            _NavIconItem(
              selectedPath: 'assets/icons/nav44.png',
              unselectedPath: 'assets/icons/nav4.png',
              index: 3,
              currentIndex: currentIndex,
              onTap: () => controller.changePage(3),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIconItem extends StatelessWidget {
  final String selectedPath;
  final String unselectedPath;
  final int index;
  final int currentIndex;
  final VoidCallback onTap;

  const _NavIconItem({
    required this.selectedPath,
    required this.unselectedPath,
    required this.index,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset(
          isSelected ? selectedPath : unselectedPath,
          width: 32,
          height: 32,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}