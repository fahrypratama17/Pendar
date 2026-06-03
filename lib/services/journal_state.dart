import 'package:equatable/equatable.dart';
import '../models/journal_model.dart';

abstract class JournalState extends Equatable {
  const JournalState();

  @override
  List<Object?> get props => [];
}

class JournalInitial extends JournalState {}

class JournalLoading extends JournalState {}

class JournalLoadSuccess extends JournalState {
  final List<JournalModel> journals;

  const JournalLoadSuccess(this.journals);

  @override
  List<Object?> get props => [journals];
}

class JournalOperationSuccess extends JournalState {}

class JournalFailure extends JournalState {
  final String message;

  const JournalFailure(this.message);

  @override
  List<Object?> get props => [message];
}
