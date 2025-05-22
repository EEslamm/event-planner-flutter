import 'package:flutter/material.dart';

class MainItems extends StatelessWidget {
  final String title;
  final String imageName;
  final Function onTap;

  const MainItems({
    super.key,
    required this.title,
    required this.imageName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => onTap(),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(imageName),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
