import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import '../../bloc/home_bloc.dart';
import '../../models/aspect_model.dart';

class MarkerDetailsPanel extends StatefulWidget {
  final int locationId;

  const MarkerDetailsPanel({
    super.key,
    required this.locationId,
  });

  @override
  State<MarkerDetailsPanel> createState() => _MarkerDetailsPanelState();
}

class _MarkerDetailsPanelState extends State<MarkerDetailsPanel> {
  final ScrollController _descScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchLocationDetailsEvent(widget.locationId));
  }

  @override
  void dispose() {
    _descScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: _handleStateChanges,
        builder: (context, state) => _buildBody(state),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, HomeState state) {
    if (state is DeleteMarkerSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.green,
        ),
      );

      context.go(Routes.home);
    } else if (state is DeleteMarkerError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildBody(HomeState state) {
    if (state is LocationLoading || state is DeleteMarkerLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is LocationError) {
      return Center(child: Text(state.message));
    }

    if (state is LocationLoaded) {
      return _buildLoadedContent(state);
    }

    return const SizedBox.shrink();
  }

  Widget _buildLoadedContent(LocationLoaded state) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 80.h),
      child: Column(
        children: [
          const Header(headerText: 'Marker Details'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8.h),
                _buildMarkerName(state),
                SizedBox(height: 25.h),
                _buildMarkerDetails(state),
                SizedBox(height: 20.h),
                _buildActionButtons(state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkerName(LocationLoaded state) {
    return Text(
      state.location.name,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildMarkerDetails(LocationLoaded state) {
    final aspectName = state.location.aspectId != null
        ? AspectData.getAspectById(state.location.aspectId!)?.name ?? 'N/A'
        : 'N/A';
    final subAspectName = state.location.subAspectId != null
        ? AspectData.getSubAspectById(state.location.subAspectId!)?.name ??
            'N/A'
        : 'N/A';
    final categoryName = state.location.categoryId != null
        ? AspectData.getCategoryById(state.location.categoryId!)?.name ?? 'N/A'
        : 'N/A';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailField(
          'Aspect: $aspectName',
          Icons.other_houses_outlined,
        ),
        SizedBox(height: 20.h),
        _buildDetailField(
          'Sub-aspect: $subAspectName',
          Icons.other_houses_outlined,
        ),
        SizedBox(height: 20.h),
        _buildDetailField(
          'Category: $categoryName',
          Icons.category_outlined,
        ),
        SizedBox(height: 20.h),
        _buildDetailField(
          'Location name: ${state.location.name}',
          Icons.location_on_outlined,
        ),
        SizedBox(height: 20.h),
        _buildDescriptionField(state),
        SizedBox(height: 20.h),
        _buildImagesField(state),
      ],
    );
  }

  Widget _buildDetailField(String hintText, IconData icon) {
    return InputTextFormField(
      hintText: hintText,
      prefixIcon: Icon(icon, color: const Color(0xff787878), size: 18.sp),
      enabled: false,
      height: 35.h,
      hintStyle:
          Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 16.sp),
      padding: EdgeInsets.symmetric(vertical: 0),
    );
  }

  Widget _buildDescriptionField(LocationLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailField(
          'Description:',
          Icons.description_outlined,
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 100.h,
          child: Scrollbar(
            controller: _descScrollController,
            interactive: true,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _descScrollController,
              physics: const BouncingScrollPhysics(),
              child: Text(
                state.location.description ?? 'No description available',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(fontSize: 16.sp),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImagesField(LocationLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailField(
          'Images:',
          Icons.image_outlined,
        ),
        SizedBox(height: 14.h),
        SizedBox(
          height: 120.w,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: state.location.images.length,
            separatorBuilder: (context, index) => SizedBox(width: 8.w),
            itemBuilder: (context, index) =>
                _buildImageItem(state.location.images[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildImageItem(dynamic image) {
    String? imagePath;
    if (image is Map<String, dynamic>) {
      imagePath = image['image_path'] as String?;
    } else {
      imagePath = image.imagePath;
    }
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.r),
        child: CachedNetworkImage(
          imageUrl: imagePath != null ? EndPoint.imageBaseUrl + imagePath : '',
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: const Color(0xffd9d9d9),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: const Color(0xffd9d9d9),
            child: const Icon(Icons.error),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(LocationLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AuthButton(
            onPressed: () => _handleEdit(state),
            text: 'Edit',
            buttonWidth: double.infinity,
            buttonHeight: 50.h,
            textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6ab3d9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: AuthButton(
            onPressed: () => _handleDelete(state),
            text: 'Delete',
            buttonWidth: double.infinity,
            buttonHeight: 50.h,
            textStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
            buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: const BorderSide(color: Color(0xff6ab3d9), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _handleEdit(LocationLoaded state) {
    context.push(Routes.editMarker, extra: state.location);
  }

  void _handleDelete(LocationLoaded state) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Marker',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this marker?',
          style: TextStyle(fontSize: 16.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16.sp,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              context
                  .read<HomeBloc>()
                  .add(DeleteMarkerEvent(state.location.id));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              'Delete',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
