import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showDrawerButton;
  final Widget? leading;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showDrawerButton = true,
    this.leading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      title: Text(title),
      leading: leading ??
          (showDrawerButton
              ? Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu_rounded, size: 24),
                    tooltip: 'Buka Menu',
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                )
              : null),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Container(
          color: colorScheme.outlineVariant,
          height: 1.0,
        ),
      ),
      actions: actions,
    );
  }
}

