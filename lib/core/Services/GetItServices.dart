import 'package:cureta/features/authentcation/veiw_model/forgot_password_view_model.dart';
import 'package:cureta/features/home/data/repo/schedule_repo.dart';
import 'package:cureta/features/home/data/service/schedule_service.dart';
import 'package:cureta/features/home/view_model/home_schedule_cubit.dart';
import 'package:cureta/features/ocr/data/repo/ocr_repository.dart';
import 'package:cureta/features/profile/data/services/profile_service.dart';
import 'package:cureta/features/profile/data/repo/profile_repository.dart';
import 'package:cureta/features/qr/data/repo/qr_repo.dart';
import 'package:cureta/features/qr/data/services/qr_service.dart';
import 'package:cureta/features/qr/view_model/qr_categories_cubit.dart';
import 'package:cureta/features/qr/view_model/qr_generate_token_cubit.dart';
import 'package:cureta/features/settings/data/app_settings_notifier.dart';
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
import 'package:cureta/features/reports/data/repo/report_repo.dart';
import 'package:cureta/features/reports/data/services/report_service.dart';
import 'package:cureta/features/reports/veiw_model/report_history_cubit.dart';
import 'package:cureta/features/reports/veiw_model/report_setup_cubit.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
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
  getIt.registerFactory<AddMedicineCubit>(
    () => AddMedicineCubit(getIt.get<MedicineRepository>()),
  );

  getIt.registerFactory<UserMedicinesCubit>(
    () => UserMedicinesCubit(getIt.get<MedicineRepository>()),
  );

  getIt.registerFactoryParam<MedicineDetailsCubit, String, void>(
    (medicineId, _) => MedicineDetailsCubit(
      getIt.get<MedicineRepository>(),
      medicineId: medicineId,
    ),
  );

  // ⚙️ Settings
  getIt.registerSingleton<AppSettingsNotifier>(
    await AppSettingsNotifier.load(),
  );

  // Services
  getIt.registerSingleton<ScheduleService>(const ScheduleService());
  getIt.registerSingleton<ReportService>(ReportService());
  // Repositories
  getIt.registerSingleton<ScheduleRepository>(
    ScheduleRepository(getIt<ScheduleService>()),
  );
  getIt.registerSingleton<ReportRepo>(ReportRepo(getIt<ReportService>()));

  // Cubits
  getIt.registerFactory<HomeScheduleCubit>(
    () => HomeScheduleCubit(getIt<MedicineRepository>()),
  );
  // 📊 Report Cubits
  getIt.registerFactory<ReportHistoryCubit>(
    () => ReportHistoryCubit(getIt<ReportRepo>()),
  );
  getIt.registerFactory<ReportSetupCubit>(
    () => ReportSetupCubit(getIt<ReportRepo>(), getIt<ProfileRepository>()),
  );
  //QR
  getIt.registerSingleton<QrService>(QrService());
  getIt.registerSingleton<QrRepository>(QrRepository(getIt.get<QrService>()));
  getIt.registerFactory<QrCategoriesCubit>(
    () => QrCategoriesCubit(getIt.get<QrRepository>()),
  );
  getIt.registerFactory<QrGenerateTokenCubit>(
    () => QrGenerateTokenCubit(getIt.get<QrRepository>()),
  );
}
