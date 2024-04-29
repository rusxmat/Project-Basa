import 'package:basa_proj_app/shared/connectivity_util.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/modals/message_modal.dart';
import 'package:basa_proj_app/ui/widgets/custom_buttons_widget.dart';
import 'package:flutter/material.dart';

class NoBooksWarningCard extends StatelessWidget {
  const NoBooksWarningCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                height: 20,
              ),
              const Text(
                'Walang mga libro\n',
                style: TextStyle(
                  color: ConstantUI.customPink,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: ITIM_FONTNAME,
                ),
              ),
              const Text(
                'Magdagdag ng libro mula sa Ibasa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ConstantUI.customGrey,
                  fontSize: 16,
                  fontFamily: ITIM_FONTNAME,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: CustomButton(
                    textSize: 16,
                    text: 'Pumunta sa Ibasa',
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/ibasa')),
              ),
              const Text(
                'Magdagdag o Magbasa ng libro mula sa Online Library',
                style: TextStyle(
                  color: ConstantUI.customGrey,
                  fontSize: 16,
                  fontFamily: ITIM_FONTNAME,
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: CustomButton(
                  text: 'Pumunta sa Online Lib',
                  textSize: 16,
                  onPressed: () async {
                    if (await isConnectedToInternet()) {
                      Navigator.pushNamed(context, '/onlinelib');
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => const MessageModal(
                            title: "No Internet Connection",
                            message:
                                'Please connect to the internet to access the online library. \n\nThank you!'),
                      );
                    }
                  },
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
