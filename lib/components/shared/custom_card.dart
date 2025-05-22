import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomCard extends StatelessWidget {
  final String? imageUrl;
  final String title;
  final String? subtitle;
  final double? rating;
  final VoidCallback onTap;
  final List<Widget>? actions;

  const CustomCard({
    super.key,
    this.imageUrl,
    required this.title,
    this.subtitle,
    this.rating,
    required this.onTap,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (imageUrl != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 50,
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(subtitle!),
              ],
              if (rating != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(rating!.toStringAsFixed(1)),
                  ],
                ),
              ],
              if (actions != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
} 