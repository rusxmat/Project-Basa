import 'package:flutter/material.dart';
import 'package:basa_proj_app/ui/widgets/custom_buttons_widget.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('BÀSA', style: TextStyle(fontSize: 48)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                    text: 'ibàsa',
                    onPressed: () {
                      Navigator.pushNamed(context, '/ibasa');
                    }),
                CustomButton(
                    text: 'mga kwento',
                    onPressed: () {
                      Navigator.pushNamed(context, '/library');
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomButton(
                    text: 'aBaKaDa',
                    onPressed: () {
                      Navigator.pushNamed(context, '/dict');
                    }),
                Row(
                  children: [
                    CustomButton(
                        text: 'settings',
                        onPressed: () {
                          Navigator.pushNamed(context, '/setting');
                        }),
                    CustomButton(
                        text: 'help',
                        onPressed: () {
                          Navigator.pushNamed(context, '/help');
                        }),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
