import 'dart:async';

import 'package:flutter/material.dart';

class Pipe<T>{
  StreamController<T> _streamController = StreamController<T>();

  get receive => _streamController.stream;

  void send(T t){
    _streamController.sink.add(t);
  }

  void listen(Listener<T> listener){
    receive.listen(listener);
  }


  void dispose(){
    _streamController.close();
  }

}
typedef void Listener<T>(T t);
class BroadcastPipe<T>{

  StreamController<T> _streamController = StreamController<T>.broadcast();

  get receive => _streamController.stream;

  void listen(Listener<T> listener){
    receive.listen(listener);
  }

  void send(T t){
    _streamController.sink.add(t);
  }


  void dispose(){
    _streamController.close();
  }



}

class EventPipe{

  StreamController _streamController = StreamController();

  get receive => _streamController.stream;

  void listen(VoidCallback listener){
    receive.listen((_) => listener());
  }

  void launch(){
    _streamController.sink.add(null);
  }


  void dispose(){
    _streamController.close();
  }



}