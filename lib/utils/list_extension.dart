import 'dart:math';

final Random _random = Random();

extension ListExtension on List {
  T random<T>() {
    final index = _random.nextInt(length - 1);
    return this[index] as T;
  }
}
