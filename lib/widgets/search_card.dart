import 'package:flutter/material.dart';
import '../screen/find_buses_screen.dart';
import '../widgets/upcoming_journey_card.dart';

/// ================== APP COLORS ==================
class AppColors {
  static const primary = Color(0xFFE53935);
  static const accent = Color(0xFFFF9800);
  static const accentDark = Color(0xFFFB8C00);
  static const white = Colors.white;
  static const greyText = Colors.grey;
}

class SearchCard extends StatelessWidget {
  const SearchCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      color: AppColors.accent,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ---------- FROM / TO ----------
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Column(
                  children: [
                    _LocationField(label: 'Boarding From'),
                    SizedBox(height: 12),
                    _LocationField(label: 'Where are you going?'),
                  ],
                ),

                /// Swap Button
                Positioned(
                  right: 12,
                  top: 48,
                  child: _SwapButton(),
                ),
              ],
            ),

            const SizedBox(height: 22),

            /// ---------- DATE SELECT ----------
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _DateChip(label: 'Today', selected: true),
                _DateChip(label: 'Tomorrow'),
                _DateChip(label: 'Other', icon: Icons.calendar_month),
              ],
            ),

            const SizedBox(height: 28),

            /// ---------- FIND BUSES ----------
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FindBusesScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Find Buses',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ---------- UPCOMING JOURNEY ----------
            const Text(
              'Upcoming Journey',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: 12),

            const UpcomingJourneyCard(isEmbedded: true),
          ],
        ),
      ),
    );
  }
}

/// ================== LOCATION FIELD ==================
class _LocationField extends StatelessWidget {
  final String label;

  const _LocationField({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.greyText,
        ),
      ),
    );
  }
}

/// ================== SWAP BUTTON ==================
class _SwapButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.accentDark,
          width: 3,
        ),
      ),
      padding: const EdgeInsets.all(6),
      child: const Icon(
        Icons.swap_vert,
        size: 20,
        color: AppColors.primary,
      ),
    );
  }
}

/// ================== DATE CHIP ==================
class _DateChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;

  const _DateChip({
    required this.label,
    this.icon,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? AppColors.white : AppColors.accentDark,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.white, width: 1.4),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: selected ? Colors.black : AppColors.white,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: selected ? Colors.black : AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
