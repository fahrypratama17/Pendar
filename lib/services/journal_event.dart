import 'package:equatable/equatable.dart';

abstract class JournalEvent extends Equatable {
  const JournalEvent();

  @override
  List<Object?> get props => [];
}

class JournalLoadRequested extends JournalEvent {}

class JournalAddRequested extends JournalEvent {
  final String title;
  final String content;
  final int mood;

  const JournalAddRequested({
    required this.title,
    required this.content,
    required this.mood,
  });

  @override
  List<Object?> get props => [title, content, mood];
}

class JournalUpdateRequested extends JournalEvent {
  final String id;
  final String title;
  final String content;
  final int mood;

  const JournalUpdateRequested({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
  });

  @override
  List<Object?> get props => [id, title, content, mood];
}

class JournalDeleteRequested extends JournalEvent {
  final String id;

  const JournalDeleteRequested({required this.id});

  @override
  List<Object?> get props => [id];
}

class JournalAutoSaveRequested extends JournalEvent {
  final String? id;
  final String title;
  final String content;
  final int mood;

  const JournalAutoSaveRequested({
    this.id,
    required this.title,
    required this.content,
    required this.mood,
  });

  @override
  List<Object?> get props => [id, title, content, mood];
}
