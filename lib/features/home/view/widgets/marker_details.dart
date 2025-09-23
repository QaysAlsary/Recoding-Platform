import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:recoding_platform_project/features/home/models/marker_model.dart';
import 'package:recoding_platform_project/src/components/input_text_form_field.dart';
import 'package:recoding_platform_project/src/components/auth_button.dart';
import 'package:recoding_platform_project/src/components/header.dart';
import 'package:recoding_platform_project/src/core/api/end_ponits.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';
import '../../bloc/home_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';

class MarkerDetailsPanel extends StatefulWidget {
  final MarkerData marker;

  const MarkerDetailsPanel({
    super.key,
    required this.marker,
  });

  @override
  State<MarkerDetailsPanel> createState() => _MarkerDetailsPanelState();
}

class _MarkerDetailsPanelState extends State<MarkerDetailsPanel> {
  final ScrollController _descScrollController = ScrollController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Store a map of notificationId to filePath for opening on tap
  final Map<int, String> _downloadedFilePaths = {};
  int _notificationIdCounter = 1;

  // Add this flag
  bool _pendingNavigation = false;

  @override
  void initState() {
    super.initState();
    final homeBloc = context.read<HomeBloc>();
    homeBloc.add(FetchLocationDetailsEvent(widget.marker.id));
    _initializeNotifications();
    // Do NOT fetch sub-aspects or categories here; wait for LocationLoaded
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        final filePath = response.payload;
        if (filePath != null && filePath.isNotEmpty) {
          await OpenFilex.open(filePath);
        }
      },
    );
  }

  Future<void> _showDownloadProgressNotification(int notificationId,
      String title, String body, int progress, String filePath) async {
    final androidDetails = AndroidNotificationDetails(
      'downloads',
      'Downloads',
      channelDescription: 'Download progress notifications',
      importance: Importance.high,
      priority: Priority.high,
      showProgress: true,
      maxProgress: 100,
      progress: progress,
      onlyAlertOnce: true,
      ongoing: progress < 100,
    );
    final details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      title,
      body,
      details,
      payload: filePath,
    );
  }

  Future<void> _showDownloadCompleteNotification(
      int notificationId, String fileName, String filePath) async {
    final androidDetails = AndroidNotificationDetails(
      'downloads',
      'Downloads',
      channelDescription: 'Download complete',
      importance: Importance.high,
      priority: Priority.high,
      onlyAlertOnce: true,
    );
    final details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      notificationId,
      'Download Complete',
      '$fileName downloaded. Tap to open.',
      details,
      payload: filePath,
    );
  }

  @override
  void dispose() {
    _descScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) => _handleStateChanges(context, state),
      builder: (context, state) {
        if (_pendingNavigation) {
          return _buildDeleteLoadingState();
        }
        return _buildBody(state);
      },
    )));
  }

  void _handleStateChanges(BuildContext context, HomeState state) {
    if (state is DeleteMarkerSuccess) {
      setState(() {
        _pendingNavigation = true;
      });
      // No snackbar, just loading
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          context.go(Routes.home);
        }
      });
    } else if (state is DeleteMarkerError) {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildBody(HomeState state) {
    // Handle error states
    if (state is LocationError) {
      return _buildErrorState(state.message);
    }

    // Handle delete states
    if (state is DeleteMarkerLoading) {
      return _buildDeleteLoadingState();
    }

    if (state is LocationLoading) {
      return _buildLoadingState();
    }

    if (state is EditMarkerState) {
      return _buildLoadedContent(state);
    }
    return _buildErrorState("Something went wrong");
  }

  Widget _buildLoadingState() {
    return Scaffold(
      body: Column(
        children: [
          const Header(headerText: 'Marker Details'),
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
                    'Loading marker details...',
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
      ),
    );
  }

  Widget _buildDeleteLoadingState() {
    return Scaffold(
      body: Column(
        children: [
          const Header(headerText: 'Marker Details'),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.red.shade400,
                    strokeWidth: 3.0,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Deleting marker...',
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
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Scaffold(
      body: Column(
        children: [
          const Header(headerText: 'Marker Details'),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Colors.red[300],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    message,
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      context
                          .read<HomeBloc>()
                          .add(FetchLocationDetailsEvent(widget.marker.id));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedContent(EditMarkerState state) {
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
                _buildDetailsContent(state),
                SizedBox(height: 20.h),
                _buildActionButtons(state),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkerName(EditMarkerState state) {
    return Text(
      state.location!.name,
      style: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(fontSize: 24.sp, fontWeight: FontWeight.w400
              // fontWeight: FontWeight.bold,
              ),
    );
  }

  Widget _buildDetailsContent(EditMarkerState state) {
    final homeBloc = context.read<HomeBloc>();

    final aspectName = state.location!.aspectId != null
        ? homeBloc.getAspectNameById(state.location!.aspectId!) ?? 'N/A'
        : 'N/A';
    final subAspectName = state.location!.subAspectId != null
        ? homeBloc.getSubAspectNameById(state.location!.subAspectId!) ?? 'N/A'
        : 'N/A';
    final categoryName = state.location!.categoryId != null
        ? homeBloc.getCategoryNameById(state.location!.categoryId!) ?? 'N/A'
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
          'Location name: ${state.location!.name}',
          Icons.location_on_outlined,
        ),
        SizedBox(height: 20.h),
        _buildDescriptionField(state),
        SizedBox(height: 20.h),
        _buildImagesField(state),
        SizedBox(height: 20.h),
        _buildPdfsField(state),
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

  Widget _buildDescriptionField(EditMarkerState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailField(
          'Description:',
          Icons.description_outlined,
        ),
        SizedBox(height: 15.h),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 100.h,
            minHeight: 0,
          ),
          child: Scrollbar(
            controller: _descScrollController,
            interactive: true,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _descScrollController,
              physics: const BouncingScrollPhysics(),
              child: Text(
                state.location!.description ?? 'No description available',
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

  Widget _buildImagesField(EditMarkerState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailField(
          'Images:',
          Icons.image_outlined,
        ),
        SizedBox(height: 14.h),
        if (state.location!.images.isNotEmpty)
          SizedBox(
            height: 120.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: state.location!.images.length,
              separatorBuilder: (context, index) => SizedBox(width: 8.w),
              itemBuilder: (context, index) =>
                  _buildImageItem(state.location!.images[index]),
            ),
          )
        else
          _buildEmptyState('No images available', Icons.image_outlined),
      ],
    );
  }

  Widget _buildPdfsField(EditMarkerState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailField(
          'Files:',
          Icons.attach_file,
        ),
        SizedBox(height: 14.h),
        if (state.location!.references.isNotEmpty)
          SizedBox(
            height: 120.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: state.location!.references.length,
              separatorBuilder: (context, index) => SizedBox(width: 8.w),
              itemBuilder: (context, index) =>
                  _buildFileItem(state.location!.references[index]),
            ),
          )
        else
          _buildEmptyState('No files available', Icons.attach_file),
      ],
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      height: 120.w,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 32.sp,
            color: Colors.grey[400],
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFileItem(dynamic file) {
    String? fileName;
    String? filePath;
    String? fileExtension;

    if (file is Map<String, dynamic>) {
      fileName = file['file_name'] as String?;
      filePath =
          file['pdf_path'] as String?; // Keep the same key name from backend
    } else {
      fileName = file.fileName;
      filePath = file.pdfPath; // Keep the same property name
    }

    // Extract file extension from filename or path
    if (fileName != null && fileName.contains('.')) {
      fileExtension = fileName.split('.').last.toLowerCase();
    } else if (filePath != null && filePath.contains('.')) {
      fileExtension = filePath.split('.').last.toLowerCase();
    }

    // Choose icon based on file extension
    IconData fileIcon = _getFileIcon(fileExtension);

    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(fileIcon, color: Colors.red, size: 40),
          ),
          Positioned(
            bottom: 8,
            left: 8,
            right: 8,
            child: Text(
              fileName ?? 'File',
              style: TextStyle(fontSize: 12, color: Colors.black),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
          // Download icon in top-right corner
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                _downloadFile(filePath, fileName);
              },
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 16.r,
                ),
              ),
            ),
          ),
        ],
      ),
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
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl:
                  imagePath != null ? EndPoint.imageBaseUrl + imagePath : '',
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: const Color(0xffd9d9d9),
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
              errorWidget: (context, url, error) => Container(
                color: const Color(0xffd9d9d9),
                child: const Icon(Icons.error),
              ),
            ),
            // Download icon in top-right corner
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  _downloadImage(imagePath);
                },
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Icon(
                    Icons.download,
                    color: Colors.white,
                    size: 16.r,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _downloadImage(String? imagePath) async {
    if (imagePath == null) return;
    final String downloadUrl = EndPoint.imageBaseUrl + imagePath;
    final String fileName = imagePath.split('/').last;
    final int notificationId = _notificationIdCounter++;

    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Storage permission required to download files'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      // Show download started notification
      await _showDownloadProgressNotification(notificationId, 'Downloading...',
          'Starting download of $fileName', 0, '');

      String? downloadsPath;
      if (Platform.isAndroid) {
        downloadsPath = '/storage/emulated/0/Download';
        if (!Directory(downloadsPath).existsSync()) {
          downloadsPath = '/storage/emulated/0/Downloads';
        }
        if (!Directory(downloadsPath).existsSync()) {
          final externalDir = await getExternalStorageDirectory();
          downloadsPath = externalDir?.path;
        }
      } else {
        final documentsDir = await getApplicationDocumentsDirectory();
        downloadsPath = documentsDir.path;
      }

      if (downloadsPath == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not access downloads folder'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final String filePath = '$downloadsPath/$fileName';
      final File file = File(filePath);

      final Response response = await Dio().get(
        downloadUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).round();
            _showDownloadProgressNotification(notificationId, 'Downloading...',
                'Downloading $fileName ($progress%)', progress, filePath);
          }
        },
      );

      final Uint8List bytes = response.data;
      await file.writeAsBytes(bytes);

      // Show completion notification
      await _showDownloadCompleteNotification(
          notificationId, fileName, filePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Image downloaded successfully to Downloads/$fileName'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () async {
                await OpenFilex.open(filePath);
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  IconData _getFileIcon(String? extension) {
    switch (extension?.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'txt':
        return Icons.text_snippet;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
        return Icons.audio_file;
      case 'zip':
      case 'rar':
        return Icons.archive;
      default:
        return Icons.attach_file;
    }
  }

  void _downloadFile(String? filePath, String? fileName) async {
    if (filePath == null) return;
    final String downloadUrl = EndPoint.fileBaseUrl + filePath;
    final String finalFileName = (fileName ?? 'document').endsWith('.pdf')
        ? (fileName ?? 'document')
        : '${fileName ?? 'document'}.pdf';
    final int notificationId = _notificationIdCounter++;

    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Storage permission required to download files'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      await _showDownloadProgressNotification(notificationId, 'Downloading...',
          'Starting download of $finalFileName', 0, '');

      final directory = await getApplicationDocumentsDirectory();
      final String fullFilePath = '${directory.path}/$finalFileName';
      final File file = File(fullFilePath);

      final Response response = await Dio().get(
        downloadUrl,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) {
            return status != null && status < 500;
          },
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final progress = (received / total * 100).round();
            _showDownloadProgressNotification(
                notificationId,
                'Downloading...',
                'Downloading $finalFileName ($progress%)',
                progress,
                fullFilePath);
          }
        },
      );

      final Uint8List bytes = response.data;
      await file.writeAsBytes(bytes);

      await _showDownloadCompleteNotification(
          notificationId, finalFileName, fullFilePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'File downloaded successfully to Documents/$finalFileName'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Open',
              onPressed: () async {
                final result = await OpenFilex.open(fullFilePath);
                if (result.type != ResultType.done) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text('Could not open file:  [${result.message}')),
                  );
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error downloading file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildActionButtons(EditMarkerState state) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        final isDeleting = homeState is DeleteMarkerLoading;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AuthButton(
                onPressed: () => _handleEdit(state),
                text: 'Edit',
                buttonWidth: double.infinity,
                buttonHeight: 50.h,
                backGroundColor: Color(0xff6ab3d9),
                textColor: Colors.white,
                clickable: !isDeleting,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: AuthButton(
                onPressed: () => _handleDelete(state),
                text: isDeleting ? 'Deleting...' : 'Delete',
                buttonWidth: double.infinity,
                buttonHeight: 50.h,
                sideBar: true,
                clickable: !isDeleting,
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleEdit(EditMarkerState state) {
    HapticFeedback.selectionClick();
    context.read<HomeBloc>().add(FetchLocationDetailsEvent(state.location!.id));

    context.push(Routes.editMarker, extra: state.location);
    // context.read<HomeBloc>().add(FetchAspectsEvent());
    // context
    //     .read<HomeBloc>()
    //     .add(FetchSubAspectsEvent(state.location!.aspectId!));
    // context
    //     .read<HomeBloc>()
    //     .add(FetchCategoriesEvent(state.location!.subAspectId!));
  }

  void _handleDelete(EditMarkerState state) {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => Dialog(
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
                  'Delete Marker',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Are you sure you want to delete this marker?',
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
                              color: Colors.grey.shade400, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
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
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          // Trigger the delete action
                          context
                              .read<HomeBloc>()
                              .add(DeleteMarkerEvent(state.location!.id));
                        },
                        child: const Text('Delete'),
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
  }
}
