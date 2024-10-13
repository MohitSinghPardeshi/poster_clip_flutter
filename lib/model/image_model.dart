class ImageModel {
  final String imageUrl;
  bool isSelected;

  ImageModel({
    required this.imageUrl,
    this.isSelected = true,
  });

  // A copyWith method to allow immutability for state management
  ImageModel copyWith({bool? isSelected}) {
    return ImageModel(
      imageUrl: imageUrl,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}
