import 'package:flutter/material.dart';

class SkeletonScreen extends StatelessWidget {
  const SkeletonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: 4, // Jumlah skeleton item
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[800],
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8),
                  child: SkeletonAnimation(width: double.infinity, height: double.infinity),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// Animasi Skeleton
class SkeletonAnimation extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonAnimation({Key? key, required this.width, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[700],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}