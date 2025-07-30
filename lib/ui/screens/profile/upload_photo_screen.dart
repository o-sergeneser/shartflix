import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shartflix/core/theme/colors.dart';
import 'package:shartflix/ui/bloc/auth/auth_bloc.dart';
import 'package:shartflix/ui/bloc/auth/auth_event.dart';
import 'package:shartflix/ui/bloc/auth/auth_state.dart';

class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _onUpload() {
    if (_selectedImage != null) {
      context.read<AuthBloc>().add(UploadPhotoRequested(_selectedImage!.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            width: 47,
                            height: 47,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF2A2A2A),
                              border: Border.all(
                                color: const Color.fromARGB(255, 77, 77, 77),
                                width: 1,
                              ), 
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Profil Detayı",
                      style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(child: const SizedBox()), 
                ],
              ),
            ),

            const SizedBox(height: 30),
            Text(
              'Fotoğrafınızı yükleyin',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Text(
                'Resources out incentivize\nrelaxation floor loss cc.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            // Başlık
            const SizedBox(height: 45),

            // Fotoğraf seçme alanı
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  color: const Color(0xFF1C1C1C),
                  borderRadius: BorderRadius.circular(27),
                  border: Border.all(
                    color: const Color.fromARGB(255, 77, 77, 77),
                    width: 1,
                  ),
                  image: _selectedImage != null
                      ? DecorationImage(
                          image: FileImage(_selectedImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _selectedImage == null
                    ? const Center(
                        child: Icon(Icons.add, size: 36, color: Colors.white70),
                      )
                    : null,
              ),
            ),

            const Spacer(),

            BlocConsumer<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
                  current is PhotoUploadSuccess ||
                  current is PhotoUploadFailure,
              listener: (context, state) {
                if (state is PhotoUploadSuccess) {
                  Navigator.pop(context, state.photoUrl);
                } else if (state is PhotoUploadFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                if (state is AuthLoading) {
                  return const Padding(
                    padding: EdgeInsets.only(bottom: 30),
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                    onPressed: _selectedImage == null ? null : _onUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryRed,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Devam Et",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
