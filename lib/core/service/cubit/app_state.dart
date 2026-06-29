part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

/// Emitted after any data mutation (add/update/delete) so every BlocBuilder
/// listening to wallet data rebuilds.
final class WalletUpdated extends AppState {}

final class BottomNavChanged extends AppState {}

final class ThemeChanged extends AppState {}

final class LocaleChanged extends AppState {}
