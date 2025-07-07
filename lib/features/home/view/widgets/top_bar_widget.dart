import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:maptiler_flutter/maptiler_flutter.dart';
import 'package:recoding_platform_project/features/profile/bloc/profile_bloc.dart';
import 'package:recoding_platform_project/features/profile/view/profile_view.dart';
import 'package:recoding_platform_project/src/components/login_footer.dart';
import 'package:recoding_platform_project/src/routing/routes.dart';

import '../../../../src/themes/app_colors.dart';

class TopBarWidget extends StatelessWidget {
  final VoidCallback? onSettingsPressed;
  const TopBarWidget({super.key, this.onSettingsPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 55.h,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      color: AppColors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 40.r,
            height: 40.r,
            child: InkWell(
              onTap: () {
                context.read<ProfileBloc>().add(LoadProfile());
                context.push(Routes.profile);
              },
              child: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  String? imageUrl;
                  if (state is ProfileLoadSuccessState) {
                    imageUrl = state.profileResponse.user.profile_image;
                  }

                  return ClipOval(
                    child: imageUrl != null
                        ? CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.fill,
                            width: 40.r,
                            height: 40.r,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/images/prof.png'),
                          )
                        : Image.asset(
                            'assets/images/prof.png',
                            fit: BoxFit.cover,
                            width: 40.r,
                            height: 40.r,
                          ),
                  );
                },
              ),
            ),
          ),
          Row(
            children: [
              LoginFooter(
                width: 200.w,
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_none,
                  size: 30.r,
                  color: Color(0xff5e5e5e),
                ),
                onPressed: () async {
                  MapTiler.geolocationAPI.getIPGeolocation().then((result) {
                    print(result.city);
                  });
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  size: 30.r,
                  color: Color(0xff5e5e5e),
                ),
                onPressed: onSettingsPressed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
