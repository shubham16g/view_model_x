import 'package:flutter/material.dart';
import 'package:viewmodel/viewmodel.dart';

void main() {
  runApp(const MyApp());
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
      home: const HomePage(),
    );
  }
}

class MyViewModel extends ViewModel {
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
    _messageSharedFlow.emit("Hello from MyViewModel!");
  }

  @override
  void dispose() {
    // must dispose all flows
    _counterStateFlow.dispose();
    _messageSharedFlow.dispose();
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // wrap the content with your custom ViewModel
    return ViewModelProvider(
      create: (context) => MyViewModel(),
      child: const HomePageContent(),
    );
  }
}

class HomePageContent extends StatelessWidget {
  const HomePageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ViewModel Example'),
        actions: [
          IconButton(
              onPressed: () {
                // call the showPopupMessage function which is inside of MyViewModel
                context.vm<MyViewModel>().showPopupMessage();
              },
              icon: const Icon(Icons.mail_outline))
        ],
      ),
      // implement ViewModelListener anywhere in code to listen any flow
      body: ViewModelListener(
        // pass your flow (StateFlow or SharedFlow)
        flow: context.vm<MyViewModel>()._messageSharedFlow,
        listener: (context, value) {
          // get the emitted value. in this case <String?>"Hello from ViewModel!"
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value ?? "null message")));
        },
        child: Center(
          // implement ViewModelBuilder to rebuild Text on StateFlow value changed/updated
          child: ViewModelBuilder(
              // pass your StateFlow
              stateFlow: context.vm<MyViewModel>().counterStateFlow,
              builder: (context, value) {
                return Text(
                  "$value",
                  style: const TextStyle(fontSize: 30),
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // call the increment function which is inside MyViewModel
          ViewModelProvider.of<MyViewModel>(context).increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
