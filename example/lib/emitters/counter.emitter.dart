library counter_emitter;

// import 'package:emitter/emitter.dart';
import 'package:emitter_flutter/emitter_flutter.dart';

part 'counter.state.dart';
part 'counter.event.dart';
part 'counter.observer.dart';

class CounterEmitter extends Emitter<CounterEvent, CounterState> {
  CounterEmitter(super.initialState) {
    on<CounterEventInc>((e) async {
      if (state case CounterStateWaiting()) return;
      if (state case CounterStateData(:var count)) {
        setState(CounterStateWaiting(), skipTransition: true);
        await Future.delayed(const Duration(seconds: 1));
        setState(CounterStateData(count + 1));
      } else {
        setState(CounterStateWaiting(), skipTransition: true);
        await Future.delayed(const Duration(seconds: 1));
        setState(CounterStateData(0));
      }
    });
    on<CounterEventDec>((e) async {
      if (state case CounterStateWaiting()) return;
      if (state case CounterStateData(:var count)) {
        setState(CounterStateWaiting(), skipTransition: true);
        await Future.delayed(const Duration(seconds: 1));
        setState(CounterStateData(count - 1));
      } else {
        setState(CounterStateWaiting(), skipTransition: true);
        await Future.delayed(const Duration(seconds: 1));
        setState(CounterStateData(0));
      }
    });
  }
  @override
  void onTransition(
      CounterState prevState, CounterState nextState, CounterEvent event) {}
}
