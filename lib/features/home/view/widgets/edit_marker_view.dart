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
import 'package:recoding_platform_project/features/home/view/widgets/edit_build_gallery.dart';
import 'package:recoding_platform_project/features/home/view/widgets/edit_progress_indicator.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import '../../bloc/home_bloc.dart';
import '../../models/location_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

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

  // Max file sizes in bytes
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB
  static const int maxPdfTxtSize = 20 * 1024 * 1024; // 20MB
  static const String recommendedSizeMsg =
      'Recommended: Images ≤ 2MB, PDF/TXT ≤ 5MB for best performance.';

  void _showSizeError(String type, int maxMB) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '$type file is too large. Max allowed is $maxMB MB. $recommendedSizeMsg'),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _handleImageSelection(BuildContext context) async {
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
    // Check size
    for (final img in filteredImages) {
      final file = File(img.path);
      final size = await file.length();
      if (size > maxImageSize) {
        _showSizeError('Image', 10);
        return;
      }
    }
    if (filteredImages.isNotEmpty && mounted) {
      final currentImages = (homeBloc.state is EditMarkerState)
          ? (homeBloc.state as EditMarkerState)
              .newImages
              .map((file) => XFile(file.path))
              .toList()
          : <XFile>[];
      final List<XFile> combinedImages = [
        ...currentImages,
        ...filteredImages,
      ];
      if (mounted) {
        homeBloc.add(UpdateEditMarkerImagesEvent(
            combinedImages.map((x) => File(x.path)).toList()));
      }
    }
  }

  Future<void> _handleFileSelection(BuildContext context) async {
    HapticFeedback.selectionClick();
    final homeBloc = context.read<HomeBloc>();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty && mounted) {
      for (final file in result.files) {
        if (file.size > maxPdfTxtSize) {
          _showSizeError('PDF/TXT', 20);
          return;
        }
      }
      final currentFiles = (homeBloc.state is EditMarkerState)
          ? (homeBloc.state as EditMarkerState)
              .newPdfs
              .map((file) => XFile(file.path))
              .toList()
          : <XFile>[];
      final newFiles = result.files
          .map((file) => XFile(file.path!, name: file.name))
          .toList();
      final updatedFiles = [...currentFiles, ...newFiles];
      if (mounted) {
        homeBloc.add(UpdateEditMarkerPdfsEvent(
            updatedFiles.map((x) => File(x.path)).toList()));
      }
    }
  }

  Widget _buildImageUploadField(BuildContext context) {
    return GestureDetector(
      onTap: () => _showFileTypeDialog(context),
      child: InputTextFormField(
        hintText: 'Upload files',
        hintStyle: TextStyle(color: Color(0xff787878), fontSize: 16.sp),
        enabled: false,
        prefixIcon: const Icon(Icons.upload_file, color: Color(0xff787878)),
        suffixIcon: const Icon(Icons.upload, color: Color(0xff787878)),
      ),
    );
  }

  void _showFileTypeDialog(BuildContext context) {
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
                  SizedBox(height: 8.h),
                  Text(
                    recommendedSizeMsg,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
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
                        _handleImageSelection(context);
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
                        _handleFileSelection(context);
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

  void _handleSave(BuildContext context) {
    HapticFeedback.mediumImpact();
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
              Icon(
                Icons.save_outlined,
                size: 48.sp,
                color: const Color(0xff6ab3d9),
              ),
              SizedBox(height: 16.h),
              Text(
                'Confirm Changes',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Are you sure you want to save these changes?',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side:
                            BorderSide(color: Colors.grey.shade400, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        context.pop();
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff6ab3d9),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        context.pop();
                        _submitChanges(context);
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
    List<XFile> pdfs = (state is EditMarkerState)
        ? state.newPdfs.map((file) => XFile(file.path)).toList()
        : <XFile>[];
    // context.read<HomeBloc>().add(
    //       UploadFilesEvent(
    //         locationId: widget.location.id,
    //         newImages: images,
    //         newPdfs: pdfs,
    //       ),
    //     );
    context.read<HomeBloc>().add(
          EditMarkerEvent(
            locationId: widget.location.id,
            name: _nameController.text,
            description: _descriptionController.text,
            aspect: aspectId,
            subAspect: subAspectId,
            category: categoryId,
            newImages: images,
            newPdfs: pdfs,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is EditMarkerSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 3),
              ),
            );
            context.go(Routes.home);
          } else if (state is EditMarkerError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
            context
                .read<HomeBloc>()
                .add(FetchLocationDetailsEvent(widget.location.id));
          } else if (state is DeleteReferenceFileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            context
                .read<HomeBloc>()
                .add(FetchLocationDetailsEvent(widget.location.id));
          } else if (state is DeleteImageSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
            context
                .read<HomeBloc>()
                .add(FetchLocationDetailsEvent(widget.location.id));
          } else if (state is DeleteReferenceFileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
            context
                .read<HomeBloc>()
                .add(FetchLocationDetailsEvent(widget.location.id));
          } else if (state is DeleteImageError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
            context
                .read<HomeBloc>()
                .add(FetchLocationDetailsEvent(widget.location.id));
          }
        },
        builder: (context, state) {
          final isDeleteLoading = state is DeleteReferenceFileLoading ||
              state is DeleteImageLoading;
          if (state is EditMarkerLoading) {
            return Column(
              children: [
                const Header(headerText: 'Edit Marker'),
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
                          'Updating marker information...',
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

          if (state is EditMarkerState) {
            List<File> images =
                state.newImages.map((file) => File(file.path)).toList();

            return Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const Header(headerText: 'Edit Marker'),
                        SizedBox(height: 24.h),
                        if (!isDeleteLoading &&
                            (state.isUploading ||
                                state.overallProgress > 0.0)) ...[
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: EditProgressIndicator(state: state),
                          ),
                          SizedBox(height: 16.h),
                        ],
                        Opacity(
                          opacity: state.isUploading ? 0.6 : 1.0,
                          child: AbsorbPointer(
                            absorbing: state.isUploading,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              child: _buildFormFields(context, state, images),
                            ),
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Opacity(
                          opacity: state.isUploading ? 0.6 : 1.0,
                          child: AbsorbPointer(
                            absorbing: state.isUploading,
                            child: _buildActionButtons(context),
                          ),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
                if (isDeleteLoading)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.4),
                      child: Center(
                        child: Shimmer.fromColors(
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
                      ),
                    ),
                  ),
              ],
            );
          }

          // Fallback for other states
          return Center(
            child: Shimmer.fromColors(
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
          );
        },
      ),
    ));
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

        if (state is EditMarkerState)
          EditBuildGallery(
            state: state,
            location: state.location ?? widget.location,
            onRemoveNewImage: (file) {
              final currentState = context.read<HomeBloc>().state;
              if (currentState is EditMarkerState) {
                final newImages = List<File>.from(currentState.newImages);
                newImages.removeWhere((f) => f.path == file.path);
                context
                    .read<HomeBloc>()
                    .add(UpdateEditMarkerImagesEvent(newImages));
              }
            },
            onRemoveNewFile: (file) {
              final currentState = context.read<HomeBloc>().state;
              if (currentState is EditMarkerState) {
                final newPdfs = List<File>.from(currentState.newPdfs);
                newPdfs.removeWhere((f) => f.path == file.path);
                context
                    .read<HomeBloc>()
                    .add(UpdateEditMarkerPdfsEvent(newPdfs));
              }
            },
            onRemoveOldFile: (fileData) async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => Dialog(
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
                          Icon(
                            Icons.delete_outline,
                            size: 48.sp,
                            color: Colors.red.shade400,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Delete File',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Are you sure you want to delete this file?',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    side: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                    textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('No'),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                    textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Yes'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              if (confirmed == true) {
                final fileId = fileData['id'] as int?;
                if (fileId != null) {
                  context.read<HomeBloc>().add(DeleteReferenceFileEvent(
                      locationId: widget.location.id, fileId: fileId));
                }
              }
            },
            onRemoveOldImage: (imageUrl) async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (ctx) => Dialog(
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
                          Icon(
                            Icons.delete_outline,
                            size: 48.sp,
                            color: Colors.red.shade400,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'Delete Image',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Are you sure you want to delete this image?',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.grey.shade700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.h),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    side: BorderSide(
                                        color: Colors.grey.shade400,
                                        width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                    textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(ctx).pop(false),
                                  child: const Text('No'),
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade400,
                                    foregroundColor: Colors.white,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(vertical: 14.h),
                                    textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () => Navigator.of(ctx).pop(true),
                                  child: const Text('Yes'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
              if (confirmed == true) {
                // Find the image id from location.images
                final images = widget.location.images;
                int? imageId;
                for (final img in images) {
                  if (img is Map<String, dynamic> &&
                      img['image_path'] != null) {
                    final url = '${EndPoint.imageBaseUrl}${img['image_path']}';
                    if (url == imageUrl) {
                      imageId = img['id'] as int?;
                      break;
                    }
                  } else if (img is String) {
                    final url = '${EndPoint.imageBaseUrl}$img';
                    if (url == imageUrl) {
                      // If image is string, you may not have id
                      // You may need to adjust this logic if id is required
                    }
                  }
                }
                if (imageId != null) {
                  context.read<HomeBloc>().add(DeleteImageEvent(
                      locationId: widget.location.id, imageId: imageId));
                }
              }
            },
          ),
        // SizedBox(height: 20.h),
        // _buildPdfsField(state),
        // _buildGallery(state, localImages, networkImages)
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

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: AuthButton(
              onPressed: () => _handleSave(context),
              text: 'Save',
              buttonWidth: double.infinity,
              buttonHeight: 50.h,
              backGroundColor: Color(0xff6ab3d9),
              textColor: Colors.white,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: AuthButton(
              onPressed: () {
                HapticFeedback.selectionClick();
                context
                    .read<HomeBloc>()
                    .add(FetchLocationDetailsEvent(widget.location.id));
                context.pop();
              },
              text: 'Cancel',
              buttonWidth: double.infinity,
              buttonHeight: 50.h,
              sideBar: true,
            ),
          ),
        ],
      ),
    );
  }
}
