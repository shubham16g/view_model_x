import 'package:flutter/material.dart';
import 'package:view_model_x/view_model_x.dart';

import 'view_model/first_view_model.dart';
import 'view_model/second_view_model.dart';

class ResponsiveExample extends StatelessWidget {
  const ResponsiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Responsive"),
      ),
      body: isDesktop
          ? const FirstSection()
          : ViewModelProvider(
              create: (context) => SecondViewModel(),
              child: const SecondSection()),
    );
  }
}

class FirstSection extends StatelessWidget {
  const FirstSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      create: (c) => FirstViewModel(),
      builder: (ctx, v) => Container(
        color: Colors.green,
        child: Center(
          child: Text(ViewModelProvider.of<FirstViewModel>(ctx)
              .counterStateFlow
              .value
              .toString()),
        ),
      ),
    );
  }
}

class SecondSection extends StatelessWidget {
  const SecondSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
    );
  }
}
