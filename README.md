# View Model

A ViewModel and Flow based state management package (inspired by Android ViewModel) make it easy to implement the MVVM pattern.

## Features

- Simplified ☺️ State Management
- Easy to implement MVVM pattern 💪
- Android 💚 like Environment
- StateFlow (equivalent to LiveData) ⛵
- SharedFlow 🌊

## Getting started

```console
flutter pub add viewmodel
```

## Usage

### my_view_model.dart

```dart
class CounterViewModel extends ViewModel {
  // initialize StateFlow
  final _counterStateFlow = MutableStateFlow<int>(1);

  StateFlow<int> get counterStateFlow => _counterStateFlow;

  void increment() {
    // by changing the value, listeners were notified
    _counterStateFlow.value = _counterStateFlow.value + 1;
  }

  @override
  void dispose() {
    // must dispose all flows
    _counterStateFlow.dispose();
  }
}
```

### counter_page.dart

```dart
class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // wrap the content with your custom ViewModel
    return ViewModelProvider(
      create: (context) => CounterViewModel(),
      child: const CounterPageContent(),
    );
  }
}
```

### counter_page_content.dart
Any widget nested inside `ViewModelProvider`

```dart
class CounterPageContent extends StatelessWidget {
  const CounterPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ViewModel Counter Example')),
      body: Center(
        // implement ViewModelBuilder to rebuild Text on StateFlow value changed/updated
        child: ViewModelBuilder(
            // pass your StateFlow
            stateFlow: context.vm<CounterViewModel>().counterStateFlow,
            builder: (context, value) {
              return Text("$value", style: const TextStyle(fontSize: 30));
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // call the increment function which is inside MyViewModel
          ViewModelProvider.of<CounterViewModel>(context).increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

