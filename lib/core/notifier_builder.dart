import 'package:flutter/material.dart';
import 'package:tower_modules/core/notifier.dart';
import 'package:tower_modules/core/vault_provider.dart';

typedef NotificationStateBuilder<T> =
    Widget Function(BuildContext context, T state, Widget? child);

class NotifierBuilder<T extends Notifier<S>, S> extends StatefulWidget {
  const NotifierBuilder({
    required this.builder,
    this.resolver,
    this.selector,
    this.child,
    super.key,
  });

  final Widget? child;

  final T Function()? resolver;

  final Object? Function(S value)? selector;

  final NotificationStateBuilder<S> builder;

  @override
  State<NotifierBuilder<T, S>> createState() => _NotifierBuilderState<T, S>();
}

class _NotifierBuilderState<T extends Notifier<S>, S>
    extends State<NotifierBuilder<T, S>> {
  late S _state;
  Subscription? subscription;

  void _subscribe(T Function() resolver) {
    final notifier = resolver();
    subscription?.cancel();
    subscription = notifier.listen(selector: widget.selector, (value) {
      setState(() {
        _state = value;
      });
    });
    _state = notifier.state;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _state, widget.child);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final resolver = widget.resolver ?? () => context.get<T>();
    _subscribe(resolver);
  }

  @override
  void didUpdateWidget(covariant NotifierBuilder<T, S> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final resolver = widget.resolver ?? () => context.get<T>();
    _subscribe(resolver);
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
}
