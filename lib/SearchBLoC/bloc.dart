import 'package:bloc/bloc.dart';
import 'package:flutter_bloc_visual/SearchBLoC/state.dart';
import 'package:rxdart/rxdart.dart';

import 'event.dart'; // Necessary for debounceTime extension

// Mock function to simulate API call
Future<List<String>> fetchResults(String query) async {
  await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
  return List.generate(3, (index) => 'Result for "$query" $index');
}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    // Registering the handler for SearchTextChanged event
    on<SearchTextChanged>(
      _onSearchTextChanged,
      transformer: debounce(const Duration(milliseconds: 300)),
    );
  }

  // Debounce method using EventTransformer
  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).switchMap(mapper);
  }

  void _onSearchTextChanged(
      SearchTextChanged event, Emitter<SearchState> emit) async {
    final searchText = event.searchText;

    if (searchText.isEmpty) {
      emit(SearchInitial());
    } else {
      emit(SearchLoading());
      try {
        final results = await fetchResults(searchText);
        emit(SearchLoaded(results));
      } catch (_) {
        emit(SearchError());
      }
    }
  }
}
