import 'package:equatable/equatable.dart';

class ChatState extends Equatable {
  final bool isLoading;
  final bool isEmpty;

  const ChatState({this.isLoading = false, this.isEmpty = true});

  ChatState copyWith({bool? isLoading, bool? isEmpty}) {
    return ChatState(
      isLoading: isLoading ?? this.isLoading,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }

  @override
  List<Object?> get props => [isLoading, isEmpty];
}
