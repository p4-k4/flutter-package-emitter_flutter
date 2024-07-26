// ignore_for_file: avoid_print

part of counter_emitter;

class CounterEmitterObserver implements EmitterObserver {
  @override
  void onInit(Emitter emitter) {
    print('Emitter created: $emitter');
  }

  @override
  void onDispose(Emitter emitter) {
    print('Emitter disposed: $emitter');
  }

  @override
  void onTransition(Emitter emitter) {
    print('$emitter');
  }
}
