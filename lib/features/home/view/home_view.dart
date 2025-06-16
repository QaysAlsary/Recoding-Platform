import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recoding_platform_project/features/home/view/widgets/home_map_widget.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart'; // تأكد تستورد الـ ProfileBloc
import 'package:recoding_platform_project/features/profile/data/repo/user_repo.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart'; // لو محتاج getIt<UserRepo>()

import '../bloc/home_bloc.dart';
import 'widgets/top_bar_widget.dart';
import 'widgets/search_controls_widget.dart';
import 'widgets/create_marker_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SafeArea(
        child: Column(
          children: [
            const TopBarWidget(),
            Expanded(
              child: Stack(
                children: [
                  MapTilerWidget(),
                  SearchControlsWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
