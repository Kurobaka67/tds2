import 'package:flutter/material.dart';
class OptionsMenu extends StatefulWidget {
  const OptionsMenu({super.key});

  @override
  State<OptionsMenu> createState() => _OptionsMenuState();
}

class _OptionsMenuState extends State<OptionsMenu> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return MenuAnchor(
        builder: (BuildContext context, MenuController controller,
            Widget? child) {
          return IconButton(
            onPressed: () {
              if (controller.isOpen) {
                controller.close();
              } else {
                controller.open();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: theme.colorScheme.onPrimary,
            ),
            tooltip: 'Options',
          );
        },
        menuChildren: [
          MenuItemButton(
            onPressed: () {

            },
            child: const Row(
              children: [
                Text("Options"),
                Spacer(),
                Icon(Icons.settings),
              ],
            ),
          ),
          MenuItemButton(
            onPressed: () {

            },
            child: const Row(
              children: [
                Text("Déconnexion"),
                Spacer(),
                Icon(Icons.output),
              ],
            ),
          )
        ]
    );
  }
}