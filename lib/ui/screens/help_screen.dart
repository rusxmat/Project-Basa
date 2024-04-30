import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/ui/widgets/custom_appbar_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Section {
  final String title;
  final Widget body;
  bool isExpanded;

  Section({
    required this.title,
    required this.body,
    this.isExpanded = false,
  });
}

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<Section> _sections = [
    Section(
      title: 'What is Basa?',
      body: ListTile(
        title: RichText(
            text: const TextSpan(
          children: [
            TextSpan(
              text:
                  'BASA is a mobile application that allows children to learn how to read and speak Filipino through the use of Text-to-Speech and Speech-to-Text features. It also provides a platform for users to create and share learning materials for their students. Using the application requires a mobile device with a camera and internet for STT and online library features.\n\n',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            TextSpan(
              text:
                  'WARNING: This application requires adult supervision for children using the application.\n',
              style: TextStyle(
                fontSize: 14,
                color: ConstantUI.customPink,
              ),
            ),
          ],
          style: TextStyle(
            height: 1.5,
            color: Colors.black,
            fontFamily: ITIM_FONTNAME,
          ),
        )),
      ),
    ),
    Section(
        title: 'How to add Books? ',
        body: Column(
          children: [
            ListTile(
              title: RichText(
                  text: const TextSpan(
                children: [
                  TextSpan(
                    text: 'Using Ibasa you can add books.\n',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: ConstantUI.customBlue,
                    ),
                  ),
                  TextSpan(
                    text: 'Translating physical books to digital.\n',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
                style: TextStyle(
                  height: 1.5,
                  color: Colors.black,
                  fontFamily: ITIM_FONTNAME,
                ),
              )),
              subtitle: const Column(
                children: [
                  ListTile(
                    title: Text(
                        '1. Go to the Ibasa Screen by pressing the \'Ibasa\' button in the menu.'),
                    subtitle:
                        Text('This will navigate you to the Camera Screen.'),
                  ),
                  ListTile(
                    title: Text('2. Take photos by using your camera.'),
                    subtitle: Text(
                        'The application will provide an audio cue, and visual cue when your photo is taken. \n(press the arrow button when you\'re done taking photos)'),
                  ),
                  ListTile(
                    title: Text('3. Review the photos you have taken.'),
                    subtitle: Text(
                        'Rearrange the photos by order by dragging the photo to be rearranged of reading or delete photos by pressing the upper right icon to select and delete selected photos. Proceed by pressing the arrow button.'),
                  ),
                  ListTile(
                    title: Text(
                        '4. Review result of Ibasa and fill-out other necessary details.'),
                    subtitle: Text(
                        'Fill out the necessary details such as the title, and author of the book. Adjust the result of the Ibasa by deleting or editing the resulting text. If you want to add a page, navigate back to the camera screen. \nPress the arrow button to proceed.'),
                  ),
                ],
              ),
            ),
            ListTile(
              title: RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Download books from Online Library.\n',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: ConstantUI.customBlue,
                      ),
                    ),
                    TextSpan(
                      text: 'Retrieve books from Book Database.\n',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                  style: TextStyle(
                    height: 1.5,
                    color: Colors.black,
                    fontFamily: ITIM_FONTNAME,
                  ),
                ),
              ),
              subtitle: const Column(
                children: [
                  ListTile(
                    title: Text(
                        '1. Go to the Online Library by pressing the \'Mga Kwento\' button in the menu, then pressing the \'Online Library\' button in the bottom right.'),
                    subtitle:
                        Text('This will navigate you to the Online Library.'),
                  ),
                  ListTile(
                    title: Text(
                        '2. You may view a book in the library by pressing its corresponding card.'),
                    subtitle: Text(
                        'This will prompt you to select either \'Makinig\' or \'Magsalita\' to test the book.'),
                  ),
                  ListTile(
                    title: Text(
                        '3. Download the book by pressing the corresponding download button in the Online Library.'),
                    subtitle: Text(
                        'Wait for the download to finish indicated Circular Progress Indicator. The book will be added to your library.'),
                  ),
                ],
              ),
            ),
          ],
        )),
    Section(
      title: 'How to use the Makinig Feature?',
      body: ListTile(
        title: RichText(
            text: const TextSpan(
          children: [
            TextSpan(
              text: 'Guide on using the Makinig feature.\n',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ConstantUI.customBlue,
              ),
            ),
            TextSpan(
              text:
                  'Makinig features is the Text-to-Speech Feature, which utilizes the built-in TTS of your mobile phone. \n',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ],
          style: TextStyle(
            height: 1.5,
            color: Colors.black,
            fontFamily: ITIM_FONTNAME,
          ),
        )),
        subtitle: const Column(
          children: [
            ListTile(
              title: Text(
                  '1. Go to the Mga Kwento Page or to the Online Library Screen.'),
              subtitle: Text(
                  'Press the \'Mga Kwento\' button in the Menu Page or move to the Online Library by pressing the \'Online Library Button\' in the Mga Kwento Page.'),
            ),
            ListTile(
              title: Text(
                  '2. Select the book you want to read then select \'Makinig\' in the Pop-up.'),
              subtitle: Text(
                  'Press the corresponding book you wish to \'Makinig\' then press the \'Makinig\' button in the pop-up.'),
            ),
            ListTile(
              title: Text('3. Start and Initialize the Makinig Feature.'),
              subtitle: Text(
                  'Press the Speaker Icon to start the TTS feature. Once initialized, replay the TTS by pressing the \'Repeat\' Icon or stop the TTS by pressing the \'Stop\' icon (Box)'),
            ),
            ListTile(
              title: Text('4. Move to the next page by swiping the screen.'),
              subtitle: Text(
                  'To enable moving to the next page you have to wait for the TTS to finish or Stop the TTS. Swipe the screen to move to the next or previous page of the book. The TTS will automatically refresh to the next page.'),
            ),
            ListTile(
              title: Text('5. Exit the Makinig Feature.'),
              subtitle:
                  Text('Press the \'Back\' button to exit the Makinig Feature'),
            ),
          ],
        ),
      ),
    ),
    Section(
      title: 'How to use the Magsalita Feature?',
      body: ListTile(
        title: RichText(
            text: const TextSpan(
          children: [
            TextSpan(
              text: 'Guide on using the Magsalita feature.\n',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: ConstantUI.customBlue,
              ),
            ),
            TextSpan(
              text:
                  'Magsalita features is the Speech Recognition Feature, which utilizes the built-in Speech Recognition of your mobile phone. \n\n',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            TextSpan(
              text:
                  'Filipino Speech Recognition requires internet connection to function as intended. \n\n',
              style: TextStyle(
                fontSize: 14,
                color: ConstantUI.customGrey,
              ),
            ),
            TextSpan(
              text:
                  'WARNING: This feature may not work as intended as it utilizes the limited capability of the built-in STT of the device.\n',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: ConstantUI.customPink,
              ),
            ),
          ],
          style: TextStyle(
            height: 1.5,
            color: Colors.black,
            fontFamily: ITIM_FONTNAME,
          ),
        )),
        subtitle: const Column(
          children: [
            ListTile(
              title: Text(
                  '1. Go to the Mga Kwento Page or to the Online Library Screen.'),
              subtitle: Text(
                  'Press the \'Mga Kwento\' button in the Menu Page or move to the Online Library by pressing the \'Online Library Button\' in the Mga Kwento Page.'),
            ),
            ListTile(
              title: Text(
                  '2. Select the book you want to read then select \'Magsalita\' in the Pop-up.'),
              subtitle: Text(
                  'Press the corresponding book you wish to \'Magsalita\' then press the \'Magsalita\' button in the pop-up.'),
            ),
            ListTile(
              title: Text('3. Start and Initialize the Magsalita Feature.'),
              subtitle: Text(
                  'Press the Mic Icon to start the Speech Recognition feature. Once initialized, refresh the speech recognition by pressing the \'Repeat\' Icon or stop the TTS by pressing the \'Exit\' icon'),
            ),
            ListTile(
              title: Text('4. Move to the next page by swiping the screen.'),
              subtitle: Text(
                  'To enable moving to the next page you have to Exit the STT. Swipe the screen to move to the next or previous page of the book. The Speech Recognition will automatically refresh to the next page.'),
            ),
            ListTile(
              title: Text('5. Exit the Magsalita Feature.'),
              subtitle: Text(
                  'Press the \'Back\' button to exit the Magsalita Feature'),
            ),
          ],
        ),
      ),
    ),
    Section(
      title: 'About',
      body: ListTile(
        title: RichText(
            text: const TextSpan(
          children: [
            TextSpan(
              text:
                  'This application was built as fulfillment of the CMSC 190 SP requirement in the Institute of Computer Science, University of the Philippines Los Baños.\n\n',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: 'Developed by Zyrus Matthew B. Wallit\n',
              style: TextStyle(
                fontSize: 16,
                color: ConstantUI.customBlue,
              ),
            ),
            TextSpan(
              text: 'For inquiries contact zbwallit@up.edu.ph\n',
              style: TextStyle(
                fontSize: 16,
                color: ConstantUI.customGrey,
              ),
            ),
          ],
          style: TextStyle(
            height: 1.5,
            color: Colors.black,
            fontFamily: ITIM_FONTNAME,
          ),
        )),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(title: 'Help'),
      body: SingleChildScrollView(
        child: ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              _sections[index].isExpanded = !_sections[index].isExpanded;
            });
          },
          children: _sections.map<ExpansionPanel>((Section section) {
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    section.title,
                    style: TextStyle(fontSize: 18),
                  ),
                );
              },
              body: section.body,
              isExpanded: section.isExpanded,
            );
          }).toList(),
        ),
      ),
    );
  }
}
