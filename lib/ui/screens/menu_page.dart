import 'package:flutter/material.dart';
import 'package:basa_proj_app/ui/widgets/custom_buttons_widget.dart';
import 'package:basa_proj_app/shared/constant_ui.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ConstantUI.customYellow,
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Image(
                image: LOGO,
                width: 100,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 30),
                child: const Image(
                  image: LOGO_TXT,
                  width: 100,
                ),
              ),
              Container(
                height: 20,
              ),
              CustomButton(
                  text: 'ibàsa',
                  onPressed: () {
                    Navigator.pushNamed(context, '/ibasa');
                  }),
              Container(
                height: 20,
              ),
              CustomButton(
                  text: 'mga kwento',
                  onPressed: () {
                    Navigator.pushNamed(context, '/library');
                  }),
              const Spacer(),

              // Row(
              //   children: [
              //     CustomButton(
              //         text: 'settings',
              //         onPressed: () {
              //           Navigator.pushNamed(context, '/setting');
              //         }),
              //     CustomButton(
              //         text: 'help',
              //         onPressed: () {
              //           Navigator.pushNamed(context, '/help');
              //         }),
              //   ],
              // )
            ],
          ),
        ),
      ),
    );
  }
}
