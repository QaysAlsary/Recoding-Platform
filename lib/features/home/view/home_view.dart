import 'package:flutter/material.dart';
import 'package:recoding_platform_project/features/home/view/widgets/home_map_widget.dart';
import 'package:recoding_platform_project/src/components/settings_drawer.dart';

import '../bloc/home_bloc.dart';
import 'widgets/top_bar_widget.dart';
import 'widgets/search_controls_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: const SettingsDrawer(),
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Column(
          children: [
            Builder(builder: (context) {
              return TopBarWidget(onSettingsPressed: () {
                Scaffold.of(context).openEndDrawer();
              });
            }),
            Expanded(
              child: Stack(
                children: [
                  // Map widget
                  MapTilerWidget(),
                  // Search controls positioned on top
                  const SearchControlsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
