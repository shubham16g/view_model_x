import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MNotifier extends ChangeNotifier {
  int count = 0;

  void increment() {
    count++;
    notifyListeners();
  }
}

class TestProviderPage extends StatelessWidget {
  const TestProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChangeNotifierProvider(create: (context) => MNotifier(),child: const _TestProviderPageBody()),
    );
  }
}

class _TestProviderPageBody extends StatelessWidget {
  const _TestProviderPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('You have pushed the button this many times:'),
          Consumer<MNotifier>(
            builder: (context, value, child) {
              return Text(
                '${value.count}',
                style: Theme.of(context).textTheme.bodyLarge,
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MNotifier>().increment();
            },
            child: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}
