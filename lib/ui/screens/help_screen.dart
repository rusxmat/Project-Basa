import 'package:basa_proj_app/shared/constant_ui.dart';
import 'package:basa_proj_app/shared/help_content.dart';
import 'package:basa_proj_app/ui/widgets/custom_appbar_widget.dart';
import 'package:flutter/material.dart';

class Section {
  final HelpContent content;
  bool isExpanded;

  Section({
    required this.content,
    this.isExpanded = false,
  });
}

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  final List<Section> _sections = HELP_CONTENT
      .map((content) => Section(
            content: content,
          ))
      .toList();

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
            HelpContent content = section.content;

            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    content.sectionTitle,
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              },
              body: ListTile(
                title: RichText(
                    text: TextSpan(
                  children: [
                    (content.title == null)
                        ? TextSpan()
                        : TextSpan(
                            text: '${content.title!} \n',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: ConstantUI.customBlue,
                            ),
                          ),
                    (content.subtitle == null)
                        ? const TextSpan()
                        : TextSpan(
                            text: '${content.subtitle}',
                          ),
                    (content.notes == null)
                        ? const TextSpan()
                        : TextSpan(
                            text: '\n${content.notes}',
                            style: const TextStyle(
                              color: ConstantUI.customGrey,
                            ),
                          ),
                    (content.warning == null)
                        ? const TextSpan()
                        : TextSpan(
                            text: '\n\n${content.warning}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: ConstantUI.customPink,
                            ),
                          ),
                  ],
                  style: const TextStyle(
                    height: 1.5,
                    color: Colors.black,
                    fontFamily: ITIM_FONTNAME,
                    fontSize: 14,
                  ),
                )),
                subtitle: (content.body == null)
                    ? const Text('')
                    : Column(
                        children: content.body!
                            .map(
                              (step) => ListTile(
                                title: Text(step.title,
                                    style: const TextStyle(fontSize: 16)),
                                subtitle: Text(
                                  step.content,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                      ),
              ),
              isExpanded: section.isExpanded,
            );
          }).toList(),
        ),
      ),
    );
  }
}
