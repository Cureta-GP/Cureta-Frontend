import 'package:flutter/material.dart';
import 'package:cureta/features/medicines/veiw/user_medicines_veiw.dart';

/// Wrapper used by the bottom navigation [IndexedStack].
/// Simply delegates to [UserMedicinesVeiw] which creates its own Cubit.
class MedicinesMainView extends StatelessWidget {
  const MedicinesMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return const UserMedicinesVeiw();
  }
}
