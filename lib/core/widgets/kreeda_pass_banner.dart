import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_typography.dart';

/// Kreeda Pass VIP subscription banner promoting ad-free and live streaming perks.
class KreedaPassBanner extends StatelessWidget {
  final VoidCallback? onUpgrade;

  const KreedaPassBanner({super.key, this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpgrade,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: AppColors.passBannerGradient(context),
          border: Border.all(
            color: AppColors.passGold.withValues(alpha: 0.35),
            width: 0.8,
          ),
          boxShadow: AppShadows.goldGlow,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
            children: [
              // VIP 3D Crest Badge
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.passGold,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.passGold.withValues(alpha: 0.35),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.5),
                  child: Image.asset(
                    'Assets/kreeda_vip_pass_badge.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(
                        Icons.workspace_premium_rounded,
                        color: AppColors.passGold,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Banner Copy
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          'KREEDA',
                          style: AppTypography.bebas(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'PASS',
                          style: AppTypography.bebas(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.passGold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Live Matches • Ad Free • Exclusive Content',
                      style: AppTypography.caption(
                        Colors.white.withValues(alpha: 0.88),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 10),

              // Upgrade > CTA Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Upgrade',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: AppColors.primaryOrange,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
