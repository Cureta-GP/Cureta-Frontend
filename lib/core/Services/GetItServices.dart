import 'package:cureta/features/profile/data/services/profile_service.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/features/profile/view_model/profile_cubit.dart';
import 'package:get_it/get_it.dart';
import 'package:cureta/features/authentcation/data/services/auth_service.dart';
import 'package:cureta/features/authentcation/data/repo/auth_repository.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_view_model.dart';
import 'package:cureta/features/medical_records/data/services/medical_record_service.dart';
import 'package:cureta/features/medical_records/data/repo/medical_record_repository.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_form_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/create_record_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  // 🧱 Services
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<MedicalRecordService>(MedicalRecordService());
  getIt.registerSingleton<ProfileService>(ProfileService()); // ✅

  // 📦 Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(getIt.get<AuthService>()),
  );
  getIt.registerSingleton<MedicalRecordRepository>(
    MedicalRecordRepository(getIt.get<MedicalRecordService>()),
  );
  getIt.registerSingleton<ProfileRepository>(               // ✅
    ProfileRepository(getIt.get<ProfileService>()),
  );

  // 🧠 Cubits
  getIt.registerSingleton<AddRecordFormCubit>(AddRecordFormCubit());
  getIt.registerSingleton<AddRecordStepFourCubit>(AddRecordStepFourCubit());
  getIt.registerSingleton<CreateRecordCubit>(CreateRecordCubit());

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt.get<AuthRepository>()),
  );

  
}