import 'package:kupuhu/src/common_widgets/error_message_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AsyncValueWidget<T> extends StatelessWidget {
  const AsyncValueWidget({
    Key? key,
    required this.asyncValue,
    required this.data,
  }) : super(key: key);

  final AsyncValue<T> asyncValue;
  final Widget Function(T) data;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      data: data,
      error: (e, st) => Center(child: ErrorMessageWidget(e.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
