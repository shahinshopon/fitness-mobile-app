import 'package:fitness/taste/controllers/question_paper/question_paper_controller.dart';
import 'package:fitness/taste/controllers/quiz_controller.dart';
import 'package:fitness/taste/data_uploader_screen.dart';
import 'package:fitness/taste/screens/home_screen.dart';
import 'package:fitness/taste/screens/quiz_screen.dart';
import 'package:fitness/ui/views/auth/forgot_password.dart';
import 'package:fitness/ui/views/auth/login.dart';
import 'package:fitness/ui/views/auth/registration.dart';
import 'package:fitness/ui/views/home/bottom_nav_controller.dart';
import 'package:fitness/ui/views/home/pages/bottom_media.dart';
import 'package:fitness/ui/views/home/pages/comment/comments.dart';
import 'package:fitness/ui/views/home/pages/favourites/favourites.dart';
import 'package:fitness/ui/views/onboarding/onboarding_screen.dart';
import 'package:fitness/ui/views/splash/splash.dart';
import 'package:get/get.dart';

const String splash = '/splash';
const String onboarding = '/onbording';
const String login = '/login';
const String registration = '/registration';
const String forgotPassword = '/forgotPassword';
const String bottomNavController = '/bottomNavController';
const String subCategory = '/subCategory';
const String detailsScreen = '/detailsScreen';
const String commentsScreen = '/commentsScreen';
const String favouritesScreen = '/favouritesScreen';
// const String tasteScreen = '/tasteScreen';
const String homeScreen = '/homeScreen';
const String quizScreen = '/quizScreen';
const String resultScreen = '/resultScreen';

List<GetPage> getPages = [
  GetPage(
    name: splash,
    page: () => Splash(),
  ),
  GetPage(
    name: onboarding,
    page: () => OnboardingScreen(),
  ),
  GetPage(
    name: login,
    page: () => Login(),
  ),
  GetPage(
    name: registration,
    page: () => Registration(),
  ),
  GetPage(
    name: forgotPassword,
    page: () => ForgotPassword(),
  ),
  GetPage(
    name: bottomNavController,
    page: () => BottomNavController(),
  ),
  GetPage(
    name: subCategory,
    page: () => SubCategory(
      data: Get.arguments,
    ),
  ),
  GetPage(
    name: detailsScreen,
    page: () => DetailsScreen(
      detailsData: Get.arguments,
    ),
  ),
  GetPage(
    name: commentsScreen,
    page: () => CommentsScreen(
      commentsData: Get.arguments,
    ),
  ),
  GetPage(
    name: favouritesScreen,
    page: () => FavouritesScreen(),
  ),
  // GetPage(
  //   name: tasteScreen,
  //   page: () => DataUploaderScreen(),
  // ),
  GetPage(
      name: homeScreen,
      page: () => HomeScreen(),
      binding: BindingsBuilder(() {
        Get.put(QuestionPaperController());
      })),
   GetPage(
            page: () => QuizeScreen(),
            name: quizScreen,
            binding: BindingsBuilder(() {
              Get.put<QuizController>( QuizController());
            })),
];
