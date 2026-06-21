import 'package:cureta/core/constants/app_icons.dart';
import 'package:cureta/core/localization/app_localizations.dart';

class RelationshipModel {
  final String name;
  final String apiValue;
  final String iconPath;

  RelationshipModel({
    required this.name,
    required this.apiValue,
    required this.iconPath,
  });
}

List<RelationshipModel> get relationshipOptions => [
  RelationshipModel(
    name: AppLocalizations.profilesRelationSon,
    apiValue: 'Son',
    iconPath: AppIcons.son,
  ),
  RelationshipModel(
    name: AppLocalizations.profilesRelationDaughter,
    apiValue: 'Daughter',
    iconPath: AppIcons.daughter,
  ),
  RelationshipModel(
    name: AppLocalizations.profilesRelationMother,
    apiValue: 'Mother',
    iconPath: AppIcons.woman,
  ),
  RelationshipModel(
    name: AppLocalizations.profilesRelationFather,
    apiValue: 'Father',
    iconPath: AppIcons.man,
  ),
  RelationshipModel(
    name: AppLocalizations.profilesRelationSpouse,
    apiValue: 'Spouse',
    iconPath: AppIcons.favorite,
  ),
  RelationshipModel(
    name: AppLocalizations.profilesRelationOther,
    apiValue: 'Other',
    iconPath: AppIcons.more_horiz,
  ),
];

List<RelationshipModel> get familyProfiles => [
  RelationshipModel(
    name: AppLocalizations.profilesRelationSon,
    apiValue: 'Son',
    iconPath: AppIcons.son,
  ),
  RelationshipModel(
    name: AppLocalizations.profilesRelationDaughter,
    apiValue: 'Daughter',
    iconPath: AppIcons.daughter,
  ),
  RelationshipModel(
    name: AppLocalizations.profilesRelationMother,
    apiValue: 'Mother',
    iconPath: AppIcons.woman,
  ),
];
