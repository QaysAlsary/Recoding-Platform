import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:recoding_platform_project/features/home/view/widgets/drop_down_sub_aspect.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/di/service_locator.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';
import '../../bloc/home_bloc.dart';
import '../../models/location_model.dart';

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
  late final TextEditingController _aspectController;
  late final TextEditingController _categoryController;
  late final TextEditingController _subAspectController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(text: widget.location.name);
    _descriptionController =
        TextEditingController(text: widget.location.description ?? '');
    _aspectController =
        TextEditingController(text: widget.location.aspect ?? '');
    _categoryController =
        TextEditingController(text: widget.location.category ?? '');
    _subAspectController =
        TextEditingController(text: widget.location.subAspect ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _aspectController.dispose();
    _categoryController.dispose();
    _subAspectController.dispose();
    super.dispose();
  }

  Future<void> _handleImageSelection() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> newImages = await picker.pickMultiImage();

    if (newImages.isNotEmpty) {
      final currentImages = (context.read<HomeBloc>().state is EditMarkerState)
          ? (context.read<HomeBloc>().state as EditMarkerState).newImages
          : <File>[];

      final List<File> combinedImages = [
        ...currentImages,
        ...newImages.map((x) => File(x.path)).toList(),
      ];

      context.read<HomeBloc>().add(UpdateEditMarkerImagesEvent(combinedImages));
    }
  }

  void _handleSave() {
    if (_formKey.currentState!.validate()) {
      _showConfirmationDialog();
    }
  }

  void _showConfirmationDialog() {
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
          onPressed: () => Navigator.of(context).pop(),
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
            Navigator.of(context).pop();
            _submitChanges();
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

  void _submitChanges() {
    final state = context.read<HomeBloc>().state;
    List<File> images = [];
    if (state is EditMarkerState) {
      images = state.newImages;
    }

    context.read<HomeBloc>().add(
          EditMarkerEvent(
            locationId: widget.location.id,
            name: _nameController.text,
            description: _descriptionController.text,
            aspect: _aspectController.text,
            subAspect: _subAspectController.text,
            category: _categoryController.text,
            newImages: images.map((file) => XFile(file.path)).toList(),
          ),
        );
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
    if (state is EditMarkerSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.blue,
        ),
      );
      context.go(Routes.home);
    } else if (state is EditMarkerError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  }

  Widget _buildBody(HomeState state) {
    List<File> images = [];
    if (state is EditMarkerState) {
      images = state.newImages;
    }

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
                  _buildFormFields(state, images),
                  SizedBox(height: 32.h),
                  _buildActionButtons(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormFields(HomeState state, List<File> images) {
    return Column(
      children: [
        _buildInputField(
          controller: _aspectController,
          hintText: 'Aspect',
          icon: Icons.language,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter aspect' : null,
        ),
        SizedBox(height: 16.h),
        _buildSubAspectDropdown(state),
        SizedBox(height: 16.h),
        _buildInputField(
          controller: _categoryController,
          hintText: 'Category',
          icon: Icons.grid_view,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter category' : null,
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          controller: _nameController,
          hintText: 'Location name',
          icon: Icons.location_on,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter location name' : null,
        ),
        SizedBox(height: 16.h),
        _buildInputField(
          controller: _descriptionController,
          hintText: 'Description',
          icon: Icons.description,
          validator: (value) =>
              value?.isEmpty ?? true ? 'Please enter description' : null,
        ),
        SizedBox(height: 16.h),
        _buildImageUploadField(),
        if (images.isNotEmpty || widget.location.images.isNotEmpty)
          _buildImageGallery(images),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return InputTextFormField(
      controller: controller,
      hintText: hintText,
      prefixIcon: Icon(icon, color: const Color(0xff787878)),
      validator: validator,
    );
  }

  Widget _buildSubAspectDropdown(HomeState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: DropDownSubAspect(
        value: (state is EditMarkerState)
            ? state.selectedSubAspect
            : widget.location.subAspect,
        onChanged: (value) {
          if (value != null) {
            context.read<HomeBloc>().add(SelectEditSubAspectEvent(value));
          }
        },
      ),
    );
  }

  Widget _buildImageUploadField() {
    return GestureDetector(
      onTap: _handleImageSelection,
      child: InputTextFormField(
        hintText: 'Upload files',
        enabled: false,
        prefixIcon:
            const Icon(Icons.cloud_upload_outlined, color: Color(0xff787878)),
        suffixIcon: const Icon(Icons.upload, color: Color(0xff787878)),
      ),
    );
  }

  Widget _buildImageGallery(List<File> images) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: SizedBox(
        height: 80,
        child: ListView.separated(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: images.length + widget.location.images.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) => _buildImageItem(index, images),
        ),
      ),
    );
  }

  Widget _buildImageItem(int index, List<File> images) {
    if (index < images.length) {
      return _buildNewImageItem(images[index], index);
    } else {
      return _buildExistingImageItem(
          widget.location.images[index - images.length]);
    }
  }

  Widget _buildNewImageItem(File image, int index) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xffe0e0e0),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              image,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          _buildRemoveImageButton(index),
        ],
      ),
    );
  }

  Widget _buildExistingImageItem(dynamic img) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xffe0e0e0),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              '${EndPoint.baseUrl}${img['imagePath'] ?? img.imagePath}',
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          _buildRemoveImageButton(-1),
        ],
      ),
    );
  }

  Widget _buildRemoveImageButton(int index) {
    return Positioned(
      right: 4,
      top: 4,
      child: GestureDetector(
        onTap: () {
          if (index >= 0) {
            final newImages = List<File>.from(
              (context.read<HomeBloc>().state as EditMarkerState).newImages,
            );
            newImages.removeAt(index);
            context
                .read<HomeBloc>()
                .add(UpdateEditMarkerImagesEvent(newImages));
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
          child: const Icon(Icons.close, color: Colors.red, size: 16),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: AuthButton(
            onPressed: _handleSave,
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
