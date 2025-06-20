import 'package:get/get.dart';

import '../modules/Acara/bindings/acara_binding.dart';
import '../modules/Acara/views/acara_view.dart';
import '../modules/Gerakan/bindings/gerakan_binding.dart';
import '../modules/Gerakan/views/gerakan_view.dart';
import '../modules/History/bindings/history_binding.dart';
import '../modules/History/views/history_view.dart';
import '../modules/Juara/bindings/juara_binding.dart';
import '../modules/Juara/views/juara_view.dart';
import '../modules/berita/bindings/berita_binding.dart';
import '../modules/berita/views/berita_view.dart';
import '../modules/camera/bindings/camera_binding.dart';
import '../modules/camera/views/camera_view.dart';
import '../modules/camera_backhand/bindings/camera_backhand_binding.dart';
import '../modules/camera_backhand/views/camera_backhand_view.dart';
import '../modules/chatdengankami/bindings/chatdengankami_binding.dart';
import '../modules/chatdengankami/views/chatdengankami_view.dart';
import '../modules/detail_backhand/bindings/detail_backhand_binding.dart';
import '../modules/detail_backhand/views/detail_backhand_view.dart';
import '../modules/detail_forehand/bindings/detail_forehand_binding.dart';
import '../modules/detail_forehand/views/detail_forehand_view.dart';
import '../modules/detail_serve/bindings/detail_serve_binding.dart';
import '../modules/detail_serve/views/detail_serve_view.dart';
import '../modules/detail_smash/bindings/detail_smash_binding.dart';
import '../modules/detail_smash/views/detail_smash_view.dart';
import '../modules/forgot_password/bindings/forgot_password_binding.dart';
import '../modules/forgot_password/views/forgot_password_view.dart';
import '../modules/grafik/bindings/grafik_binding.dart';
import '../modules/grafik/views/grafik_view.dart';
import '../modules/history_login/bindings/history_login_binding.dart';
import '../modules/history_login/views/history_login_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/materi/bindings/materi_binding.dart';
import '../modules/materi/views/materi_view.dart';
import '../modules/otp_register/bindings/otp_register_binding.dart';
import '../modules/otp_register/views/otp_register_view.dart';
import '../modules/pilihan/bindings/pilihan_binding.dart';
import '../modules/pilihan/views/pilihan_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/pusat_bantuan/bindings/pusat_bantuan_binding.dart';
import '../modules/pusat_bantuan/views/pusat_bantuan_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/syarat_ketentuan/bindings/syarat_ketentuan_binding.dart';
import '../modules/syarat_ketentuan/views/syarat_ketentuan_view.dart';
import '../modules/update_profile/bindings/update_profile_binding.dart';
import '../modules/update_profile/bindings/update_profile_binding.dart';
import '../modules/update_profile/views/update_profile_view.dart';
import '../modules/update_profile/views/update_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.PILIHAN;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.CAMERA,
      page: () => const CameraView(),
      binding: CameraBinding(),
    ),
    GetPage(
      name: _Paths.GRAFIK,
      page: () => const GrafikView(),
      binding: GrafikBinding(),
    ),
    GetPage(
      name: _Paths.MATERI,
      page: () => const MateriView(),
      binding: MateriBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.PILIHAN,
      page: () => const PilihanView(),
      binding: PilihanBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_PROFILE,
      page: () => const UpdateProfileView(),
      binding: UpdateProfileBinding(),
    ),
    GetPage(
      name: _Paths.BERITA,
      page: () => const BeritaView(),
      binding: BeritaBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY,
      page: () => const HistoryView(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: _Paths.ACARA,
      page: () => const AcaraView(),
      binding: AcaraBinding(),
    ),
    GetPage(
      name: _Paths.JUARA,
      page: () => const JuaraView(),
      binding: JuaraBinding(),
    ),
    GetPage(
      name: _Paths.GERAKAN,
      page: () => const GerakanView(),
      binding: GerakanBinding(),
    ),
    GetPage(
      name: _Paths.OTP_REGISTER,
      page: () => OtpRegisterView(),
      binding: OtpRegisterBinding(),
    ),
    GetPage(
      name: _Paths.SYARAT_KETENTUAN,
      page: () => const SyaratKetentuanView(),
      binding: SyaratKetentuanBinding(),
    ),
    GetPage(
      name: _Paths.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
    ),
    GetPage(
      name: _Paths.PUSAT_BANTUAN,
      page: () => const PusatBantuanView(),
      binding: PusatBantuanBinding(),
    ),
    GetPage(
      name: _Paths.CHATDENGANKAMI,
      page: () => const ChatdengankamiView(),
      binding: ChatdengankamiBinding(),
    ),
    GetPage(
      name: _Paths.HISTORY_LOGIN,
      page: () => const HistoryLoginView(),
      binding: HistoryLoginBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_FOREHAND,
      page: () => const DetailForehandView(),
      binding: DetailForehandBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_BACKHAND,
      page: () => const DetailBackhandView(),
      binding: DetailBackhandBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_SERVE,
      page: () => const DetailServeView(),
      binding: DetailServeBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_SMASH,
      page: () => const DetailSmashView(),
      binding: DetailSmashBinding(),
    ),
    GetPage(
      name: _Paths.CAMERA_BACKHAND,
      page: () => const CameraBackhandView(),
      binding: CameraBackhandBinding(),
    ),
  ];
}
