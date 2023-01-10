import 'package:flutter/material.dart';
import 'package:view_model_x/view_model_x.dart';

import 'view_model/first_view_model.dart';
import 'view_model/second_view_model.dart';

class MultipleViewModelsExample extends StatelessWidget {
  const MultipleViewModelsExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiViewModelProvider(
      providers: [
        ViewModelProvider(create: (context) => FirstViewModel()),
        ViewModelProvider(create: (context) => SecondViewModel()),
      ],
      child: MaterialApp(
        title: 'Multiple ViewModels Example',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            color: Colors.green.shade100,
          ),
          primarySwatch: Colors.green,
        ),
        home: const ContentPage(),
      ),
    );
  }
}

class ContentPage extends StatelessWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multiple ViewModels Example')),
      body: SharedFlowListener(
        sharedFlow: context.vm<SecondViewModel>().messageSharedFlow,
        listener: (context, value) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value)));
        },
        child: Center(
          child: StateFlowBuilder(
              stateFlow: ViewModelProvider.of<FirstViewModel>(context)
                  .counterStateFlow,
              builder: (context, value) {
                return Text(
                  "$value",
                  style: const TextStyle(fontSize: 30),
                );
              }),
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
