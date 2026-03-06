import 'package:cureta/features/profile/view_model/profile_cubit.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AgeStep extends StatelessWidget {
  const AgeStep({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ProfileCubit>().state;
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: state.age - 1),
      itemExtent: 60,
      onSelectedItemChanged: (index) => context.read<ProfileCubit>().updateAge(index + 1),
      children: List.generate(100, (i) => Center(child: Text("${i + 1}"))),
    );
  }
}