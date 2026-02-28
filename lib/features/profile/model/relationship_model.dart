import 'package:cureta/core/constants/app_icons.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class RelationshipModel {
  final String name;
  final String iconPath;

  RelationshipModel({required this.name, required this.iconPath});
}

final List<RelationshipModel> relationshipOptions = [
  RelationshipModel(
    name: AppLocalizations.profilesRelationSon,
    iconPath: AppIcons.son,
  ),
  RelationshipModel(
    name: AppLocalizations.profilesRelationDaughter,
    iconPath: AppIcons.daughter,
  ),
  RelationshipModel(
    name: AppLocalizations.profilesRelationMother,
    iconPath: AppIcons.woman,
  ),
  RelationshipModel(
    name: AppLocalizations.profilesRelationFather,
    iconPath: AppIcons.man,
  ),
  RelationshipModel(
    name: AppLocalizations.profilesRelationSpouse,
    iconPath: AppIcons.favorite,
  ),
  RelationshipModel(
    name: AppLocalizations.profilesRelationOther,
    iconPath: AppIcons.more_horiz,
  ),
];
