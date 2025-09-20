import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';
import 'package:recoding_platform_project/features/home/view/widgets/drop_down_aspect.dart';
import 'package:recoding_platform_project/features/home/view/widgets/drop_down_category.dart';
import 'package:recoding_platform_project/features/home/view/widgets/drop_down_sub_aspect.dart';
import 'package:recoding_platform_project/features/home/view/widgets/progress_indicator.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

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
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(InitCreateMarkerEvent());
    context.read<HomeBloc>().add(FetchAspectsEvent());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleImageSelection() async {
    HapticFeedback.selectionClick();
    final ImagePicker picker = ImagePicker();
    final homeBloc = context.read<HomeBloc>();
    final List<XFile> newImages =
        await picker.pickMultiImage(imageQuality: 100);
    // Filter only jpeg, jpg, png
    final filteredImages = newImages.where((img) {
      final ext = img.name.toLowerCase();
      return ext.endsWith('.jpg') ||
          ext.endsWith('.jpeg') ||
          ext.endsWith('.png');
    }).toList();
    if (filteredImages.isNotEmpty && mounted) {
      final currentImages = (homeBloc.state is CreateMarkerFormState)
          ? (homeBloc.state as CreateMarkerFormState).selectedImages
          : <XFile>[];
      final updatedImages = [...currentImages, ...filteredImages];

      if (mounted) {
        homeBloc.add(UpdateCreateMarkerImagesEvent(updatedImages));
      }
    }
  }

  Future<void> _handleFileSelection() async {
    HapticFeedback.selectionClick();
    final homeBloc = context.read<HomeBloc>();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty && mounted) {
      final currentFiles = (homeBloc.state is CreateMarkerFormState)
          ? (homeBloc.state as CreateMarkerFormState).selectedPdfs
          : <XFile>[];
      final newFiles = result.files
          .map((file) => XFile(file.path!, name: file.name))
          .toList();
      final updatedFiles = [...currentFiles, ...newFiles];
      if (mounted) {
        homeBloc.add(UpdateCreateMarkerPdfsEvent(updatedFiles));
      }
    }
  }

  void _createMarker() {
    HapticFeedback.mediumImpact();
    if (_formKey.currentState!.validate()) {
      final state = context.read<HomeBloc>().state;
      final currentImages =
          (state is CreateMarkerFormState) ? state.selectedImages : <XFile>[];
      final currentPdfs =
          (state is CreateMarkerFormState) ? state.selectedPdfs : <XFile>[];

      final aspectId =
          (state is CreateMarkerFormState) ? state.selectedAspect : null;
      final subAspectId =
          (state is CreateMarkerFormState) ? state.selectedSubAspect : null;
      final categoryId =
          (state is CreateMarkerFormState) ? state.selectedCategory : null;

      context.read<HomeBloc>().add(CreateMarkerEvent(
            name: _nameController.text,
            aspectId: aspectId,
            subAspectId: subAspectId,
            categoryId: categoryId,
            latitude: widget.initialLatitude,
            longitude: widget.initialLongitude,
            description: _descriptionController.text,
            images: currentImages,
            pdfs: currentPdfs,
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
          if (state is CreateMarkerLoading) {
            return Column(
              children: [
                const Header(headerText: 'Create Marker'),
                SizedBox(height: 24.h),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Creating marker...',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          final selectedImages = (state is CreateMarkerFormState)
              ? state.selectedImages
              : <XFile>[]; // Get images from state
          final selectedPdfs =
              (state is CreateMarkerFormState) ? state.selectedPdfs : <XFile>[];
          final isUploading =
              (state is CreateMarkerFormState) ? state.isUploading : false;
          return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  Header(headerText: "Create Marker"),
                  SizedBox(height: 20.h),

                  // Progress indicator stays outside opacity wrapper
                  if (state is CreateMarkerFormState && state.isUploading)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      child: UploadProgressIndicator(state: state),
                    ),

                  // Wrap the rest of the form in Opacity + AbsorbPointer
                  Opacity(
                    opacity:
                        (state is CreateMarkerFormState && state.isUploading)
                            ? 0.6
                            : 1.0,
                    child: AbsorbPointer(
                      absorbing:
                          (state is CreateMarkerFormState && state.isUploading),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputField(
                              controller: _nameController,
                              hintText: "Name",
                              icon: Icons.location_on_outlined,
                              validator: (value) =>
                                  value!.isEmpty ? 'Please enter a name' : null,
                            ),
                            SizedBox(height: 16.h),
                            DropDownAspect(
                              value: (state is CreateMarkerFormState)
                                  ? state.selectedAspect
                                  : null,
                              onChanged: (selectedId) {
                                if (selectedId != null) {
                                  context
                                      .read<HomeBloc>()
                                      .add(SelectCreateAspectEvent(selectedId));
                                  context
                                      .read<HomeBloc>()
                                      .add(FetchSubAspectsEvent(selectedId));
                                }
                              },
                              isLoading: (state is CreateMarkerFormState)
                                  ? state.isLoadingAspects
                                  : false,
                              error: (state is CreateMarkerFormState)
                                  ? state.aspectsError
                                  : null,
                              items: (state is CreateMarkerFormState)
                                  ? state.aspects
                                  : [],
                            ),
                            SizedBox(height: 16.h),
                            DropDownSubAspect(
                              value: (state is CreateMarkerFormState)
                                  ? state.selectedSubAspect
                                  : null,
                              onChanged: (selectedId) {
                                if (selectedId != null) {
                                  context.read<HomeBloc>().add(
                                      SelectCreateSubAspectEvent(selectedId));
                                  context
                                      .read<HomeBloc>()
                                      .add(FetchCategoriesEvent(selectedId));
                                }
                              },
                              isLoading: (state is CreateMarkerFormState)
                                  ? state.isLoadingSubAspects
                                  : false,
                              error: (state is CreateMarkerFormState)
                                  ? state.subAspectsError
                                  : null,
                              items: (state is CreateMarkerFormState)
                                  ? state.subAspects
                                  : [],
                            ),
                            SizedBox(height: 16.h),
                            DropDownCategory(
                              value: (state is CreateMarkerFormState)
                                  ? state.selectedCategory
                                  : null,
                              onChanged: (selectedId) {
                                if (selectedId != null) {
                                  context.read<HomeBloc>().add(
                                      SelectCreateCategoryEvent(selectedId));
                                }
                              },
                              isLoading: (state is CreateMarkerFormState)
                                  ? state.isLoadingCategories
                                  : false,
                              error: (state is CreateMarkerFormState)
                                  ? state.categoriesError
                                  : null,
                              items: (state is CreateMarkerFormState)
                                  ? state.categories
                                  : [],
                            ),
                            SizedBox(height: 16.h),
                            _buildInputField(
                              controller: _descriptionController,
                              hintText: "Description",
                              icon: Icons.description_outlined,
                              validator: (value) => value!.isEmpty
                                  ? 'Please enter description'
                                  : null,
                            ),
                            SizedBox(height: 16.h),
                            _buildImageUploadField(),
                            SizedBox(height: 8.h),
                            if (selectedImages.isNotEmpty ||
                                selectedPdfs.isNotEmpty)
                              _buildImageGallery(selectedImages, selectedPdfs),
                            SizedBox(height: 30.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                AuthButton(
                                  onPressed: _createMarker,
                                  buttonWidth: 152.w,
                                  text: "Create",
                                  backGroundColor: Color(0xff6ab3d9),
                                  textColor: Colors.white,
                                ),
                                AuthButton(
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    context.pop();
                                  },
                                  sideBar: true,
                                  text: 'Cancel',
                                  buttonWidth: 152.w,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .labelMedium
                                      ?.copyWith(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
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

  Widget _buildImageUploadField() {
    return GestureDetector(
      onTap: () => _showFileTypeDialog(),
      child: InputTextFormField(
        hintText: "Upload files",
        enabled: false,
        prefixIcon: const Icon(Icons.upload_file, color: Color(0xff787878)),
        suffixIcon: const Icon(Icons.upload_rounded),
      ),
    );
  }

  void _showFileTypeDialog() {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Card(
            color: Colors.white,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select File Type',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.image_outlined,
                        color: const Color(0xff6ab3d9),
                        size: 24.sp,
                      ),
                      title: Text(
                        'Images (jpeg, jpg, png)',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.of(context).pop();
                        _handleImageSelection();
                      },
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: ListTile(
                      leading: Icon(
                        Icons.insert_drive_file,
                        color: const Color(0xff6ab3d9),
                        size: 24.sp,
                      ),
                      title: Text(
                        'Files (pdf, txt)',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        HapticFeedback.selectionClick();
                        Navigator.of(context).pop();
                        _handleFileSelection();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageGallery(
      List<XFile> selectedImages, List<XFile> selectedPdfs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedImages.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: selectedImages.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) =>
                  _buildImageItem(index, selectedImages),
            ),
          ),
        if (selectedPdfs.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: selectedPdfs.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) =>
                  _buildPdfItem(index, selectedPdfs),
            ),
          ),
      ],
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
          HapticFeedback.selectionClick();
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

  Widget _buildPdfItem(int index, List<XFile> selectedPdfs) {
    final pdf = selectedPdfs[index];
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[400]!),
          ),
          child: Center(
            child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 40),
          ),
        ),
        _buildRemovePdfButton(index, selectedPdfs),
        Positioned(
          bottom: -24,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              pdf.name,
              style: TextStyle(fontSize: 12, color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRemovePdfButton(int index, List<XFile> selectedPdfs) {
    return Positioned(
      right: 4,
      top: 4,
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          context.read<HomeBloc>().add(RemoveCreateMarkerPdfEvent(index));
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
