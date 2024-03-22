import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBottomDivider;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.actions,
    this.leading,
    this.showBottomDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      leading: leading,
      title: subtitle == null
          ? Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                ),
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
      actions: actions,
      bottom: showBottomDivider
          ? PreferredSize(
              preferredSize: const Size.fromHeight(1.0),
              child: Container(
                color: theme.colorScheme.outline.withOpacity(0.4),
                height: 1.0,
              ),
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? kToolbarHeight : kToolbarHeight + 10);
}
