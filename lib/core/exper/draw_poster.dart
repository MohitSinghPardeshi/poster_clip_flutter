import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_clip_flutter/core/common/ui_helpers.dart';
import 'package:poster_clip_flutter/core/constants/constants.dart';
import 'package:poster_clip_flutter/core/providers/image_list_notifier.dart';

class CombinedImagePainter extends CustomPainter {
  final ui.Image posterImage;
  final ui.Image userImage;
  final String name;
  final String designation;
  bool isLeft;
  final List<ui.Image> imageListImg;

  CombinedImagePainter({
    required this.posterImage,
    required this.userImage,
    required this.name,
    required this.designation,
    required this.isLeft,
    required this.imageListImg,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double height = size.height;
    final double width = size.width;
    final double posterHeight =
        height * 0.85; // Poster takes 85% of total height

    // 1. Draw the Poster Image
    canvas.drawImageRect(
      posterImage,
      Rect.fromLTWH(
          0, 0, posterImage.width.toDouble(), posterImage.height.toDouble()),
      Rect.fromLTWH(0, 0, width, posterHeight),
      Paint(),
    );

    // 2. Dynamic avatar placement
    final int avatarCount = imageListImg.length;
    final double paddingHorizontal = width * 0.03;
    final double availableWidth = width - 2 * paddingHorizontal;
    final double maxRadius = 50;
    final double totalSpacing = availableWidth * 0.1;

    final double dynamicRadius = (availableWidth - totalSpacing) / (5 * 2);
    final double effectiveAvatarRadius = dynamicRadius.clamp(0, maxRadius);
    final double spacingBetweenAvatars =
        (availableWidth - (avatarCount * 2 * effectiveAvatarRadius)) /
            (avatarCount - 1);

    final double avatarY = 15;
    double startX = paddingHorizontal;

    for (int i = 0; i < avatarCount; i++) {
      canvas.drawCircle(
        Offset(startX + effectiveAvatarRadius, avatarY + effectiveAvatarRadius),
        effectiveAvatarRadius,
        Paint()..color = Colors.white,
      );

      canvas.save();
      Path circlePath = Path()
        ..addOval(Rect.fromCircle(
            center: Offset(startX + effectiveAvatarRadius,
                avatarY + effectiveAvatarRadius),
            radius: effectiveAvatarRadius));
      canvas.clipPath(circlePath);

      final image = imageListImg[i];
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromCircle(
            center: Offset(startX + effectiveAvatarRadius,
                avatarY + effectiveAvatarRadius),
            radius: effectiveAvatarRadius),
        Paint(),
      );

      canvas.restore();

      startX += 2 * effectiveAvatarRadius + spacingBetweenAvatars;
    }

    // 3. Draw Orange Area at the Bottom
    final double orangeHeight = height * 0.15; // 15% of height for orange area
    final Paint orangePaint = Paint()..color = Colors.orange;
    canvas.drawRect(
      Rect.fromLTWH(0, posterHeight, width, orangeHeight),
      orangePaint,
    );

    // 4. Draw User Image with Rounded Rectangle in the Orange Area
    final double userImageWidth = width / 3.5;
    final double userImageHeight = userImageWidth * 1;

    final double calculatedHeight = height * 0.4;
    final double finalUserImageHeight =
        userImageHeight > calculatedHeight ? calculatedHeight : userImageHeight;

    final double userImageX =
        isLeft ? width * 0.03 : ((width - userImageWidth) - (width * 0.03));
    final double userImageY =
        posterHeight + orangeHeight - finalUserImageHeight;

    final RRect userImageRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(
          userImageX, userImageY, userImageWidth, finalUserImageHeight),
      topLeft: const Radius.circular(10),
      topRight: const Radius.circular(10),
      bottomLeft: const Radius.circular(0),
      bottomRight: const Radius.circular(0),
    );

    canvas.drawRRect(userImageRect, Paint()..color = Colors.white);

    canvas.save();
    canvas.clipRRect(userImageRect);

    canvas.drawImageRect(
      userImage,
      Rect.fromLTWH(
          0, 0, userImage.width.toDouble(), userImage.height.toDouble()),
      Rect.fromLTWH(
          userImageX, userImageY, userImageWidth, finalUserImageHeight),
      Paint(),
    );

    canvas.restore();

    // 5. Draw Text for Name and Designation
    final TextSpan nameSpan = TextSpan(
      text: name,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );

    final TextSpan designationSpan = TextSpan(
      text: designation,
      style: const TextStyle(
        color: Colors.yellow,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    final TextPainter namePainter = TextPainter(
      text: nameSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final TextPainter designationPainter = TextPainter(
      text: designationSpan,
      textDirection: TextDirection.ltr,
    )..layout();

    final double textX = isLeft
        ? userImageX + userImageWidth + 12
        : userImageX - namePainter.width - 12;
    final double textY =
        userImageY + (finalUserImageHeight / 2 - namePainter.height) + 21;

    namePainter.paint(canvas, Offset(textX, textY));
    designationPainter.paint(
        canvas,
        Offset(isLeft ? textX : userImageX - designationPainter.width - 12,
            textY + namePainter.height));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class CombinedImageWidget extends ConsumerWidget {
  final String posterPath; // Path to the poster image
  final String userImagePath; // Path to the user image
  final String name;
  final String designation;
  final bool isLeft;

  CombinedImageWidget({
    required this.posterPath,
    required this.userImagePath,
    required this.name,
    required this.designation,
    required this.isLeft,
  });

  Future<ui.Image> loadImage(String path) async {
    try {
      // Check if the path is an asset or a local file path
      if (path.startsWith('/')) {
        // Load from local file
        final Completer<ui.Image> completer = Completer();
        final file = File(path);
        final bytes = await file.readAsBytes();
        ui.decodeImageFromList(Uint8List.fromList(bytes), (ui.Image img) {
          completer.complete(img);
        });
        return completer.future;
      } else {
        // Load from assets
        final ByteData data = await rootBundle.load(path);
        final List<int> bytes = data.buffer.asUint8List();
        final Completer<ui.Image> completer = Completer();
        ui.decodeImageFromList(Uint8List.fromList(bytes), (ui.Image img) {
          completer.complete(img);
        });
        return completer.future;
      }
    } catch (e) {
      print('Error loading image at $path: $e');
      throw Exception('Failed to load image');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageList = ref.watch(imageListProvider);

    return FutureBuilder<List<ui.Image>>(
      future: Future.wait([
        loadImage(posterPath),
        loadImage(userImagePath),
        loadImage(Constants.personOnePath),
        loadImage(Constants.personTwoPath),
        loadImage(Constants.personThreePath),
        loadImage(Constants.personFourPath),
        loadImage(Constants.personFivePath),
      ]),
      builder: (context, snapshot) {
        List<ui.Image> list = [];
        if (snapshot.data != null) {
          for (int i = 0; i < imageList.length; i++) {
            if (imageList[i].isSelected) {
              list.add(snapshot.data![i + 2]);
            }
          }
        }

        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData && snapshot.data!.length == 7) {
            double height = 400;
            return CustomPaint(
                size: Size(screenWidth(context), 400), // Adjust size
                painter: CombinedImagePainter(
                  posterImage: snapshot.data![0],
                  userImage: snapshot.data![1],
                  name: name,
                  designation: designation,
                  isLeft: isLeft,
                  imageListImg: list,
                ));
          } else {
            return const Center(child: Text('Error loading images'));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
