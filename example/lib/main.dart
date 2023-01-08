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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class MyViewModel extends ViewModel {
  final _liveData = MutableStateFlow<int>(1);
  final _sharedFlow = MutableSharedFlow<int>();

  StateFlow<int> get liveData => _liveData;
  SharedFlow<int> get sharedFlow => _sharedFlow;

  void increment() {
    debugPrint("increment -> pressed");
    _liveData.value = _liveData.value + 1;
    if (_liveData.value % 2 == 0) {
      _sharedFlow.emit(_liveData.value);
    }
  }

  @override
  void dispose() {
    _liveData.dispose();
    _sharedFlow.dispose();
  }

}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      create: (context) => MyViewModel(),
      child: const _HomePageContent(),
    );
  }
}

class _HomePageContent extends StatefulWidget {
  const _HomePageContent({Key? key}) : super(key: key);

  @override
  State<_HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<_HomePageContent> {
  @override
  Widget build(BuildContext context) {
    debugPrint('build');
    return Scaffold(
      appBar: AppBar(title: const Text('ViewModel Example')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text('PressMe')),
            ViewModelConsumer(
                observeOn: ViewModelProvider.of<MyViewModel>(context).liveData,
                listener: (context, value) {},
                builder: (context, value) {
                  debugPrint("wow");
                  return Text("$value");
                }),
          ],
        ),
      ),
      floatingActionButton: ViewModelListener(
          observeOn: ViewModelProvider.of<MyViewModel>(context).sharedFlow,
          listener: (context, value) {
            debugPrint("listener - $value");
          },

          /*builder: (context, state) {*/
          child: FloatingActionButton(
            onPressed: () {
              ViewModelProvider.of<MyViewModel>(context).increment();
            },
            child: const Icon(Icons.add),
          )
        // },
      ),
    );
  }
}
