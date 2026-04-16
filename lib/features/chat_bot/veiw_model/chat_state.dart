import 'package:equatable/equatable.dart';

class ChatState extends Equatable {
  final bool isReplyLoading;
  final bool isHistoryLoading;
  final bool isEmpty;

  const ChatState({
    this.isReplyLoading = false,
    this.isHistoryLoading = false,
    this.isEmpty = true,
  });

  bool get isLoading => isReplyLoading || isHistoryLoading;

  ChatState copyWith({
    bool? isReplyLoading,
    bool? isHistoryLoading,
    bool? isEmpty,
  }) {
    return ChatState(
      isReplyLoading: isReplyLoading ?? this.isReplyLoading,
      isHistoryLoading: isHistoryLoading ?? this.isHistoryLoading,
      isEmpty: isEmpty ?? this.isEmpty,
    );
  }

  @override
  List<Object?> get props => [isReplyLoading, isHistoryLoading, isEmpty];
}
