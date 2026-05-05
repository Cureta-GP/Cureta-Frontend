import 'package:cureta/features/ocr/data/repo/ocr_repository.dart';
import 'package:cureta/features/ocr/view_model/ocr_cubit.dart';
import 'package:cureta/features/ocr/view_model/ocr_state.dart';
import 'package:flutter/material.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/utils/navigation_helper.dart';
import 'package:cureta/core/config/routing/app_routes.dart';
import 'package:cureta/core/Services/GetItServices.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cureta/features/ocr/data/models/ocr_medicine_match.dart';

class ScannedMedicinesScreen extends StatelessWidget {
  final List<OcrMedicineMatch> medicines;

  const ScannedMedicinesScreen({
    super.key,
    required this.medicines,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return BlocProvider(
      create: (context) => OcrCubit(repository: getIt.get<OcrRepository>()),

      child: Scaffold(
        appBar: AppBar(title: Text(AppLocalizations.scannedMedicinesTitle)),

        body: BlocListener<OcrCubit, OcrState>(
          listener: (context, state) {
            if (state is OcrConfirmSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.response.message ?? '')),
              );
              Nav.pushNamed(context, AppRoutes.home);
            } else if (state is OcrFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: BlocBuilder<OcrCubit, OcrState>(
            builder: (context, state) {
              if (state is OcrLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              List meds = medicines;

              return Column(
                children: [
                  Expanded(
                    child: meds.isEmpty
                        ? Center(
                            child: Text(
                              AppLocalizations.scannedMedicinesNoResults,
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.all(spacing.lg),
                            itemCount: meds.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(height: spacing.sm),
                            itemBuilder: (context, index) {
                              final m = meds[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    context.radius.lg,
                                  ),
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: context.colors.accentBlue
                                        .withOpacity(0.2),
                                    child: Icon(
                                      Icons.medication,
                                      color: context.colors.primary,
                                    ),
                                  ),
                                  title: Text(
                                    (m.corrected?.isNotEmpty ?? false)
                                        ? m.corrected!
                                        : m.original,
                                    style: context.typography.label,
                                  ),
                                  subtitle: Text(
                                    AppLocalizations.scannedMedicinesTablet,
                                  ),
                                  trailing: const Icon(
                                    Icons.edit_outlined,
                                    size: 20,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(spacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: meds.isEmpty
                                ? null
                                : () async {
                                    final names = meds
                                        .map(
                                          (e) =>
                                              ((e.corrected?.isNotEmpty ??
                                                          false)
                                                      ? e.corrected
                                                      : e.original)
                                                  as String,
                                        )
                                        .toList();
                                    try {
                                      final profileRepo = getIt
                                          .get<ProfileRepository>();
                                      final profileId = await profileRepo
                                          .getResolvedSelectedProfileId();
                                      if (profileId == null ||
                                          profileId.isEmpty) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              AppLocalizations
                                                  .selectProfileAddProfile,
                                            ),
                                          ),
                                        );
                                        return;
                                      }

                                      context.read<OcrCubit>().confirmMedicines(
                                        medicines: names,
                                        profileId: profileId,
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(e.toString())),
                                      );
                                    }
                                  },
                            child: Text(
                              AppLocalizations.scannedMedicinesConfirm,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Nav.pushNamed(
                            context,
                            AppRoutes.scanPrescription,
                          ),
                          child: Text(AppLocalizations.scannedMedicinesRescan),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
