import 'package:cureta/core/Services/GetItServices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'chat_screen_body.dart';
import '../veiw_model/chat_cubit.dart';
import '../veiw_model/chat_sessions_cubit.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatCubit>(create: (_) => getIt.get<ChatCubit>()),
        BlocProvider<ChatSessionsCubit>(
          create: (_) => getIt.get<ChatSessionsCubit>(),
        ),
      ],
      child: const ChatScreenBody(),
    );
  }
}
