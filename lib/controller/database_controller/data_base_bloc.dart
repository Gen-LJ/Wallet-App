import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'data_base_event.dart';
part 'data_base_state.dart';

class DataBaseBloc extends Bloc<DataBaseEvent, DataBaseState> {
  DataBaseBloc() : super(DataBaseInitial()) {
    on<DataBaseEvent>((event, emit) {

    });
  }
}
