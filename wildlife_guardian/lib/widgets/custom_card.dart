import 'package:flutter/material.dart';
import 'package:wildlife_guardian/theme/app_theme.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final Color? borderColor;
  final double borderRadius;
  final double elevation;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final VoidCallback? onTap;
  final bool isGradient;
  final Color gradientStart;
  final Color gradientEnd;
  final double? width;
  final double? height;

  const CustomCard({
    Key? key,
    required this.child,
    this.color,
    this.borderColor,
    this.borderRadius = 12.0,
    this.elevation = 4.0,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.isGradient = false,
    this.gradientStart = AppTheme.accentGreen,
    this.gradientEnd = AppTheme.accentBlue,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardColor = color ?? Theme.of(context).cardColor;
    
    final decoration = isGradient
        ? BoxDecoration(
            gradient: LinearGradient(
              colors: [gradientStart, gradientEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: [
              BoxShadow(
                color: gradientStart.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          )
        : BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: borderColor != null 
                ? Border.all(color: borderColor!, width: 1.5) 
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: elevation * 2,
                offset: Offset(0, elevation),
              ),
            ],
          );

    final cardWidget = Container(
      margin: margin,
      width: width,
      height: height,
      decoration: decoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: onTap != null 
                ? Colors.white.withOpacity(0.1) 
                : Colors.transparent,
            highlightColor: onTap != null 
                ? Colors.white.withOpacity(0.05) 
                : Colors.transparent,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );

    return cardWidget;
  }
}

class StatusCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color? cardColor;
  final VoidCallback? onTap;

  const StatusCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor = AppTheme.accentGreen,
    this.cardColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      onTap: onTap,
      color: cardColor,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ],
      ),
    );
  }
}

class GradientBorderCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;
  final Color gradientStart;
  final Color gradientEnd;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const GradientBorderCard({
    Key? key,
    required this.child,
    this.borderRadius = 12.0,
    this.padding = const EdgeInsets.all(16.0),
    this.gradientStart = AppTheme.accentGreen,
    this.gradientEnd = AppTheme.accentBlue,
    this.onTap,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [gradientStart, gradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: gradientStart.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(borderRadius - 2),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius - 2),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              splashColor: onTap != null 
                  ? Colors.white.withOpacity(0.1) 
                  : Colors.transparent,
              highlightColor: onTap != null 
                  ? Colors.white.withOpacity(0.05) 
                  : Colors.transparent,
              child: Padding(
                padding: padding,
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
} 