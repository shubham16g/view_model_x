# View Model X

[![](https://img.shields.io/pub/v/view_model_x.svg?color=success&label=pub.dev&logo=dart&logoColor=0099ff)](https://pub.dev/packages/view_model_x)

An Android similar state management package which helps to implement MVVM pattern easily.

> **Note:** In Android, ViewModel have an special functionality of keeping the state on configuration change.
> The ViewModel of this package is not for that as Flutter Project doesn't need it. It is only for separating the View Logic from UI.

**🚀 LIVE DEMO OF EXAMPLE PROJECT:** https://shubham-gupta-16.github.io/view_model_x/


## Features

- Simplified 😎 State Management
- Similar code pattern with an Android project 🟰
- Easy for developers to migrate 🛩️ from Android to Flutter
- Allows developer to work with both Android to Flutter projects with ease 🐥
- Easy to implement MVVM pattern 💪

## Package Components
- StateFlow, MutableStateFlow (equivalent to LiveData) ⛵
- SharedFlow, MutableSharedFlow 🌊
- ViewModel (to separate the view logic from UI like Cubit)
- ViewModelProvider
- StateFlowBuilder
- StateFlowConsumer
- StateFlowListener
- SharedFlowListener
- MultiFlowListener
- ChangeNotifierProvider
- MultiProvider

## Usage

### my_view_model.dart

```dart
class CounterViewModel extends ViewModel {
  // initialize MutableStateFlow with initial value 1
  final _counterStateFlow = MutableStateFlow<int>(1);

  StateFlow<int> get counterStateFlow => _counterStateFlow;

  // you can also define more the one StateFlow or SharedFlow inside any ViewModel

  void increment() {
    // by changing the value, listeners notified
    _counterStateFlow.value = _counterStateFlow.value + 1;
  }

  @override
  void dispose() {
    // must dispose all the StateFlows and SharedFlows
    _counterStateFlow.dispose();
  }
}
```

### main.dart

```dart
void main() => runApp(CounterApp());

class CounterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ViewModelProvider(
        create: (_) => CounterViewModel(),
        child: CounterPage(),
      ),
    );
  }
}
```

### counter_page.dart

```dart
class CounterPage extends StatelessWidget {
  const CounterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ViewModel Counter Example')),
      body: Center(
        // implement StateFlowBuilder to rebuild Text on StateFlow value changed/updated
        child: StateFlowBuilder(
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

## Package Components

### ViewModel (Create custom ViewModel class)
Create your custom View-Model which must extends `ViewModel`. Declare all your Flows and View related logic inside of it.
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

### PostFrameCallback with ViewModel
Using `PostFrameCallback` with `ViewModel` helps to get `onPostFrameCallback` event inside `ViewModel` easily.

```dart
class CustomViewModel extends ViewModel with PostFrameCallback {
  //...
  
  @override
  void onPostFrameCallback(Duration timestamp) {
    // do stuffs here
  }
}
```

### MutableStateFlow and StateFlow
`MutableStateFlow` is inherited from `StateFlow`. It stores value and notify listeners whenever it changes. It can change/update the value.

> It is recommended to initialize private `MutableStateFlow` and create a public `StateFlow` getter of it.  

```dart
final _myStateFlow = MutableStateFlow<int>(1, notifyOnSameValue: true);
StateFlow<int> get myStateFlow => _myStateFlow;
```


Here, notifyOnSameValue is optional. If `notifyOnSameValue` is set to false, whenever you call `stateFlow.value = newValue`
where newValue is same as current value, it will not notify listeners. by default it is set to true.

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

## Integrate ViewModel Into Flutter Widget

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

## Builder, Listener, and Consumer Flutter Widgets 

### StateFlowBuilder

`StateFlowBuilder` is used to rebuild the widgets inside of it.
This requires `stateFlow` to listen on and `builder` to which rebuilds when the `stateFlow`'s value changed/updated.

```dart
StateFlowBuilder(
  stateFlow: context.vm<CustomViewModel>().myStateFlow, // pass StateFlow
  builder: (context, value) {
    return ChildWidget(value); // rebuild the widget with updated/changed value.
  },
)
```


### Experimental `StateFlow.watch(BuildContext)`
We can use `watch` with any `StateFlow` which observe the value change and update the ui. 
This is similar to Provider's `context.watch<MyChangeNotifier>()`. 
```dart
final value = context.vm<CustomViewModel>().myStateFlow.watch(context);
```

### StateFlowConsumer

`StateFlowConsumer` is used to rebuild the widgets inside of it and call the listener.
This requires `stateFlow` to listen on, `builder` and `listener`.
Whenever `stateFlow`'s value changed/updated, `builder` will rebuild the widgets inside of it and `listener` will called.

```dart
StateFlowConsumer(
  stateFlow: ViewModelProvider.of<CustomViewModel>(context).myStateFlow, // pass SharedFlow
  listener: (context, value) {
    // do stuff here based on value
  },
  builder: (context, value) {
    return ChildWidget(value); // rebuild the widget with updated/changed value.
  },
)
```

### StateFlowListener

`StateFlowListener` is used to catch the change/update value event of a `stateFlow`.
This requires `stateFlow`, `listener` and `child`.
Whenever `stateFlow`'s value changed/updated, `listener` will called.

```dart
StateFlowListener(
  stateFlow: ViewModelProvider.of<CustomViewModel>(context).myStateFlow, // pass StateFlow
  listener: (context, value) {
    // do stuff here based on value
  },
  child: ChildWidget(),
)
```


### SharedFlowListener

`SharedFlowListener` is used to catch the emitted value from `sharedFlow`.
This requires `sharedFlow`, `listener` and `child`.
Whenever `sharedFlow` emits a value, `listener` will called.

```dart
SharedFlowListener(
  sharedFlow: ViewModelProvider.of<CustomViewModel>(context).mySharedFlow, // pass SharedFlow
  listener: (context, value) {
    // do stuff here based on value
  },
  child: ChildWidget(),
)
```


### MultiFlowListener

`MultiFlowListener` is a Flutter widget that merges multiple `SharedFlowListener` and `StateFlowListener` widgets into one.
`MultiFlowListener` improves the readability and eliminates the need to nest multiple listeners.
By using `MultiFlowListener` we can go from:

```dart
SharedFlowListener(
  sharedFlow: context.vm<ViewModelA>().mySharedFlow,
  listener: (context, value) {
    // do stuff here based on value
  },
  child: StateFlowListener(
    stateFlow: context.vm<ViewModelA>().myStateFlow,
    listener: (context, value) {
      // do stuff here based on value
    },
    child: SharedFlowListener(
      sharedFlow: context.vm<ViewModelB>().anySharedFlow,
      listener: (context, value) {
        // do stuff here based on value
      },
      child: ChildA(),
    )
  )
)
```
to
```dart
MultiFlowListener(
  providers: [
    SharedFlowListener(
      sharedFlow: context.vm<ViewModelA>().mySharedFlow,
      listener: (context, value) {
        // do stuff here based on value
      },
    ),
    StateFlowListener(
      stateFlow: context.vm<ViewModelA>().myStateFlow,
      listener: (context, value) {
        // do stuff here based on value
      },
    ),
    SharedFlowListener(
      sharedFlow: context.vm<ViewModelB>().anySharedFlow,
      listener: (context, value) {
        // do stuff here based on value
      },
    ),
  ],
  child: ChildA(),
)
```

## Extra Provider
This package also includes some of Provider components with some modification. These are:

### ChangeNotifierProvider
This will allows to wrap a widget around ChangeNotifier.

```dart
ChangeNotifierProvider(
  create: (context) => CustomChangeNotifier(),
  child: WidgetA(),
)
```

To get the instance of `ChangeNotifier` or listen for `notifyListeners()`:
```dart
ChangeNotifierProvider.of<CustomChangeNotifier>(context, listen: true)
```
If `listen` is `true`, the Widget will rebuild on `notifyListeners()`. This can also be written in simplified way.
If want to listen for `notifyListeners()`, use:
```dart
context.watch<CustomChangeNotifier>()
```
Or if want only instance, use:
```dart
context.read<CustomChangeNotifier>()
```

> **Note:** Here `context.watch` and `context.read` is modified from provider library. Here, type is restricted to ChangeNotifier.

### MultiProvider
`MultiProvider` is a Widget that merges multiple `ViewModelProvider` and `ChangeNotifierProvider` widgets into one.
`MultiProvider` improves the readability and eliminates the need to nest multiple widgets.
By using `MultiProvider` we can go from:

```dart
ViewModelProvider(
  create: (context) => ViewModelA(),
  child: ViewModelProvider(
    create: (context) => ViewModelB(),
    child: ChangeNotifierProvider(
      create: (context) => ChageNotifierA(),
      child: ChildA(),
    )
  )
)
```
to
```dart
MultiProvider(
  providers: [
    ViewModelProvider(
      create: (context) => ViewModelA(),
    ),
    ViewModelProvider(
      create: (context) => ViewModelB(),
    ),
    ChageNotifierProvider(
      create: (context) => ChageNotifierA(),
    ),
  ],
  child: ChildA(),
)
```
> **Note:** This MultiProvider is different from one in Provider package. This will only accepts `ViewModelProvider` and `ChangeNotifierProvider`.
## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

