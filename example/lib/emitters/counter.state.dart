part of counter_emitter;

sealed class CounterState {}

class CounterStateWaiting extends CounterState {}

class CounterStateNoData extends CounterState {}

class CounterStateData extends CounterState {
  CounterStateData(this.count);
  final int count;
}

class CounterStateError extends CounterState {
  CounterStateError(this.e, this.s);
  final Object e;
  final StackTrace s;
}
