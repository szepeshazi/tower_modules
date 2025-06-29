extension Loop<T> on List<T> {
  List<T> loopedFromIndex(int index) {
    final higher = skip(index).take(length);
    final lower = take(index);
    return [...higher, ...lower];
  }
}
