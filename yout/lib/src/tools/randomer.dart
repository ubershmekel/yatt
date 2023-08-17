import 'dart:math';

final _rng = Random();

extension RandomListItem<T> on List<T> {
  T randomItem() {
    return this[_rng.nextInt(length)];
  }
}
