import 'package:emitter_flutter/emitter_flutter.dart';

class MainObserver implements EmitterObserver {
  @override
  void onDispose(Emitter emitter) {
    print(
      'Global dispose on emitter: ${_replaceInstanceOf(emitter)}.',
    );
  }

  @override
  void onInit(Emitter emitter) {
    print(
      'Global init on emitter: ${_replaceInstanceOf(emitter)}.',
    );
  }

  @override
  void onTransition(Emitter emitter) {
    print(emitter.prevState.runtimeType);
    print(emitter.state.runtimeType);
  }

  String _replaceInstanceOf(Emitter emitter) {
    return emitter.runtimeType.toString();
  }
}
