import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Central Franchise Team Crest registry for Kreeda.
/// Maps tournament teams to their authentic 3D crest badges.
class AppCrests {
  static String? getTeamCrest(String codeOrId) {
    final key = codeOrId.toLowerCase().trim();
    switch (key) {
      case 'tkr':
      case 'telugu knight riders':
        return 'Assets/tkr_crest.jpg';
      case 'ts':
      case 'telugu strikers':
        return 'Assets/ts_crest.jpg';
      case 'cr':
      case 'coastal riders':
        return 'Assets/cr_crest.jpg';
      case 'vzs':
      case 'vizag strikers':
        return 'Assets/vzs_crest.jpg';
      case 'gk':
      case 'godavari kings':
        return 'Assets/gk_crest.jpg';
      case 'rr':
      case 'rayalaseema royals':
        return 'Assets/rr_crest.jpg';
      case 'aw':
      case 'amaravati warriors':
        return 'Assets/aw_crest.jpg';
      case 'kb':
      case 'krishna blasters':
        return 'Assets/kb_crest.jpg';
      case 'ind':
      case 'india':
        return 'Assets/ind_crest.jpg';
      case 'aus':
      case 'australia':
        return 'Assets/aus_crest.jpg';
      default:
        return null;
    }
  }
}

/// Reusable 3D Circular Franchise Crest Avatar for Kreeda.
/// Guarantees zero pixel errors, fallback resilience, and tactile neumorphic shadows.
class TeamCrestAvatar extends StatelessWidget {
  final String teamCode;
  final double size;
  final Color? borderColor;
  final Color? fallbackColor;
  final IconData? fallbackIcon;

  const TeamCrestAvatar({
    super.key,
    required this.teamCode,
    this.size = 40.0,
    this.borderColor,
    this.fallbackColor,
    this.fallbackIcon,
  });

  @override
  Widget build(BuildContext context) {
    final asset = AppCrests.getTeamCrest(teamCode);
    final border = borderColor ?? AppColors.border(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: border, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 4,
            offset: const Offset(0, 1.5),
          ),
        ],
      ),
      child: ClipOval(
        child: asset != null
            ? Image.asset(
                asset,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) => _buildFallback(context),
              )
            : _buildFallback(context),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    final color = fallbackColor ?? AppColors.primary(context);
    return Container(
      color: color.withValues(alpha: 0.15),
      alignment: Alignment.center,
      child: fallbackIcon != null
          ? Icon(fallbackIcon, size: size * 0.5, color: color)
          : Text(
              teamCode.length > 3 ? teamCode.substring(0, 3).toUpperCase() : teamCode.toUpperCase(),
              style: TextStyle(
                fontSize: size * 0.32,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
    );
  }
}
