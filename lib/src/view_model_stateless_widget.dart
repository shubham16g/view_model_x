import 'package:flutter/widgets.dart';
import 'view_model_provider.dart';
import 'view_model.dart';

/// [ViewModelStatelessWidget] helps to integrate [ViewModel] into [StatelessWidget] easily.
abstract class ViewModelStatelessWidget<T extends ViewModel>
    extends StatelessWidget {
  const ViewModelStatelessWidget({Key? key}) : super(key: key);

  T createViewModel(BuildContext context);

  Widget buildWithViewModel(BuildContext context, T viewModel);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      create: createViewModel,
      builder: (context, w) => buildWithViewModel(context, context.vm<T>()),
    );
  }
}
