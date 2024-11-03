import 'package:flutter/material.dart';
import 'package:view_model_x/view_model_x.dart';

import 'view_model/first_view_model.dart';
import 'view_model/second_view_model.dart';

class MultipleViewModelsExample extends StatelessWidget {
  const MultipleViewModelsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ViewModelProvider(create: (context) => FirstViewModel()),
        ViewModelProvider(create: (context) => SecondViewModel()),
      ],
      // child: MaterialApp(home: const ContentPage()),
      child: const ContentPage(),
    );
  }
}

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const CloseButton(),
          titleSpacing: 0,
          title: const Text('Multiple ViewModels Example')),
      body: MultiFlowListener(
        listeners: [
          SharedFlowListener(
              sharedFlow: context.vm<SecondViewModel>().messageSharedFlow,
              listener: (context, value) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(value)));
              }),
          StateFlowListener(
              stateFlow: context.vm<FirstViewModel>().counterStateFlow,
              listener: (context, value) {
                debugPrint(
                    "MultiFlowListener > StateFlowListener > counterStateFlow value: $value");
              })
        ],
        child: Center(
          child: StateFlowConsumer(
            stateFlow:
                ViewModelProvider.of<FirstViewModel>(context).counterStateFlow,
            builder: (context, value) {
              return Text(
                "$value",
                style: const TextStyle(fontSize: 30),
              );
            },
            listener: (BuildContext context, int value) {
              debugPrint("counterStateFlow value: $value");
            },
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              ViewModelProvider.of<SecondViewModel>(context).showPopupMessage();
            },
            icon: const Icon(Icons.mail_outline),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: "multi_view_models_example",
            onPressed: () {
              context.vm<FirstViewModel>().increment();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
