import 'package:cureta/features/authentcation/veiw_model/forgot_password_view_model.dart';
import 'package:cureta/features/ocr/data/repo/ocr_repository.dart';
import 'package:cureta/features/profile/data/services/profile_service.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:cureta/features/authentcation/data/services/auth_service.dart';
import 'package:cureta/features/authentcation/data/repo/auth_repository.dart';
import 'package:cureta/features/authentcation/veiw_model/auth_view_model.dart';
import 'package:cureta/features/medical_records/data/services/medical_record_service.dart';
import 'package:cureta/features/medical_records/data/repo/medical_record_repository.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_form_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/add_record_step_four_cubit.dart';
import 'package:cureta/features/medical_records/veiw_model/create_record_cubit.dart';
import 'package:cureta/features/chat_bot/data/services/chat_service.dart';
import 'package:cureta/features/chat_bot/data/repo/chat_repository.dart';
import 'package:cureta/features/chat_bot/veiw_model/chat_cubit.dart';
import 'package:cureta/features/chat_bot/veiw_model/chat_sessions_cubit.dart';
import 'package:cureta/features/ocr/data/service/ocr_service.dart';
import 'package:cureta/features/ocr/view_model/ocr_cubit.dart';

import 'package:cureta/features/medicines/data/services/medicine_local_service.dart';
import 'package:cureta/features/medicines/data/services/medicine_service.dart';
import 'package:cureta/features/medicines/data/repo/medicine_repository.dart';
import 'package:cureta/features/medicines/veiw_model/add_medicine_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/user_medicines_cubit.dart';
import 'package:cureta/features/medicines/veiw_model/medicine_details_cubit.dart';

final getIt = GetIt.instance;

void setup() {
  // 🧱 Services
  getIt.registerSingleton<AuthService>(AuthService());
  getIt.registerSingleton<MedicalRecordService>(MedicalRecordService());
  getIt.registerSingleton<ProfileService>(ProfileService());

  // 📦 Repositories
  getIt.registerSingleton<AuthRepository>(
    AuthRepository(getIt.get<AuthService>()),
  );
  getIt.registerSingleton<MedicalRecordRepository>(
    MedicalRecordRepository(getIt.get<MedicalRecordService>()),
  );
  getIt.registerSingleton<ProfileRepository>(
    ProfileRepository(getIt.get<ProfileService>()),
  );

  // 🧠 Cubits
  getIt.registerFactory<AddRecordFormCubit>(() => AddRecordFormCubit());
  getIt.registerFactory<AddRecordStepFourCubit>(() => AddRecordStepFourCubit());
  getIt.registerFactory<CreateRecordCubit>(() => CreateRecordCubit());

  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(getIt.get<AuthRepository>()),
  );

  getIt.registerFactory<ForgotPasswordViewModel>(
    () => ForgotPasswordViewModel(getIt.get<AuthRepository>()),
  );

  // 🤖 Chat Bot
  getIt.registerSingleton<ChatService>(ChatService());
  getIt.registerSingleton<ChatRepository>(
    ChatRepository(getIt.get<ChatService>()),
  );
  getIt.registerFactory<ChatCubit>(() => ChatCubit());
  getIt.registerFactory<ChatSessionsCubit>(() => ChatSessionsCubit());

  // OCR
  getIt.registerSingleton<OcrService>(OcrService());
  getIt.registerSingleton<OcrRepository>(
    OcrRepository(getIt.get<OcrService>()),
  );
  getIt.registerFactory<OcrCubit>(
    () => OcrCubit(repository: getIt.get<OcrRepository>()),
  );

  // 💊 Medicine Services
  getIt.registerSingleton<MedicineLocalService>(MedicineLocalService());
  getIt.registerSingleton<MedicineService>(MedicineService());

  // 💊 Medicine Repository
  getIt.registerSingleton<MedicineRepository>(
    MedicineRepository(
      localService: getIt<MedicineLocalService>(),
      remoteService: getIt<MedicineService>(),
    ),
  );

  // 💊 Medicine Cubits
  // AddMedicineCubit is a factory so each flow session gets a fresh instance
  // managed by AddMedicineFlowWrapper (ShellRoute).
  getIt.registerFactory<AddMedicineCubit>(
    () => AddMedicineCubit(getIt.get<MedicineRepository>()),
  );

  // UserMedicinesCubit is a factory — each list screen manages its own instance.
  getIt.registerFactory<UserMedicinesCubit>(
    () => UserMedicinesCubit(getIt.get<MedicineRepository>()),
  );

  getIt.registerFactoryParam<MedicineDetailsCubit, String, void>(
    (medicineId, _) => MedicineDetailsCubit(
      getIt.get<MedicineRepository>(),
      medicineId: medicineId,
    ),
  );
}
