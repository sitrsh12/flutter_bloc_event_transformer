import 'package:equatable/equatable.dart';

// Define the possible states of the search
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<String> results;

  const SearchLoaded(this.results);

  @override
  List<Object> get props => [results];
}

class SearchError extends SearchState {}
