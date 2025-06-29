import 'package:tower_modules/state/module_state_notifier.dart';

class VaultException implements Exception {
  final String message;

  VaultException([this.message = 'Unknown exception while accessing Vault']);

  @override
  String toString() => message;
}

class Vault {
  Vault._();

  factory Vault.registerAll() {
    final vault = Vault._();
    vault.add<ModuleStateNotifier>(ModuleStateNotifier(ModuleStateNotifier.defaultState));
    return vault;
  }

  final _store = <Type, Object>{};

  void add<T>(Object object) {
    _store[T] = object;
  }

  void remove<T>(Object object) {
    _store.remove(T);
  }

  void clear() {
    _store.clear();
  }

  T get<T>() {
    final result = _store[T];
    if (result != null) {
      return result as T;
    }
    // Linear search amongst keys for subclasses
    for (final key in _store.keys) {
      if (key is T) {
        final value = _store[key]!;
        _store[T] = value;
        return value as T;
      }
    }

    throw VaultException('No class registered for $T in the Vault');
  }

  T? getOrNull<T>() {
    try {
      return get<T>();
    } on VaultException {
      return null;
    }
  }

  static final instance = Vault.registerAll();
}
