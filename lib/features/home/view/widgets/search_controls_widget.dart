import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/features/home/view/widgets/search_bar_widget.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';

import '../../bloc/home_bloc.dart';
import 'dropdown_button_widget.dart';
import 'menu_content_widget.dart';

class SearchControlsWidget extends StatelessWidget {
  const SearchControlsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        final openMenuLabel = state is MenuState ? state.openMenuLabel : null;

        return Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonWidget(
                      label: 'Search Marker',
                      icon: Icons.search,
                      openMenuLabel: openMenuLabel,
                    ),
                  ),
                  2.horizontalSpace,
                  Expanded(
                    child: DropdownButtonWidget(
                      label: 'Filter Layers',
                      icon: Icons.filter_alt_outlined,
                      openMenuLabel: openMenuLabel,
                    ),
                  ),
                ],
              ),
            ),

             (openMenuLabel != null)?
              Container(
                width: double.infinity,

                decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(21),bottomRight: Radius.circular(21)) ,color: Colors.white),



                child: MenuContentWidget(label: openMenuLabel),
              ): SearchBarWidget(controller: TextEditingController()),



          ],

        );
      },
    );
  }
}
