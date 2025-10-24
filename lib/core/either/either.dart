part of perfect_contacts;

abstract class _Either<L, R> {
  const _Either();

  T fold<T>(T Function(L) onLeft, T Function(R) onRight);

  bool isLeft() => this is _Left<L, R>;
  bool isRight() => this is _Right<L, R>;
}

class _Left<L, R> extends _Either<L, R> {
  final L value;

  const _Left(this.value);

  @override
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => onLeft(value);
}

class _Right<L, R> extends _Either<L, R> {
  final R value;

  const _Right(this.value);

  @override
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) => onRight(value);
}