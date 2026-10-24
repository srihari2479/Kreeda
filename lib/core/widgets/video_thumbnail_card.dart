import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Video highlight card with 16:9 ratio, play button, and duration badge.
class VideoThumbnailCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String duration;
  final VoidCallback? onTap;

  const VideoThumbnailCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.duration,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 16:9 Video Thumbnail
          AspectRatio(
            aspectRatio: 16 / 9,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.border(context),
                    width: 1.0,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(13.2),
                  child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Dynamic Sports Stadium gradient backdrop
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF1E293B),
                            Color(0xFF0F172A),
                            Color(0xFF020617),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.sports_cricket_rounded,
                          size: 40,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                      ),
                    ),

                    // Center Glass Play Button
                    Center(
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withValues(alpha: 0.45),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.6),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // Duration Badge (Bottom-Right)
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.75),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          duration,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 8),

          // Video Title
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          // Category & Timestamp
          Text(
            subtitle,
            style: AppTypography.caption(AppColors.textMuted(context)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
