# Bugfix Requirements Document: Flutter Const Widgets Compilation Error

## Introduction

The Flutter application fails to compile for the web platform with "Not a constant expression" errors in `home_screen.dart`. Custom widgets (`CurrentMissionCard`, `YourPathSection`, `FeaturedCourseCard`, `PopularSkillsSection`) are instantiated inside a const list used by `SliverChildListDelegate.fixed()`. Since these widgets lack const constructors, they cannot be used in const contexts, causing compilation to fail. This fix requires adding const constructors to all custom widgets used in const lists.

## Bug Analysis

### Current Behavior (Defect)

1.1 WHEN custom widgets without const constructors are instantiated inside `const [...]` list THEN the Flutter compiler throws "Not a constant expression" error
1.2 WHEN `flutter run -d chrome` is executed with widgets lacking const constructors in const context THEN the build fails before reaching runtime

### Expected Behavior (Correct)

2.1 WHEN custom widgets with const constructors are instantiated inside `const [...]` list THEN the Flutter compiler accepts the declarations without error
2.2 WHEN `flutter run -d chrome` is executed with const constructors properly defined THEN the build succeeds and the application runs

### Unchanged Behavior (Regression Prevention)

3.1 WHEN widgets are instantiated outside of const contexts with or without const constructors THEN the behavior SHALL CONTINUE TO be identical
3.2 WHEN widgets receive runtime parameters that are non-constant THEN the system SHALL CONTINUE TO handle these correctly regardless of const constructor presence
3.3 WHEN the application renders widgets on the home screen THEN the visual output and functionality SHALL CONTINUE TO remain unchanged
