import 'package:flutter/material.dart';

import '../l10n/l10n_x.dart';
import '../theme/app_palette.dart';

/// The 2S Home Wear logo: `assets/images/logo.png` when bundled, otherwise
/// a text wordmark (bold yellow "2S" + the rest in the surface color).
class BrandWordmark extends StatelessWidget {
  const BrandWordmark({super.key, this.size = 22});

  static const logoAsset = 'assets/images/logo.png';

  /// Resolved once at startup from the asset manifest (see bootstrap).
  static bool hasLogo = false;

  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    label: context.l10n.appName,
    excludeSemantics: true,
    child: hasLogo
        ? Image.asset(
            logoAsset,
            height: size * 1.6,
            errorBuilder: (context, _, _) => _TextWordmark(size: size),
          )
        : _TextWordmark(size: size),
  );
}

class _TextWordmark extends StatelessWidget {
  const _TextWordmark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.titleLarge?.copyWith(
      fontSize: size,
      height: 1.2,
      color: theme.colorScheme.onSurface,
    );
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: context.l10n.brandShort,
            style: TextStyle(
              color: context.palette.brandYellow,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextSpan(
            text: context.l10n.brandRest,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
      style: base,
      // The brand name is Latin: keep its order in RTL layouts.
      textDirection: TextDirection.ltr,
      maxLines: 1,
    );
  }
}
