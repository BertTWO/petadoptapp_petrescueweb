// lib/core/utils/image_utils.dart
import 'package:flutter/material.dart';

class ImageUtils {
  static Widget buildPetImage(
    String imageUrl, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    // Clean the URL (remove escaped slashes from JSON)
    final cleanedUrl = imageUrl.replaceAll('\\/', '/');

    print('🖼️ Loading image: $cleanedUrl');

    if (cleanedUrl.isEmpty) {
      return _buildPlaceholder(width: width, height: height);
    }

    return Image.network(
      cleanedUrl,
      width: width,
      height: height,
      fit: fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        print('❌ Image error: $error');
        return _buildPlaceholder(width: width, height: height);
      },
    );
  }

  static Widget _buildPlaceholder({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.pets, color: Colors.grey, size: 40),
      ),
    );
  }
}
