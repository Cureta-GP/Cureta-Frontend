import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cureta/core/localization/app_localizations.dart';
import 'package:cureta/core/theme/theme_extensions.dart';
import 'package:cureta/features/profile/view_model/profile_cubit.dart';
import 'package:cureta/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameInputStep extends StatefulWidget {
  const NameInputStep({super.key});

  @override
  State<NameInputStep> createState() => _NameInputStepState();
}

class _NameInputStepState extends State<NameInputStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<ProfileCubit>();
    _controller = TextEditingController(text: cubit.state.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      context.read<ProfileCubit>().updateImage(pickedFile.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: EdgeInsets.all(context.spacing.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      children: [
                        BlocBuilder<ProfileCubit, dynamic>(
                          builder: (context, state) {
                            final imagePath = context.read<ProfileCubit>().state.imagePath;
                            final imageUrl = context.read<ProfileCubit>().state.imageUrl;
                            
                            ImageProvider? imageProvider;
                            if (imagePath != null) {
                              imageProvider = FileImage(File(imagePath));
                            } else if (imageUrl != null) {
                              imageProvider = CachedNetworkImageProvider(imageUrl);
                            }

                            return CircleAvatar(
                              radius: 60,
                              backgroundColor: context.colors.primary.withOpacity(0.1),
                              backgroundImage: imageProvider,
                              child: imageProvider == null
                                  ? Icon(
                                      Icons.person,
                                      size: 60,
                                      color: context.colors.primary,
                                    )
                                  : null,
                            );
                          },
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: context.colors.primary,
                            radius: 18,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.spacing.xl),
                  CustomTextField(
                    hint: AppLocalizations.profilesNameHint,
                    onChanged: (val) =>
                        context.read<ProfileCubit>().updateName(val),
                    label: '',
                    controller: _controller,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
