class Notifier<T> {
  Notifier([T? initialState]) {
    if (initialState != null) {
      _state = initialState;
    }
  }

  late T _state;

  T get state => _state;

  final subscriptions = <Subscription<T>>[];

  Subscription<T> listen(
    void Function(T value) callback, {
    Object? Function(T value)? selector,
    bool triggerImmediately = false,
  }) {
    if (triggerImmediately) {
      callback(_state);
    }
    final sub = Subscription(callback, parent: this, selector: selector);
    subscriptions.add(sub);
    return sub;
  }

  void setInitialState(T value) {
    _state = value;
  }


  void emit(T newValue) {
    if (newValue == _state) {
      return;
    }
    for (final sub in subscriptions) {
      final selector = sub.selector;
      if (selector != null && selector(_state) == selector(newValue)) {
        continue;
      }
      sub.callback(newValue);
    }
    _state = newValue;
  }

  void remove(Subscription<T> sub) {
    subscriptions.remove(sub);
  }

  void removeAll() {
    subscriptions.clear();
  }
}

class Subscription<T> {
  Subscription(this.callback, {required this.parent, this.selector});

  final void Function(T value) callback;
  final Notifier<T> parent;
  Object? Function(T value)? selector;

  void cancel() {
    parent.remove(this);
  }
}
