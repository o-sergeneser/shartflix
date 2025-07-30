import 'dart:ui';
import 'package:flutter/material.dart';

class LimitedOfferBottomSheet extends StatelessWidget {
  final VoidCallback onClose;

  const LimitedOfferBottomSheet({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blur Katmanı
        GestureDetector(
          onTap: onClose,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Container(
              color: Colors
                  .transparent,
            ),
          ),
        ),

        // Bottom Sheet içeriği
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/limited-offer.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
