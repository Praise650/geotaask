abstract class Routes {
  Routes._();

  static const SPLASH = Paths.SPLASH;

  static const ONBOARDING = "onboarding";
  static const LOGIN = "login";
  static const SIGNUP = "signup";

  static const HOME = "home";
  static const HOMEEXAMPLE = "home-example";
  static const PROFILE = "profile";
}

abstract class Paths {
  Paths._();
  // main Routes
  static const SPLASH = '/';

  static const ONBOARDING = '/${Routes.ONBOARDING}';
  static const LOGIN = '/${Routes.LOGIN}';
  static const SIGNUP = '/${Routes.SIGNUP}';

  static const HOME = "/${Routes.HOME}";
  static const HOMEEXAMPLE = "/${Routes.HOMEEXAMPLE}";
  static const PROFILE = "/${Routes.PROFILE}";
}
