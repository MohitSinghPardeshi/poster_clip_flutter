import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_clip_flutter/core/constants/constants.dart';
import 'package:poster_clip_flutter/model/image_model.dart';

// StateNotifier to manage the main list of ImageModel
class ImageListNotifier extends StateNotifier<List<ImageModel>> {
  ImageListNotifier()
      : super([
          ImageModel(imageUrl: Constants.personOnePath),
          ImageModel(imageUrl: Constants.personTwoPath),
          ImageModel(imageUrl: Constants.personThreePath),
          ImageModel(imageUrl: Constants.personFourPath),
          ImageModel(imageUrl: Constants.personFivePath),
        ]);

  // Method to update the image list after applying changes
  void applyChanges(List<ImageModel> updatedImages) {
    state = updatedImages;
  }
}

// Expose the ImageListNotifier as a provider
final imageListProvider =
    StateNotifierProvider<ImageListNotifier, List<ImageModel>>((ref) {
  return ImageListNotifier();
});
