import 'package:cureta/features/profile/view_model/profile_cubit.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AgeStep extends StatefulWidget {
  const AgeStep({super.key});

  @override
  State<AgeStep> createState() => _AgeStepState();
}

class _AgeStepState extends State<AgeStep> {
  late final FixedExtentScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // Seed the picker once from the current age. The picker is the source of
    // truth while scrolling, so we must NOT recreate the controller on every
    // emit (that made it fight the user's scroll and rebuild each tick).
    final age = context.read<ProfileCubit>().state.age;
    _scrollController = FixedExtentScrollController(initialItem: age - 1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPicker(
      scrollController: _scrollController,
      itemExtent: 60,
      onSelectedItemChanged: (index) =>
          context.read<ProfileCubit>().updateAge(index + 1),
      children: List.generate(100, (i) => Center(child: Text("${i + 1}"))),
    );
  }
}