# View Model X

A ViewModel and Flow based state management package (inspired by Android ViewModel) make it easy to implement the MVVM pattern.

## Features

- Simplified ☺️ State Management
- Easy to implement MVVM pattern 💪
- Android 💚 like Environment
- StateFlow (equivalent to LiveData) ⛵
- SharedFlow 🌊

## Getting started

```console
flutter pub add view_model_x
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
            },
        ),
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

## ViewModel Elements

### Custom ViewModel class
Create a your custom View-Model which must extends `ViewModel`. Declare all your Flows and View related logic inside of it.
Don't forget to dispose all flows inside `dispose` method of `ViewModel`.

```dart
class CustomViewModel extends ViewModel {
  // initialize StateFlow
  final _myStateFlow = MutableStateFlow<int>(1);

  StateFlow<int> get myStateFlow => _myStateFlow;

  // view related logic here

  @override
  void dispose() {
    // must dispose all flows
    _myStateFlow.dispose();
  }
}
```

### MutableStateFlow and StateFlow
`MutableStateFlow` is inherited from `StateFlow`. It stores value and notify listeners whenever it changes. It can change/update the value.

> It is recommended to initialize private `MutableStateFlow` and create a public `StateFlow` getter of it.  

```dart
final _myStateFlow = MutableStateFlow<int>(1);
StateFlow<int> get myStateFlow => _myStateFlow;
```

**To change the value**

```dart
_myStateFlow.value = 5; // listeners were automatically notified
```

**To update the value**

```dart
_listStateFlow.update((value) {
  value.add(obj);
}); // listeners were automatically notified
```

### MutableSharedFlow and SharedFlow
`MutableSharedFlow` is inherited from `SharedFlow`. It is used to send data to the listeners. It can emit the value.

> It is recommended to initialize private `MutableSharedFlow` and create a public `SharedFlow` getter of it.

```dart
final _mySharedFlow = MutableSharedFlow<String>();
SharedFlow<int> get mySharedFlow => _mySharedFlow;
```

**To emit the value**

```dart
_myStateFlow.emit("Hello from ViewModel!"); // listeners were automatically notified
```

## ViewModel Flutter Widgets

### ViewModelProvider

`ViewModelProvider` is used to wrap the widget with your custom `ViewModel`.
This requires `create` which accepts custom `ViewModel` and `child` Widget.

```dart
ViewModelProvider(
  create: (context) => counterViewModel, // provide your custom viewModel
  child: ChildWidget(),
);
```

### Get ViewModel instance inside Widget Tree

```dart
ViewModelProvider.of<CustomViewModel>(context)
```
OR
```dart
context.vm<CustomViewModel>()
```

### ViewModelBuilder

`ViewModelBuilder` is used to rebuild the widgets inside of it.
This requires `stateFlow` to listen on and `builder` to which rebuilds when the `stateFlow`'s value changed/updated.

```dart
ViewModelBuilder(
  stateFlow: context.vm<CustomViewModel>().myStateFlow, // pass StateFlow
  builder: (context, value) {
    return ChildWidget(value); // rebuild the widget with updated/changed value.
  },
)
```

### ViewModelConsumer

`ViewModelConsumer` is used to rebuild the widgets inside of it and call the listener.
This requires `stateFlow` to listen on, `builder` and `listener`.
Whenever `stateFlow`'s value changed/updated, `builder` will rebuild the widgets inside of it and `listener` will called.

```dart
ViewModelConsumer(
  stateFlow: ViewModelProvider.of<CustomViewModel>(context).myStateFlow, // pass SharedFlow
  listener: (context, value) {
    // do stuff here based on value
  },
  builder: (context, value) {
    return ChildWidget(value); // rebuild the widget with updated/changed value.
  },
)
```

### ViewModelListener

`ViewModelListener` is used to rebuild the widgets inside of it and call the listener.
This requires `flow` (which can be `SharedFlow` or `StateFlow`), `listener` and `child`.
Whenever `flow`'s value changed/updated (if it is StateFlow) or emit value (it it is StateFlow), `listener` will called.

```dart
ViewModelListener(
  flow: ViewModelProvider.of<CustomViewModel>(context).anyStateFlowOrSharedFlow, // pass StateFlow or SharedFlow
  listener: (context, value) {
    // do stuff here based on value
  },
  child: ChildWidget(),
)
```

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

