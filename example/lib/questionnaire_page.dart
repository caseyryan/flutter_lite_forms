import 'package:flutter/material.dart';
import 'package:lite_forms/lite_forms.dart';

class QuestionnairePage extends StatefulWidget {
  const QuestionnairePage({super.key});

  @override
  State<QuestionnairePage> createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  @override
  Widget build(BuildContext context) {
    return LiteForm(
      name: 'questionnaire',
      autoDispose: false,
      allowUnfocusOnTapOutside: true,
      builder: (context, scrollController) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Questionnaire'),
          ),
          body: Column(children: [
            Expanded(
                child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [],
                  ),
                ),
              ],
            ))
          ]),
        );
      },
    );
  }
}
