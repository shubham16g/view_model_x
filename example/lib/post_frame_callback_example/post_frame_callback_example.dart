import 'package:flutter/material.dart';
import 'package:view_model_x/view_model_x.dart';

import 'view_model/my_view_model_with_post_frame_callback.dart';

class PostFrameCallbackExample extends StatelessWidget {
  const PostFrameCallbackExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider(
      create: (context) => MyViewModelWithPostFrameCallback(),
      // child: MaterialApp(home: const ContentPage()),
      child: const ContentPage(),
    );
  }
}

class ContentPage extends StatelessWidget {
  const ContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: const CloseButton(),
          titleSpacing: 0,
          title: const Text('ViewModel with PostFrameCallback Example')),
      body: SharedFlowListener(
        sharedFlow:
            context.vm<MyViewModelWithPostFrameCallback>().messageSharedFlow,
        listener: (context, value) {
          // show SnackBar
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value)));
        },
        child: const Center(
          child: Text('SnackBar will appear on PostFrameCallback'),
        ),
      ),
    );
  }
}
