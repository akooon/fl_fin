
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diploma_work/screens/main_pages/bloc/home_event.dart';
import 'package:diploma_work/screens/main_pages/bloc/home_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final FirebaseFirestore _firestore;

  MainBloc(this._firestore) : super(MainState(dataList: [], isLoading: false));

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is LoadData) {
      yield* _mapLoadDataToState();
    }
  }

  Stream<MainState> _mapLoadDataToState() async* {
    yield state.copyWith(isLoading: true);
    try {
      final dataCollection = _firestore.collection('homecollec');
      final snapshot = await dataCollection.get();
      final dataList = snapshot.docs.map((doc) => doc.data()['news'] as String).toList();
      yield state.copyWith(dataList: dataList, isLoading: false);
    } catch (_) {
      yield state.copyWith(isLoading: false);
      // Handle error
    }
  }
}
