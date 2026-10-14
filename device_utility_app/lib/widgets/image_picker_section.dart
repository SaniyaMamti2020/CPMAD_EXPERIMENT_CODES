import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerSection extends StatefulWidget {
  const ImagePickerSection({super.key});

  @override
  State<ImagePickerSection> createState() =>
      _ImagePickerSectionState();
}

class _ImagePickerSectionState
    extends State<ImagePickerSection> {
  final ImagePicker picker = ImagePicker();

  File? selectedImage;
  String message = 'No image selected';

  Future<void> selectImage(ImageSource source) async {
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 80,
      );

      if (!mounted) return;

      if (image == null) {
        setState(() {
          message = 'Image selection cancelled';
        });
        return;
      }

      setState(() {
        selectedImage = File(image.path);
        message = source == ImageSource.camera
            ? 'Photo captured successfully'
            : 'Image selected successfully';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        message = 'Unable to select image. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Camera and Gallery',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            Center(
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                clipBehavior: Clip.antiAlias,
                child: selectedImage != null
                    ? Image.file(
                        selectedImage!,
                        fit: BoxFit.cover,
                      )
                    : const Icon(
                        Icons.add_a_photo,
                        size: 70,
                        color: Colors.grey,
                      ),
              ),
            ),

            const SizedBox(height: 10),

            Text(message),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        selectImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Camera'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        selectImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Gallery'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}