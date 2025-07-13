import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recoding_platform_project/features/home/view/widgets/drop_down_aspect.dart';
import 'package:recoding_platform_project/features/home/view/widgets/drop_down_category.dart';
import 'dart:io';
import 'package:recoding_platform_project/features/home/view/widgets/drop_down_sub_aspect.dart'
    hide DropDownCategory;
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';
import '../../bloc/home_bloc.dart';
import '../../models/location_model.dart';
import '../../models/aspect_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EditMarkerView extends StatefulWidget {
  final Location location;

  const EditMarkerView({
    super.key,
    required this.location,
  });

  @override
  State<EditMarkerView> createState() => _EditMarkerViewState();
}

class _EditMarkerViewState extends State<EditMarkerView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.location.name);
    _descriptionController =
        TextEditingController(text: widget.location.description ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // void _initBlocState(BuildContext context) {
  //   final bloc = context.read<HomeBloc>();
  //   final state = bloc.state;
  //   if (state is! EditMarkerState) {
  //     bloc.add(InitEditMarkerEvent(
  //       aspect: location.aspectId,
  //       subAspect: location.subAspectId,
  //       category: location.categoryId,
  //       newImages: [],
  //       name: location.name,
  //     ));
  //     bloc.add(FetchAspectsEvent());
  //     if (location.aspectId != null) {
  //       bloc.add(FetchSubAspectsEvent(location.aspectId!));
  //     }
  //     if (location.subAspectId != null) {
  //       bloc.add(FetchCategoriesEvent(location.subAspectId!));
  //     }
  //   }
  // }

  Future<void> _handleImageSelection(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> newImages = await picker.pickMultiImage();

    if (newImages.isNotEmpty) {
      final currentImages = (context.read<HomeBloc>().state is EditMarkerState)
          ? (context.read<HomeBloc>().state as EditMarkerState)
              .newImages
              .map((file) => XFile(file.path))
              .toList()
          : <XFile>[];

      final List<XFile> combinedImages = [
        ...currentImages,
        ...newImages,
      ];

      context.read<HomeBloc>().add(UpdateEditMarkerImagesEvent(
          combinedImages.map((x) => File(x.path)).toList()));
    }
  }

  void _handleSave(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      _showConfirmationDialog(context);
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => _buildConfirmationDialog(context),
    );
  }

  Widget _buildConfirmationDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: Text(
        'Confirm Changes',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        'Are you sure you want to save these changes?',
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
            _submitChanges(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xff6ab3d9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            'Save',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }

  void _submitChanges(BuildContext context) {
    final state = context.read<HomeBloc>().state;

    final aspectId = (state is EditMarkerState) ? state.selectedAspect : null;
    final subAspectId =
        (state is EditMarkerState) ? state.selectedSubAspect : null;
    final categoryId =
        (state is EditMarkerState) ? state.selectedCategory : null;
    List<XFile> images = (state is EditMarkerState)
        ? state.newImages.map((file) => XFile(file.path)).toList()
        : <XFile>[];
    context.read<HomeBloc>().add(
          EditMarkerEvent(
            locationId: widget.location.id,
            name: _nameController.text,
            description: _descriptionController.text,
            aspect: aspectId,
            subAspect: subAspectId,
            category: categoryId,
            newImages: images,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    //   Future.microtask(() {
    // context.read<HomeBloc>().add(InitEditMarkerEvent(
    //   aspect: location.aspectId,
    //   subAspect: location.subAspectId,
    //   category: location.categoryId,
    //   newImages: [],
    //   name: location.name,
    // ));
    // context.read<HomeBloc>().add(FetchAspectsEvent());
    // if (location.aspectId != null) {
    //   context.read<HomeBloc>().add(FetchSubAspectsEvent(location.aspectId!));
    // }
    // if (location.subAspectId != null) {
    //   context.read<HomeBloc>().add(FetchCategoriesEvent(location.subAspectId!));
    // }
    //   });
    // _initBlocState(context);
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is EditMarkerSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.go(Routes.home);
          } else if (state is EditMarkerState) {
            print(
                "EditMarkerState: aspect=${state.selectedAspect}, subAspect=${state.selectedSubAspect}, category=${state.selectedCategory}");
            print(
                "EditMarkerState: aspects=${state.aspects.length}, subAspects=${state.subAspects.length}, categories=${state.categories.length}");
          } else if (state is EditMarkerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
            context
                .read<HomeBloc>()
                .add(FetchLocationDetailsEvent(widget.location.id));
          }
        },
        builder: (context, state) {
          // Loading state
          if (state is LocationLoading || state is EditMarkerLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          // Error state

          // Loaded state
          else if (state is EditMarkerState) {
            List<File> images =
                state.newImages.map((file) => File(file.path)).toList();
            return SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Header(headerText: 'Edit Marker'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 24.h),
                          _buildFormFields(context, state, images),
                          SizedBox(height: 32.h),
                          _buildActionButtons(context),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          // Fallback
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildFormFields(
      BuildContext context, HomeState state, List<File> images) {
    // Collect network images from the original marker
    final List<String> networkImages = widget.location.images
        .map<String>((img) {
          if (img is Map<String, dynamic>) {
            return img['image_path'] != null
                ? '${EndPoint.imageBaseUrl}${img['image_path']}'
                : '';
          } else if (img is String) {
            return '${EndPoint.imageBaseUrl}$img';
          } else if (img.imagePath != null) {
            return '${EndPoint.imageBaseUrl}${img.imagePath}';
          }
          return '';
        })
        .where((url) => url.isNotEmpty)
        .toList();
    // Local images from state
    final List<File> localImages = images;
    return Column(
      children: [
        _buildInputField(
          controller: _nameController,
          context: context,
          hintText: 'Location name',
          icon: Icons.location_on_outlined,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter location name' : null,
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: _buildAspectDropdown(context, state),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: DropDownSubAspect(
            key: ValueKey(
                'subaspect_${(state is EditMarkerState) ? state.subAspects.length : 0}_${(state is EditMarkerState) ? state.selectedSubAspect : 'null'}'),
            value: (state is EditMarkerState) ? state.selectedSubAspect : null,
            onChanged: (selectedId) {
              if (selectedId != null) {
                context
                    .read<HomeBloc>()
                    .add(SelectEditSubAspectEvent(selectedId));
                context.read<HomeBloc>().add(FetchCategoriesEvent(selectedId));
              }
            },
            isLoading:
                (state is EditMarkerState) ? state.isLoadingSubAspects : false,
            error: (state is EditMarkerState) ? state.subAspectsError : null,
            items: (state is EditMarkerState) ? state.subAspects : [],
          ),
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: DropDownCategory(
            key: ValueKey(
                'category_${(state is EditMarkerState) ? state.categories.length : 0}_${(state is EditMarkerState) ? state.selectedCategory : 'null'}'),
            value: (state is EditMarkerState) ? state.selectedCategory : null,
            onChanged: (selectedId) {
              if (selectedId != null) {
                context
                    .read<HomeBloc>()
                    .add(SelectEditCategoryEvent(selectedId));
              }
            },
            isLoading:
                (state is EditMarkerState) ? state.isLoadingCategories : false,
            error: (state is EditMarkerState) ? state.categoriesError : null,
            items: (state is EditMarkerState) ? state.categories : [],
          ),
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          controller: _descriptionController,
          hintText: 'Description',
          icon: Icons.description_outlined,
          context: context,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter description' : null,
        ),
        SizedBox(height: 16.h),
        _buildImageUploadField(context),
        SizedBox(
          height: 20.h,
        ),
        if (localImages.isNotEmpty || networkImages.isNotEmpty)
          _buildImageGallery(context, localImages, networkImages),
      ],
    );
  }

  Widget _buildInputField({
    required BuildContext context,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return InputTextFormField(
      controller: controller,
      hintText: hintText,
      hintStyle: TextStyle(color: Color(0xff787878)),
      textStyle:
          Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 16.sp),
      prefixIcon: Icon(icon, color: const Color(0xff787878)),
      validator: validator,
    );
  }

  Widget _buildAspectDropdown(BuildContext context, HomeState state) {
    return DropDownAspect(
      key: ValueKey(
          'aspect_${(state is EditMarkerState) ? state.aspects.length : 0}_${(state is EditMarkerState) ? state.selectedAspect : 'null'}'),
      value: (state is EditMarkerState) ? state.selectedAspect : null,
      onChanged: (selectedId) {
        if (selectedId != null) {
          context.read<HomeBloc>().add(SelectEditAspectEvent(selectedId));
          context.read<HomeBloc>().add(FetchSubAspectsEvent(selectedId));
        }
      },
      isLoading: (state is EditMarkerState) ? state.isLoadingAspects : false,
      error: (state is EditMarkerState) ? state.aspectsError : null,
      items: (state is EditMarkerState) ? state.aspects : [],
    );
  }

  Widget _buildImageUploadField(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleImageSelection(context),
      child: InputTextFormField(
        hintText: 'Upload files',
        hintStyle: TextStyle(color: Color(0xff787878), fontSize: 16.sp),
        enabled: false,
        prefixIcon: const Icon(Icons.image_outlined, color: Color(0xff787878)),
        suffixIcon: const Icon(Icons.upload, color: Color(0xff787878)),
      ),
    );
  }

  Widget _buildImageGallery(BuildContext context, List<File> localImages,
      List<String> networkImages) {
    // Combine both lists with type and index for removal
    final allImages = [
      ...networkImages.asMap().entries.map((entry) =>
          {'type': 'network', 'url': entry.value, 'index': entry.key}),
      ...localImages.asMap().entries.map(
          (entry) => {'type': 'file', 'file': entry.value, 'index': entry.key}),
    ];
    final networkCount = networkImages.length;
    return SizedBox(
      height: 120.w,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: allImages.length,
        separatorBuilder: (context, index) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final img = allImages[index];
          if (img['type'] == 'network') {
            return Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: CachedNetworkImage(
                  imageUrl: img['url'] as String,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xffd9d9d9),
                    child: const Icon(Icons.error),
                  ),
                  placeholder: (context, url) => Container(
                    color: const Color(0xffd9d9d9),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ),
              ),
            );
          } else {
            // Local image with remove button
            return Stack(
              children: [
                Container(
                  width: 120.w,
                  height: 120.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: Image.file(
                      img['file'] as File,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xffd9d9d9),
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  top: 4,
                  child: GestureDetector(
                    onTap: () {
                      final removeIndex = img['index'] as int;
                      final currentState = context.read<HomeBloc>().state;
                      if (currentState is EditMarkerState) {
                        final newImages =
                            List<File>.from(currentState.newImages);
                        if (removeIndex >= 0 &&
                            removeIndex < newImages.length) {
                          newImages.removeAt(removeIndex);
                          context
                              .read<HomeBloc>()
                              .add(UpdateEditMarkerImagesEvent(newImages));
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child:
                          const Icon(Icons.close, color: Colors.red, size: 16),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AuthButton(
            onPressed: () => _handleSave(context),
            text: 'Save',
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
            onPressed: () {
              context
                  .read<HomeBloc>()
                  .add(FetchLocationDetailsEvent(widget.location.id));
              context.pop();
            },
            text: 'Cancel',
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
}
