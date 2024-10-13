import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:poster_clip_flutter/core/common/button/home_button.dart';
import 'package:poster_clip_flutter/core/common/ui_helpers.dart';
import 'package:poster_clip_flutter/core/constants/constants.dart';
import 'package:poster_clip_flutter/core/exper/draw_poster.dart';
import 'package:poster_clip_flutter/core/providers/image_list_notifier.dart';
import 'package:poster_clip_flutter/core/providers/providers.dart';
import 'package:poster_clip_flutter/core/providers/user_detail_provider.dart';
import 'package:poster_clip_flutter/features/home_screen/screens/bottom_sheet.dart';
import 'package:poster_clip_flutter/model/image_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:share_plus/share_plus.dart';

final List<Map<String, String>> dataList = [
  {"name": "User 1", "designation": "Developer"},
  {"name": "User 2", "designation": "Designer"},
  {"name": "User 3", "designation": "Manager"},
];

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> _captureAndSaveImage(GlobalKey repaintKey) async {
    try {
      RenderRepaintBoundary boundary = repaintKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData != null) {
        final result = byteData.buffer.asUint8List();
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/poster_image.png';
        File imgFile = File(filePath);
        await imgFile.writeAsBytes(result);
        print("Image saved to $filePath");
        await Share.shareXFiles([XFile(filePath)],
            text: "Check out this poster!");
      }
    } catch (e) {
      print("Error saving or sharing image: $e");
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(userDetailsProvider);
    final pageController = PageController();
    final imageList = ref.watch(imageListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("PosterClip"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => displayLogout(context, ref),
          ),
        ],
      ),
      body: PageView.builder(
        controller: pageController,
        scrollDirection: Axis.vertical,
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final repaintKey = GlobalKey();

          return SizedBox(
            height: screenHeight(context),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Center(
                    child: RepaintBoundary(
                      key: repaintKey,
                      child: CombinedImageWidget(
                        designation: userData.designation,
                        isLeft: index % 2 == 0,
                        name: userData.name,
                        posterPath: Constants.posterPath,
                        userImagePath: userData.profileImagePath,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: HomeButton(
                              backgroundColor: Colors.blue,
                              icon: Icons.download,
                              label: 'Download',
                              onPressed: () {
                                _captureAndSaveImage(repaintKey);
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: HomeButton(
                              backgroundColor: Colors.green,
                              icon: Icons.share,
                              label: 'Share',
                              onPressed: () {
                                _captureAndSaveImage(repaintKey);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      HomeButton(
                        backgroundColor: Colors.black,
                        icon: Icons.edit,
                        label: 'Edit Profile',
                        onPressed: () {
                          Routemaster.of(context).push('/user-details-update/');
                        },
                      ),
                      const SizedBox(height: 6),
                      HomeButton(
                        backgroundColor: Colors.orange,
                        icon: Icons.edit,
                        label: 'Change Leader Photo',
                        onPressed: () {
                          _showBottomSheet(context, imageList, ref);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void displayLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () async {
                Navigator.of(context).pop();
                await ref.read(logoutProvider)();
                Routemaster.of(context).replace('/');
              },
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(
      BuildContext context, List<ImageModel> images, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheetContent(
          images: List.from(images),
          onApply: (updatedImages) {
            ref.read(imageListProvider.notifier).applyChanges(updatedImages);
          },
        );
      },
    );
  }
}
