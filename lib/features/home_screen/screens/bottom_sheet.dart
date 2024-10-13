import 'package:flutter/material.dart';
import 'package:poster_clip_flutter/model/image_model.dart';

class BottomSheetContent extends StatefulWidget {
  final List<ImageModel> images;
  final Function(List<ImageModel>) onApply;

  BottomSheetContent({
    required this.images,
    required this.onApply,
  });

  @override
  _BottomSheetContentState createState() => _BottomSheetContentState();
}

class _BottomSheetContentState extends State<BottomSheetContent> {
  late List<ImageModel> tempImages; // Temporary image list for selection

  @override
  void initState() {
    super.initState();
    // Make a copy of the passed images for temporary selection
    tempImages = List.from(widget.images);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            // Top Bar with title and Done button
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Select Leader',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      widget.onApply(tempImages); // Apply changes
                      Navigator.pop(context); // Close the bottom sheet
                    },
                    child: Text('Done', style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
            ),
            // Grid layout for images
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: tempImages.length,
                itemBuilder: (context, index) {
                  final image = tempImages[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        tempImages[index] = tempImages[index].copyWith(
                            isSelected: !tempImages[index].isSelected);
                      });
                    },
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipOval(
                          child: SizedBox(
                            width: 50.0, // Adjust the size here
                            height: 50.0, // Adjust the size here
                            child: Image.asset(
                              image.imageUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        if (image.isSelected)
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              padding: const EdgeInsets.all(4.0),
                              decoration: const BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 18.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
