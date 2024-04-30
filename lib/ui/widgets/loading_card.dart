import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:flutter/material.dart';

class LoadingCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const LoadingCard({
    super.key,
    required this.title,
    this.subtitle = 'Mangyaring maghintay...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            const Spacer(),
            CIRCULAR_PROGRESS_INDICATOR,
            Container(
              height: 20,
            ),
            Text(
              title,
              style: const TextStyle(
                color: ConstantUI.customBlue,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: ITIM_FONTNAME,
              ),
            ),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: ConstantUI.customGrey,
                fontSize: 16,
                fontFamily: ITIM_FONTNAME,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
