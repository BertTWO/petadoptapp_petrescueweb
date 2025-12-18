import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage({
    required ImageSource source,
    double maxWidth = 1080,
    double maxHeight = 1080,
    int imageQuality = 80,
  }) async {
    try {
      // Check and request permissions
      if (source == ImageSource.camera) {
        final cameraStatus = await Permission.camera.status;
        if (!cameraStatus.isGranted) {
          final result = await Permission.camera.request();
          if (!result.isGranted) {
            if (await Permission.camera.isPermanentlyDenied) {
              _showPermissionDialog(
                'Camera permission is permanently denied. Please enable it in app settings.',
              );
            }
            return null;
          }
        }
      } else {
        final photosStatus = await Permission.photos.status;
        if (!photosStatus.isGranted) {
          final result = await Permission.photos.request();
          if (!result.isGranted) {
            if (await Permission.photos.isPermanentlyDenied) {
              _showPermissionDialog(
                'Photo library permission is permanently denied. Please enable it in app settings.',
              );
            }
            return null;
          }
        }
      }

      // Add a delay to ensure channel is ready
      await Future.delayed(const Duration(milliseconds: 100));

      final XFile? pickedFile = await _picker
          .pickImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
          )
          .onError((error, stackTrace) {
            if (kDebugMode) {
              print('Image picker error: $error');
            }
            return null;
          });

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Image picker exception: $e');
      }

      // Fallback: Try alternative method
      if (e.toString().contains('channel-error')) {
        return await _pickImageFallback(source);
      }

      return null;
    }
  }

  // Alternative fallback method
  Future<File?> _pickImageFallback(ImageSource source) async {
    try {
      // Using a different approach with Future.delayed
      await Future.delayed(const Duration(milliseconds: 500));

      final XFile? pickedFile = await _picker
          .pickImage(source: source)
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              return null;
            },
          );

      return pickedFile != null ? File(pickedFile.path) : null;
    } catch (e) {
      if (kDebugMode) {
        print('Fallback image picker error: $e');
      }
      return null;
    }
  }

  void _showPermissionDialog(String message) {
    // This should be called in a context with ScaffoldMessenger
    // We'll handle this in the UI layer
    throw Exception(message);
  }

  Future<List<File>> pickMultipleImages({
    double maxWidth = 1080,
    double maxHeight = 1080,
    int imageQuality = 80,
  }) async {
    try {
      final photosStatus = await Permission.photos.status;
      if (!photosStatus.isGranted) {
        final result = await Permission.photos.request();
        if (!result.isGranted) {
          return [];
        }
      }

      await Future.delayed(const Duration(milliseconds: 100));

      final List<XFile>? pickedFiles = await _picker
          .pickMultiImage(
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: imageQuality,
          )
          .onError((error, stackTrace) {
            if (kDebugMode) print('Multi image picker error: $error');
            return <XFile>[]; // return empty list instead of null
          });

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        return pickedFiles.map((xfile) => File(xfile.path)).toList();
      }
      return [];
    } catch (e) {
      if (kDebugMode) {
        print('Multi image picker exception: $e');
      }
      return [];
    }
  }
}
