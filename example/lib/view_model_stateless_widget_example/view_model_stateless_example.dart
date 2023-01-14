import 'package:flutter/material.dart';
import 'package:view_model_x/view_model_x.dart';

import 'view_model/counter_view_model.dart';

class ViewModelStatelessWidgetExample
    extends ViewModelStatelessWidget<CounterViewModel> {
  const ViewModelStatelessWidgetExample({Key? key}) : super(key: key);

  @override
  CounterViewModel createViewModel(BuildContext context) => CounterViewModel();

  @override
  Widget buildWithViewModel(BuildContext context, CounterViewModel viewModel) {
    return Scaffold(
      appBar: AppBar(
          leading: const CloseButton(),
          titleSpacing: 0,
          title: const Text('ViewModel Stateless Widget Example')),
      // implement SharedFlowListener anywhere in code to listen for emits from sharedFlow
      body: Center(
        // implement ViewModelBuilder to rebuild Text on StateFlow value changed/updated
        child: StateFlowBuilder(
            // pass your StateFlow
            stateFlow: viewModel.counterStateFlow,
            builder: (context, value) {
              return Text(
                "$value",
                style: const TextStyle(fontSize: 30),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "view_model_stateless_widget_example",
        onPressed: () {
          // call the increment function which is inside CounterViewModel
          viewModel.increment();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
