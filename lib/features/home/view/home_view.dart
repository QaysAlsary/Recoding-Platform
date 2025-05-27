import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            TopBarWidget(),
            BlocProvider(
                create: (_) => HomeBloc(), child: SearchControlsWidget()),
            CreateMarkerButton(),
          ],
        ),
      ),
    );
  }
}
