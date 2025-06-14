import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class OfflineAwareImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Widget? placeholder;

  const OfflineAwareImage({
    super.key,
    required this.imageUrl,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ConnectivityResult>>(
      future: Connectivity().checkConnectivity(),
      builder: (context, snapshot) {
        // Safe default while waiting or error
        final isOffline = snapshot.hasData
            ? snapshot.data!.contains(ConnectivityResult.none)
            : false;

        if (isOffline) {
          return _buildOfflinePlaceholder();
        }

        return Image.network(
          imageUrl,
          height: height,
          width: width,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorPlaceholder();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return placeholder ?? _buildLoadingPlaceholder();
          },
        );
      },
    );
  }

  Widget _buildOfflinePlaceholder() {
    return Container(
      color: Colors.grey[200],
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.signal_wifi_off, size: 40, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            'Image unavailable\n(offline)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[200],
      height: height,
      width: width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.broken_image, size: 40, color: Colors.grey),
          const SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.grey[200],
      height: height,
      width: width,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
