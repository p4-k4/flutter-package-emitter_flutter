library emitter_flutter;

// ignore_for_file: null_check_on_nullable_type_parameter

// ignore_for_file: unused_field, avoid_print

import 'dart:async';
import 'package:flutter/material.dart';

abstract class Emitter<E, S> {
  /// Create a new instance of an emitter with the given initial state
  Emitter(this.initialState) {
    _state = initialState;
    _prevState = initialState;
    init();
  }

  final _observers = <ObserverState>[];
  final _callbacks = <Type, void Function(E)>{};

  final controller = StreamController<E>.broadcast();
  StreamSubscription<E>? _subscription;

  final S initialState;
  late S _state;
  late S _prevState;

  /// The previous state of the emitter
  S get prevState {
    return _prevState;
  }

  /// The current state of the emitter
  S get state {
    _registerObserver();
    return _state;
  }

  E? _currentEvent;

  /// Reset the emitter to its initial state and dispose of any existing subscriptions
  void reset({bool andNotify = true}) {
    dispose();
    _state = initialState;
    _prevState = initialState;
    if (andNotify) setState(initialState);
  }

  void _ensureSubscribed() {
    // Resubscribes if _subscription is null.
    _subscription ??= controller.stream.listen((event) {
      _callbacks[event.runtimeType]?.call(event);
    });
  }

  /// Initialize the emitter and notify listeners of the initialization
  void init() {
    _ensureSubscribed();
    EmitterObserver.observer?.onInit(this);
  }

  /// Dispose of the emitter and release any resources held by it
  void dispose() {
    EmitterObserver.observer?.onDispose(this);
    _subscription?.cancel();
    _subscription = null;
  }

  /// Set the state of the emitter to the given value and notify listeners of the change in state
  ///
  /// **Important:** Make sure to pass [true] for [skipPrevState] when setting a new state that requires bypassing transitions.
  /// Similarly, passing [true] to [skipPrevState] will skip setting the previous state, while listeners are still notified.
  void setState(S s,
      {bool skipTransition = false, bool skipObservers = false}) {
    if (skipTransition) _prevState = _state;
    _state = s;
    if (_currentEvent != null) {
      if (!skipTransition) {
        onTransition(_prevState, s, _currentEvent!);
        EmitterObserver.observer?.onTransition(this);
      }
    }
    if (!skipObservers) _notifyObservers();
  }

  /// Emit an event of the given type and notify listeners of the event
  void setEvent(E e) {
    _ensureSubscribed();
    controller.add(e);
    _currentEvent = e;
  }

  /// Registers a callback function to handle events of type [X].
  ///
  /// This method registers a callback function to be executed whenever an event of type [X] occurs. The callback function accepts an argument of type [X], representing the event data.
  ///
  /// **Important:** Make sure to pass [true] as the second argument to [setState()] when setting a new state that requires bypassing transitions.
  ///
  /// Example usage:
  ///
  /// ```dart
  /// counterEmitter.on<CounterEventInc>((event) {
  ///   setState(CounterStateWaiting(), skipTransition: true);
  /// });
  /// ```
  ///
  void on<X extends E>(Function(X e) callback) {
    final type = X;
    _callbacks.putIfAbsent(type, () => (state) => callback(state as X));
  }

  // Notify listeners of a transition from the previous state to the current state
  void onTransition(S prevState, S nextState, E event) {}

  void removeObserver(ObserverState observer) {
    _observers.remove(observer);
  }

  void _registerObserver() {
    final currentObserver = ObserverState.current;
    if (currentObserver != null && !_observers.contains(currentObserver)) {
      _observers.add(currentObserver);
      currentObserver.addObservable<E, S>(this);
    }
  }

  void _notifyObservers() {
    for (final observer in _observers) {
      observer.update();
    }
  }
}

abstract class EmitterObserver {
  static EmitterObserver? observer;
  void onInit(Emitter emitter);
  void onTransition(Emitter emitter);
  void onDispose(Emitter emitter);
}

class ObserverWidget extends StatefulWidget {
  const ObserverWidget(this.builder, {super.key});
  final Widget Function(BuildContext context) builder;
  static ObserverState? current;

  @override
  ObserverState createState() => ObserverState();
}

class ObserverState extends State<ObserverWidget> {
  static ObserverState? current;
  List<Emitter> observables = [];

  void update() {
    if (mounted) {
      setState(() {});
    }
  }

  void addObservable<E, S>(Emitter<E, S> observable) {
    observables.add(observable);
  }

  @override
  void dispose() {
    for (var observable in observables) {
      observable.removeObserver(this);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final previousObserver = current;
    current = this;
    var builtWidget = widget.builder(context);
    current = previousObserver;
    return builtWidget;
  }
}
