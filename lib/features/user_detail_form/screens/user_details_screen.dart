import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_clip_flutter/core/common/ImagePicker.dart';
import 'package:poster_clip_flutter/core/providers/providers.dart';
import 'package:poster_clip_flutter/core/providers/user_detail_provider.dart';
import 'package:poster_clip_flutter/features/user_detail_form/controller/user_details_controller.dart';

class UserDetailsScreen extends ConsumerStatefulWidget {
  final String? mobile;
  final bool isUpdate;
  const UserDetailsScreen(
      {required this.mobile, this.isUpdate = false, super.key});

  @override
  ConsumerState<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {
  File? userProfile;
  final nameController = TextEditingController();
  final designationController = TextEditingController();

  void onSubmit() {
    final userDetailsNotifier = ref.read(userDetailsProvider.notifier);
    userDetailsNotifier.updateUser(
      nameController.text,
      designationController.text,
      userProfile?.path ?? '',
    );
    ref.read(userDetailsControllerProvider.notifier).validateAndSubmit(
          userProfile,
          nameController.text,
          designationController.text,
          context,
          widget.isUpdate,
        );
  }

  @override
  void initState() {
    super.initState();
    if (widget.isUpdate) {
      final pref = ref.read(sharedPrefsProvider);
      nameController.text = pref.getString('name') ?? '';
      designationController.text = pref.getString('designation') ?? '';

      final profileImagePath = pref.getString('profileImagePath');
      if (profileImagePath != null) {
        setState(() {
          userProfile = File(profileImagePath);
        });
      }
    }
  }

  Future<void> pickImage() async {
    var pickedImage =
        await ref.watch(imagePickerProvider).showImagePickerDialog(context);

    if (pickedImage != null) {
      setState(() {
        userProfile = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile picture upload
              GestureDetector(
                onTap: pickImage,
                child: Stack(
                  children: [
                    (userProfile == null)
                        ? CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            child: const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.black,
                            ),
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: FileImage(userProfile!),
                          ),
                    const Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 20,
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Upload your photo',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              // Name input field
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Ex. Mohit Pardeshi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Designation input field
              TextField(
                controller: designationController,
                decoration: InputDecoration(
                  labelText: 'Designation',
                  hintText: 'Ex. Android Developer',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Save & Next button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: onSubmit,
                child: Text(
                  (!widget.isUpdate) ? 'Save & Next' : 'Update',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
