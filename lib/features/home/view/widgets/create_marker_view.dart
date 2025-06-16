import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';
import 'package:recoding_platform_project/features/home/view/widgets/drop_down_sub_aspect.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';
import 'package:latlong2/latlong.dart';

class CreateMarkerView extends StatefulWidget {
  final double initialLatitude;
  final double initialLongitude;

  const CreateMarkerView({
    super.key,
    this.initialLatitude = 0.0,
    this.initialLongitude = 0.0,
  });

  @override
  State<CreateMarkerView> createState() => _CreateMarkerViewState();
}

class _CreateMarkerViewState extends State<CreateMarkerView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aspectIdController = TextEditingController();
  final TextEditingController _subAspectIdController = TextEditingController();
  final TextEditingController _categoryIdController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _aspectIdController.dispose();
    _subAspectIdController.dispose();
    _categoryIdController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleImageSelection() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> newImages = await picker.pickMultiImage();
    if (newImages.isNotEmpty) {
      final currentImages =
          (context.read<HomeBloc>().state is CreateMarkerFormState)
              ? (context.read<HomeBloc>().state as CreateMarkerFormState)
                  .selectedImages
              : <XFile>[];
      final updatedImages = [...currentImages, ...newImages];
      context
          .read<HomeBloc>()
          .add(UpdateCreateMarkerImagesEvent(updatedImages));
    }
  }

  void _createMarker() {
    if (_formKey.currentState!.validate()) {
      final currentImages =
          (context.read<HomeBloc>().state is CreateMarkerFormState)
              ? (context.read<HomeBloc>().state as CreateMarkerFormState)
                  .selectedImages
              : <XFile>[];

      context.read<HomeBloc>().add(CreateMarkerEvent(
            name: _nameController.text,
            aspectId: _aspectIdController.text,
            subAspectId: _subAspectIdController.text,
            categoryId: _categoryIdController.text,
            latitude: widget.initialLatitude,
            longitude: widget.initialLongitude,
            description: _descriptionController.text,
            images: currentImages,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is CreateMarkerSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            context.pop(); // Navigate back on success
          } else if (state is CreateMarkerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final selectedImages = (state is CreateMarkerFormState)
              ? state.selectedImages
              : <XFile>[]; // Get images from state
          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Header(
                    headerText: "Create Marker",
                  ),
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputField(
                            controller: _nameController,
                            hintText: "Name",
                            icon: Icons.text_fields,
                            validator: (value) =>
                                value!.isEmpty ? 'Please enter a name' : null),
                        SizedBox(height: 16.h),
                        _buildInputField(
                            controller: _aspectIdController,
                            hintText: "Aspect",
                            icon: Icons.sync,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter an aspect'
                                : null),
                        SizedBox(height: 16.h),
                        _buildSubAspectDropdown(state),
                        SizedBox(height: 16.h),
                        _buildInputField(
                            controller: _categoryIdController,
                            hintText: "Category",
                            icon: Icons.category_outlined,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter a category'
                                : null),
                        SizedBox(height: 16.h),
                        _buildInputField(
                            controller: _descriptionController,
                            hintText: "Description",
                            icon: Icons.description_outlined,
                            validator: (value) => value!.isEmpty
                                ? 'Please enter description'
                                : null),
                        SizedBox(height: 16.h),
                        _buildImageUploadField(),
                        SizedBox(
                          height: 8,
                        ),
                        if (selectedImages.isNotEmpty)
                          _buildImageGallery(selectedImages),
                        SizedBox(height: 30.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AuthButton(
                              onPressed: _createMarker,
                              buttonWidth: 152.w,
                              text: "Create",
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                              buttonStyle: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xff6ab3d9),
                                foregroundColor: AppColors.black073,
                                elevation: 0,
                                overlayColor: Color(0xff6ab3d9),
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            AuthButton(
                              onPressed: () {
                                context.pop();
                              },
                              text: 'Cancel',
                              buttonWidth: 152.w,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return InputTextFormField(
      controller: controller,
      hintText: hintText,
      prefixIcon: Icon(icon, color: const Color(0xff787878)),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  Widget _buildSubAspectDropdown(HomeState state) {
    return DropDownSubAspect(
      onChanged: (value) {
        // Handle sub-aspect selection if needed
      },
    );
  }

  Widget _buildImageUploadField() {
    return GestureDetector(
      onTap: _handleImageSelection,
      child: InputTextFormField(
        hintText: "Upload images",
        enabled: false,
        prefixIcon:
            const Icon(Icons.cloud_upload_outlined, color: Color(0xff787878)),
        suffixIcon: const Icon(Icons.upload_rounded),
      ),
    );
  }

  Widget _buildImageGallery(List<XFile> selectedImages) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: selectedImages.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) => _buildImageItem(index, selectedImages),
      ),
    );
  }

  Widget _buildImageItem(int index, List<XFile> selectedImages) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.file(
            File(selectedImages[index].path),
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        _buildRemoveImageButton(index, selectedImages),
      ],
    );
  }

  Widget _buildRemoveImageButton(int index, List<XFile> selectedImages) {
    return Positioned(
      right: 4,
      top: 4,
      child: GestureDetector(
        onTap: () {
          context.read<HomeBloc>().add(RemoveCreateMarkerImageEvent(index));
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
          child: const Icon(Icons.close, color: Colors.red, size: 16),
        ),
      ),
    );
  }
}
