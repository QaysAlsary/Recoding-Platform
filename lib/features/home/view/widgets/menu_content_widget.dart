import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';

import '../../../../src/themes/app_colors.dart';
import '../../bloc/home_bloc.dart';

class MenuContentWidget extends StatelessWidget {
  final String label;

  const MenuContentWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    switch (label) {
      case 'Search Marker':
        return _buildSearchMarkerContent(context);
      case 'Filter Layers':
        return _buildFilterLayersContent(context);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildSearchMarkerContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.all( 13.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(21),bottomRight: Radius.circular(21)) ,color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.search, size: 20.r, color: Colors.grey),
              8.horizontalSpace,
              Text('Search', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.r,color: Colors.grey)),
            ],
          ),
          12.verticalSpace,
          InputTextFormField(

            width: double.infinity,
            hintText: 'Marker Name',
            prefixIcon: Icon(Icons.edit_outlined , color: Colors.grey,size: 20.r),
          hintStyle: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontSize: 16.r, fontWeight: FontWeight.w300),
          ),
       
          12.verticalSpace,
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final selectedCategory = state is MenuState ? state.selectedCategory : null;
      
              return DropdownButtonFormField<String>(
                value: selectedCategory,
                dropdownColor: Colors.white,

                icon: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.grey,),
                decoration: InputDecoration(

                  hintText: 'Category',
                  hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16.r, fontWeight: FontWeight.w300),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 3.73,
                      color: AppColors.black015,
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 3.73,
                      color: AppColors.black015,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 3.73,
                      color: AppColors.black015,
                    ),
                  ),
                  prefixIcon: Icon(Icons.category_outlined , size: 20.r,color: Colors.grey,),
                ),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16.r, fontWeight: FontWeight.w300),
                items: ['Category A', 'Category B', 'Category C'].map((cat) => DropdownMenuItem(value: cat, child: Text(cat))).toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<HomeBloc>().add(SelectCategoryEvent(value));
                  }
                },
              );
            },
          ),
          12.verticalSpace,
          AuthButton(onPressed: (){}, text: 'Search', margin: EdgeInsets.symmetric(horizontal: 33.w), buttonHeight: 30.h, textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 13.r, fontWeight: FontWeight.w300, ),),
          6.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('You need a new marker?', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.r,)),
              TextButton(onPressed: (){}, child: Text('Create Marker', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.r, fontWeight: FontWeight.w400, color: AppColors.blue)) )
            ],
          )

        ],
      ),
    );
  }

  Widget _buildFilterLayersContent(BuildContext context) {
    return Container(
      margin: EdgeInsets.all( 13.w),
      decoration: BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(21),bottomRight: Radius.circular(21)) ,color: Colors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.filter_alt_outlined, size: 20.r, color: Colors.grey),
              8.horizontalSpace,
              Text('Filter layers', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16.r,color: Colors.grey)),
            ],
          ),
          12.verticalSpace,


          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final selected = state is MenuState ? state.selectedFilterCategory : null;
              return DropdownButtonFormField<String>(
                value: selected,
                dropdownColor: Colors.white,
                icon: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.grey,),
                decoration: InputDecoration(

                  hintText: 'Category',
                  hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16.r, fontWeight: FontWeight.w300),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 3.73,
                      color: AppColors.black015,
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 3.73,
                      color: AppColors.black015,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 3.73,
                      color: AppColors.black015,
                    ),
                  ),
                  prefixIcon: Icon(Icons.category_outlined , size: 20.r,color: Colors.grey,),
                ),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16.r, fontWeight: FontWeight.w300),
                items: ['Environment', 'Infrastructure', 'Transport']
                    .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<HomeBloc>().add(SelectFilterCategoryEvent(value));
                  }
                },
              );
            },
          ),
          12.verticalSpace,


          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final selected = state is MenuState ? state.selectedSubAspect : null;
              return DropdownButtonFormField<String>(
                value: selected,
                dropdownColor: Colors.white,
                icon: Icon(Icons.keyboard_arrow_down_outlined, color: Colors.grey,),
                decoration: InputDecoration(

                  hintText: 'Sup-aspect',
                  hintStyle: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16.r, fontWeight: FontWeight.w300),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 3.73,
                      color: AppColors.black015,
                    ),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 3.73,
                      color: AppColors.black015,
                    ),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(
                      width: 3.73,
                      color: AppColors.black015,
                    ),
                  ),
                  prefixIcon: Icon(Icons.other_houses_outlined , size: 20.r,color: Colors.grey,),
                ),
                style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16.r, fontWeight: FontWeight.w300),
                items: ['Aspect 1', 'Aspect 2', 'Aspect 3']
                    .map((sub) => DropdownMenuItem(value: sub, child: Text(sub)))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    context.read<HomeBloc>().add(SelectSubAspectEvent(value));
                  }
                },
              );
            },
          ),
          12.verticalSpace,
          AuthButton(onPressed: (){}, text: 'Filter', margin: EdgeInsets.symmetric(horizontal: 33.w), buttonHeight: 30.h, textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 13.r, fontWeight: FontWeight.w300, ),),

        ],
      ),
    );
  }

}
