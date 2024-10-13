import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poster_clip_flutter/core/common/loader.dart';
import 'package:poster_clip_flutter/features/login/controller/login_controller.dart';
import 'package:poster_clip_flutter/gen/assets.gen.dart';

late TextEditingController _mobileController;

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  onSubmit(WidgetRef ref, BuildContext context) async {
    String mobileNumber = _mobileController.text;
    ref
        .read(loginControllerProvider.notifier)
        .validateAndSubmit(mobileNumber, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loginControllerProvider);

    return Scaffold(
      body: isLoading
          ? const Loader()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 32.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // Logo at the top
                    Container(
                      height: 160,
                      width: 160,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(Assets.images.posterClipImg.path),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Align(
                      alignment:
                          Alignment.centerLeft, // Aligns the text to the left
                      child: Text(
                        "Enter Mobile Number",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const MobileNumberInput(),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => onSubmit(ref, context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 32.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class MobileNumberInput extends ConsumerStatefulWidget {
  const MobileNumberInput({super.key});

  @override
  ConsumerState<MobileNumberInput> createState() => _MobileNumberInputState();
}

class _MobileNumberInputState extends ConsumerState<MobileNumberInput> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _mobileController = TextEditingController(); // Initialize controller
  }

  @override
  void dispose() {
    _mobileController.dispose(); // Dispose controller when no longer needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: TextFormField(
        controller: _mobileController,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        decoration: InputDecoration(
          prefixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.asset(
                  'assets/images/indian_flag.png', // Replace with your flag image
                  width: 24,
                  height: 24,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8.0, right: 6.0),
                child: Text(
                  '+91',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          labelText: 'Mobile No',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: (value) {
          // Add any validation logic you want here
          if (value == null || value.isEmpty) {
            return 'Please enter a valid mobile number';
          }
          if (value.length != 10) {
            return 'Mobile number should be 10 digits';
          }
          return null;
        },
      ),
    );
  }
}
