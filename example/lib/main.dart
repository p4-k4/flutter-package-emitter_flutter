// import 'emitter.dart';
import 'package:flutter/material.dart';
// import 'package:emitter/emitter.dart';

import 'package:emitter_flutter/emitter_flutter.dart';

import 'emitters/counter.emitter.dart';
import 'emitters/global.observer.dart';

void main() {
  EmitterObserver.observer = MainObserver();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Home(),
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
    );
  }
}

final counterEmitterA = CounterEmitter(CounterStateNoData());
final counterEmitterB = CounterEmitter(CounterStateNoData());

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home..')),
      body: Column(
        children: [
          const Text('', style: TextStyle()),
          ObserverWidget((c) => switch (counterEmitterA.state) {
                CounterStateData(:var count) => Text('$count'),
                CounterStateNoData() => const Text('No Data'),
                CounterStateWaiting() => const Text('Waiting'),
                CounterStateError() => const Text('Error'),
              }),
          ObserverWidget((c) => switch (counterEmitterB.state) {
                CounterStateData(:var count) => Text('$count'),
                CounterStateNoData() => const Text('No Data'),
                CounterStateWaiting() => const Text('Waiting'),
                CounterStateError() => const Text('Error'),
              }),
          ElevatedButton(
              onPressed: () => counterEmitterA.setEvent(CounterEventInc()),
              child: const Text('Inc 1')),
          ElevatedButton(
              onPressed: () => counterEmitterB.setEvent(CounterEventDec()),
              child: const Text('Inc 2')),
          // ObserverWidget(
          //   (c) => switch (counterEmitter.state) {
          //     CounterStateNoData() => const Text('NoData'),
          //     CounterStateData(:var count) => Text('$count'),
          //     CounterStateWaiting() => const Text('Waiting'),
          //     CounterStateError() => const Text('Error'),
          //   },
          // ),
          // ElevatedButton(
          //     onPressed: () => counterEmitter.setEvent(CounterEventInc()),
          //     child: const Text('++'))
        ],
      ),
    );
  }
}
