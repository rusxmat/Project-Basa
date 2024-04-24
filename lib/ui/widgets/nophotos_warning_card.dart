import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/screens/ibasa_screen.dart';
import 'package:basa_proj_app/ui/widgets/custom_buttons_widget.dart';
import 'package:flutter/material.dart';

class NoPhotosWarningCard extends StatelessWidget {
  final VoidCallback? onPressed;

  const NoPhotosWarningCard({Key? key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Card(
          child: ListTile(
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
              child: RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Walang mga larawan\n',
                      style: TextStyle(
                        color: ConstantUI.customPink,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: ITIM_FONTNAME,
                      ),
                    ),
                    TextSpan(
                      text: 'Magdagdag ng mga larawan mula sa Camera Screen',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontFamily: ITIM_FONTNAME,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: CustomButton(
                text: 'Bumalik sa Ibasa',
                onPressed: (onPressed == null)
                    ? () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => IbasaScreen()),
                            ModalRoute.withName("/"));
                      }
                    : onPressed!,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
