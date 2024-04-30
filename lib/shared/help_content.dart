class Step {
  final String title;
  final String content;

  Step({
    required this.title,
    required this.content,
  });
}

class HelpContent {
  final String sectionTitle;
  final String? title;
  final List<Step>? body;
  final String? subtitle;
  final String? notes;
  final String? warning;

  HelpContent({
    required this.sectionTitle,
    this.title,
    this.body,
    this.subtitle,
    this.notes,
    this.warning,
  });
}

final List<HelpContent> HELP_CONTENT = [
  HelpContent(
    sectionTitle: 'What is Basa?',
    subtitle:
        'BASA is a mobile application that allows children to learn how to read and speak Filipino through the use of Text-to-Speech and Speech-to-Text features. It also provides a platform for users to create and share learning materials for their students. Using the application requires a mobile device with a camera and internet for STT and online library features.',
    warning:
        'WARNING: This application requires adult supervision for children using the application.',
  ),
  HelpContent(
    sectionTitle: 'How to add Books using Ibasa?',
    title: 'Using Ibasa you can add books.',
    subtitle: 'Translating physical books to digital.',
    body: [
      Step(
        title:
            '1. Go to the Ibasa Screen by pressing the \'Ibasa\' button in the menu.',
        content: 'This will navigate you to the Camera Screen.',
      ),
      Step(
        title: '2. Take photos by using your camera.',
        content:
            'The application will provide an audio cue, and visual cue when your photo is taken. \n(press the arrow button when you\'re done taking photos)',
      ),
      Step(
        title: '3. Review the photos you have taken.',
        content:
            'Rearrange the photos by order by dragging the photo to be rearranged of reading or delete photos by pressing the upper right icon to select and delete selected photos. Proceed by pressing the arrow button.',
      ),
      Step(
        title:
            '4. Review result of Ibasa and fill-out other necessary details.',
        content:
            'Fill out the necessary details such as the title, and author of the book. Adjust the result of the Ibasa by deleting or editing the resulting text. If you want to add a page, navigate back to the camera screen. \nPress the arrow button to proceed.',
      ),
    ],
  ),
  HelpContent(
    sectionTitle: 'How to add Books from Online Library?',
    title: 'Download books from Online Library.',
    subtitle: 'Retrieve books from Book Database.',
    body: [
      Step(
        title:
            '1. Go to the Online Library by pressing the \'Mga Kwento\' button in the menu, then pressing the \'Online Library\' button in the bottom right.',
        content: 'This will navigate you to the Online Library.',
      ),
      Step(
        title:
            '2. You may view a book in the library by pressing its corresponding card.',
        content:
            'This will prompt you to select either \'Makinig\' or \'Magsalita\' to test the book.',
      ),
      Step(
        title:
            '3. Download the book by pressing the corresponding download button in the Online Library.',
        content:
            'Wait for the download to finish indicated Circular Progress Indicator. The book will be added to your library.',
      ),
    ],
  ),
  HelpContent(
    sectionTitle: 'How to use the Makinig Feature?',
    title: 'Guide on using the Makinig feature.',
    subtitle:
        'Makinig features is the Text-to-Speech (TTS) Feature, which utilizes the built-in TTS of your mobile phone.',
    notes:
        'This feature requires built-in language support for Filipino and English from your mobile phone.',
    body: [
      Step(
        title: 'Guide on using the Makinig feature.',
        content:
            'Makinig features is the Text-to-Speech (TTS) Feature, which utilizes the built-in TTS of your mobile phone. This feature requires built-in language support for Filipino and English from your mobile phone.',
      ),
      Step(
        title: '1. Go to the Mga Kwento Page or to the Online Library Screen.',
        content:
            'Press the \'Mga Kwento\' button in the Menu Page or move to the Online Library by pressing the \'Online Library Button\' in the Mga Kwento Page.',
      ),
      Step(
        title:
            '2. Select the book you want to read then select \'Makinig\' in the Pop-up.',
        content:
            'Press the corresponding book you wish to \'Makinig\' then press the \'Makinig\' button in the pop-up.',
      ),
      Step(
        title: '3. Start and Initialize the Makinig Feature.',
        content:
            'Press the Speaker Icon to start the TTS feature. Once initialized, replay the TTS by pressing the \'Repeat\' Icon or stop the TTS by pressing the \'Stop\' icon (Box)',
      ),
      Step(
        title: '4. Move to the next page by swiping the screen.',
        content:
            'To enable moving to the next page you have to wait for the TTS to finish or Stop the TTS. Swipe the screen to move to the next or previous page of the book. The TTS will automatically refresh to the next page.',
      ),
      Step(
        title: '5. Exit the Makinig Feature.',
        content: 'Press the \'Back\' button to exit the Makinig Feature',
      ),
    ],
  ),
  HelpContent(
    sectionTitle: 'How to use the Magsalita Feature?',
    title: 'Guide on using the Magsalita feature.',
    subtitle:
        'Magsalita features is the Speech Recognition Feature, which utilizes the built-in Speech Recognition of your mobile phone.',
    notes:
        'This feature requires built-in language support for Filipino and English from your mobile phone. ',
    warning:
        'WARNING: This feature may not work as intended as it utilizes the limited capability of the built-in STT of the device.',
    body: [
      Step(
        title: 'Guide on using the Makinig feature.',
        content:
            'Makinig features is the Text-to-Speech (TTS) Feature, which utilizes the built-in TTS of your mobile phone. This feature requires built-in language support for Filipino and English from your mobile phone.',
      ),
      Step(
        title: '1. Go to the Mga Kwento Page or to the Online Library Screen.',
        content:
            'Press the \'Mga Kwento\' button in the Menu Page or move to the Online Library by pressing the \'Online Library Button\' in the Mga Kwento Page.',
      ),
      Step(
        title:
            '2. Select the book you want to read then select \'Magsalita\' in the Pop-up.',
        content:
            'Press the corresponding book you wish to \'Magsalita\' then press the \'Magsalita\' button in the pop-up.',
      ),
      Step(
        title: '3. Start and Initialize the Magsalita Feature.',
        content:
            'Press the Mic Icon to start the Speech Recognition feature. Once initialized, refresh the speech recognition by pressing the \'Repeat\' Icon or stop the TTS by pressing the \'Exit\' icon',
      ),
      Step(
        title: '4. Move to the next page by swiping the screen.',
        content:
            'To enable moving to the next page you have to Exit the STT. Swipe the screen to move to the next or previous page of the book. The Speech Recognition will automatically refresh to the next page.',
      ),
      Step(
        title: '5. Exit the Magsalita Feature.',
        content: 'Press the \'Back\' button to exit the Magsalita Feature',
      ),
    ],
  ),
  HelpContent(
    sectionTitle: 'About',
    subtitle:
        'This application was built as fulfillment of the CMSC 190 SP requirement in the Institute of Computer Science, University of the Philippines Los Baños.',
    notes:
        '\n\nDeveloped by Zyrus Matthew B. Wallit\nFor inquiries contact zbwallit@up.edu.ph\n',
  ),
];
