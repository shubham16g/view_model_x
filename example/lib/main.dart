import 'package:example/more_examples_section.dart';
import 'package:flutter/material.dart';
import 'package:view_model_x/view_model_x.dart';

void main() {
  runApp(const MyApp());
}

class CounterViewModel extends ViewModel {
  // initialize StateFlow
  final _counterStateFlow = MutableStateFlow<int>(1);

  StateFlow<int> get counterStateFlow => _counterStateFlow;

  // initialize SharedFlow
  final _messageSharedFlow = MutableSharedFlow<String>();

  SharedFlow<String> get messageSharedFlow => _messageSharedFlow;

  void increment() {
    // by changing the value, listeners were notified
    _counterStateFlow.value = _counterStateFlow.value + 1;
  }

  void showPopupMessage() {
    // by emitting the value, listeners were notified
    _messageSharedFlow.emit("Hello from CounterViewModel!");
  }

  @override
  void dispose() {
    // must dispose all flows
    _counterStateFlow.dispose();
    _messageSharedFlow.dispose();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViewModel Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.blue.shade100,
        ),
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: ViewModelProvider(
        create: (context) => CounterViewModel(),
          child: const HomePage()),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ViewModel Example')),
      // implement SharedFlowListener anywhere in code to listen for emits from sharedFlow
      body: SharedFlowListener(
        // pass your SharedFlow
        sharedFlow: context.vm<CounterViewModel>().messageSharedFlow,
        listener: (context, value) {
          // get the emitted value. in this case <String>"Hello from ViewModel!"
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MoreExamplesSection(),
            Expanded(
              child: Center(
                // implement ViewModelBuilder to rebuild Text on StateFlow value changed/updated
                child: StateFlowBuilder(
                    // pass your StateFlow
                    stateFlow: context.vm<CounterViewModel>().counterStateFlow,
                    builder: (context, value) {
                      return Text(
                        "$value",
                        style: const TextStyle(fontSize: 30),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {
              // call the showPopupMessage function which is inside CounterViewModel
              ViewModelProvider.of<CounterViewModel>(context).showPopupMessage();
            },
            icon: const Icon(Icons.mail_outline),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            onPressed: () {
              // call the increment function which is inside CounterViewModel
              ViewModelProvider.of<CounterViewModel>(context).increment();
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
