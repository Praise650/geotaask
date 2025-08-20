abstract class Routes {
  Routes._();

  static const SPLASH = Paths.SPLASH;

  static const ONBOARDING = "onboarding";

  static const THEMEEXAMPLE = "theme-example";
  static const THEMEEXAMPLESCREEN = "theme-example-screen";

  static const HOME = "home";
  static const HISTORY = "history";
  static const PROFILE = "profile";
}

abstract class Paths {
  Paths._();
  // main Routes
  static const SPLASH = '/';

  static const ONBOARDING = '/${Routes.ONBOARDING}';

  static const THEMEEXAMPLE = '/${Routes.THEMEEXAMPLE}';
  static const THEMEEXAMPLESCREEN = '/${Routes.THEMEEXAMPLESCREEN}';

  static const HOME = "/${Routes.HOME}";
  static const HISTORY = "/${Routes.HISTORY}";
  static const PROFILE = "/${Routes.PROFILE}";
}
