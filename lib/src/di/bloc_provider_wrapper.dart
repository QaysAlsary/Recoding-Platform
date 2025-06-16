import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocProviderWrapper<T extends BlocBase<Object?>> extends StatelessWidget {
  final Widget child;
  final T Function(BuildContext) create;
  final List<BlocListener<T, dynamic>>? listeners;

  const BlocProviderWrapper({
    Key? key,
    required this.child,
    required this.create,
    this.listeners,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: create,
      child: listeners != null
          ? MultiBlocListener(
              listeners: listeners!,
              child: child,
            )
          : child,
    );
  }
}
