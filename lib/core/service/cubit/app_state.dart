part of 'app_cubit.dart';

@immutable
sealed class AppState {}

final class AppInitial extends AppState {}

final class ChangeIndex extends AppState {}

final class GetCurrentLocationLoading extends AppState {}

final class GetCurrentLocationSuccess extends AppState {}

final class ServerError extends AppState {}

final class Timeoutt extends AppState {}

final class GetIntroLoading extends AppState {}

final class ChangeCount extends AppState {}

final class GetIntroSuccess extends AppState {}

final class ChangeBottomNav extends AppState {}

final class IsSecureIcon extends AppState {}

final class GetIntroFailure extends AppState {
  final String error;

  GetIntroFailure({required this.error});
}

final class ChooseImageSuccess extends AppState {}

final class RemoveImageSuccess extends AppState {}

final class UploadImagesLoading extends AppState {}

final class UploadImagesSuccess extends AppState {}

final class UploadImagesFailure extends AppState {}

final class GetDataLoading extends AppState {}

final class GetDataSuccess extends AppState {}

final class GetDataFailure extends AppState {
  final String error;

  GetDataFailure({required this.error});
}

final class GetUserDataLoading extends AppState {}

final class GetUserDataSuccess extends AppState {}

final class GetUserDataFailure extends AppState {
  final String error;

  GetUserDataFailure({required this.error});
}

final class UpdateUserDataLoading extends AppState {}

final class UpdateUserDataSuccess extends AppState {
  final String message;

  UpdateUserDataSuccess({required this.message});
}

final class UpdateUserDataFailure extends AppState {
  final String error;

  UpdateUserDataFailure({required this.error});
}

final class GetStaticPagesLoading extends AppState {}

final class GetStaticPagesSuccess extends AppState {}

final class GetStaticPagesFailure extends AppState {
  final String error;

  GetStaticPagesFailure({required this.error});
}

final class ContactUsLoading extends AppState {}

final class ContactUsSuccess extends AppState {
  final String message;

  ContactUsSuccess({required this.message});
}

final class ContactUsFailure extends AppState {
  final String error;

  ContactUsFailure({required this.error});
}

final class ShowNotificationsLoading extends AppState {}

final class ShowNotificationsSuccess extends AppState {}

final class ShowNotificationsFailure extends AppState {
  final String error;

  ShowNotificationsFailure({required this.error});
}

final class DeleteNotificationLoading extends AppState {}

final class DeleteNotificationSuccess extends AppState {
  final String message;

  DeleteNotificationSuccess({required this.message});
}

final class DeleteNotificationFailure extends AppState {
  final String error;

  DeleteNotificationFailure({required this.error});
}

final class GetHomeDataLoading extends AppState {}

final class GetHomeDataSuccess extends AppState {}

final class GetHomeDataFailure extends AppState {
  final String error;

  GetHomeDataFailure({required this.error});
}

final class GetAllProvidersLoading extends AppState {}

final class GetAllProvidersSuccess extends AppState {}

final class GetAllProvidersFailure extends AppState {
  final String error;

  GetAllProvidersFailure({required this.error});
}

final class GetProviderDetailsLoading extends AppState {}

final class GetProviderDetailsSuccess extends AppState {}

final class GetProviderDetailsFailure extends AppState {
  final String error;

  GetProviderDetailsFailure({required this.error});
}

final class GetAllCartsLoading extends AppState {}

final class GetAllCartsSuccess extends AppState {}

final class GetAllCartsFailure extends AppState {
  final String error;

  GetAllCartsFailure({required this.error});
}

final class UpdateCartLoading extends AppState {}

final class UpdateCartSuccess extends AppState {
  final String message;

  UpdateCartSuccess({required this.message});
}

final class UpdateCartFailure extends AppState {
  final String error;

  UpdateCartFailure({required this.error});
}

final class ChangeIndexSuccess extends AppState {}

final class DeleteCartLoading extends AppState {}

final class DeleteCartSuccess extends AppState {
  final String message;

  DeleteCartSuccess({required this.message});
}

final class DeleteCartFailure extends AppState {
  final String error;

  DeleteCartFailure({required this.error});
}

final class GetServiceDetailsLoading extends AppState {}

final class GetServiceDetailsSuccess extends AppState {}

final class GetServiceDetailsFailure extends AppState {
  final String error;

  GetServiceDetailsFailure({required this.error});
}

final class AddToCartLoading extends AppState {
  final String source;

  AddToCartLoading({required this.source});
}

final class AddToCartSuccess extends AppState {
  final String message;
  final String source;
  AddToCartSuccess({required this.message, required this.source});
}

final class AddToCartFailure extends AppState {
  final String error;
  final String source;
  AddToCartFailure({required this.error, required this.source});
}

final class AddCommentLoading extends AppState {}

final class AddCommentSuccess extends AppState {
  final String message;

  AddCommentSuccess({required this.message});
}

final class AddCommentFailure extends AppState {
  final String error;

  AddCommentFailure({required this.error});
}

final class AllOrdersLoading extends AppState {}

final class AllOrdersSuccess extends AppState {}

final class AllOrdersFailure extends AppState {
  final String error;

  AllOrdersFailure({required this.error});
}

final class ShowOrdersLoading extends AppState {}

final class ShowOrdersSuccess extends AppState {}

final class ShowOrdersFailure extends AppState {
  final String error;

  ShowOrdersFailure({required this.error});
}

final class AddFavoriteLoading extends AppState {}

final class AddFavoriteSuccess extends AppState {
  final String message;

  AddFavoriteSuccess({required this.message});
}

final class AddFavoriteFailure extends AppState {
  final String error;

  AddFavoriteFailure({required this.error});
}

final class StoreOrderLoading extends AppState {}

final class StoreOrderSuccess extends AppState {
  final String message;

  StoreOrderSuccess({required this.message});
}

final class StoreOrderFailure extends AppState {
  final String error;

  StoreOrderFailure({required this.error});
}

final class StoreAddressLoading extends AppState {}

final class StoreAddressSuccess extends AppState {
  final String message;

  StoreAddressSuccess({required this.message});
}

final class StoreAddressFailure extends AppState {
  final String error;

  StoreAddressFailure({required this.error});
}

final class GetAddressLoading extends AppState {}

final class GetAddressSuccess extends AppState {}

final class GetAddressFailure extends AppState {
  final String error;

  GetAddressFailure({required this.error});
}

final class DeleteAddressLoading extends AppState {}

final class DeleteAddressSuccess extends AppState {
  final String message;

  DeleteAddressSuccess({required this.message});
}

final class DeleteAddressFailure extends AppState {
  final String error;

  DeleteAddressFailure({required this.error});
}

final class UpdateAddressLoading extends AppState {}

final class UpdateAddressSuccess extends AppState {
  final String message;

  UpdateAddressSuccess({required this.message});
}

final class UpdateAddressFailure extends AppState {
  final String error;

  UpdateAddressFailure({required this.error});
}

final class ShowAddressLoading extends AppState {}

final class ShowAddressSuccess extends AppState {}

final class ShowAddressFailure extends AppState {
  final String error;

  ShowAddressFailure({required this.error});
}

final class GetSearchLoading extends AppState {}

final class GetSearchSuccess extends AppState {}

final class GetSearchFailure extends AppState {
  final String error;

  GetSearchFailure({required this.error});
}

final class StoreOrderServiceLoading extends AppState {}

final class StoreOrderServiceSuccess extends AppState {
  final String message;

  StoreOrderServiceSuccess({required this.message});
}

final class StoreOrderServiceFailure extends AppState {
  final String error;

  StoreOrderServiceFailure({required this.error});
}

final class GetFavoriteLoading extends AppState {}

final class GetFavoriteSuccess extends AppState {}

final class GetFavoriteFailure extends AppState {
  final String error;

  GetFavoriteFailure({required this.error});
}

final class AllRoomsLoading extends AppState {}

final class AllRoomsSuccess extends AppState {}

final class AllRoomsFailure extends AppState {
  final String error;

  AllRoomsFailure({required this.error});
}

final class GetRoomChatLoading extends AppState {}

final class GetRoomChatSuccess extends AppState {}

final class GetRoomChatFailure extends AppState {
  final String error;

  GetRoomChatFailure({required this.error});
}

final class SendMessageLoading extends AppState {}

final class SendMessageSuccess extends AppState {
  final String message;

  SendMessageSuccess({required this.message});
}

final class SendMessageFailure extends AppState {
  final String error;

  SendMessageFailure({required this.error});
}

final class CheckPromoCodeLoading extends AppState {}

final class CheckPromoCodeSuccess extends AppState {
  final String message;

  CheckPromoCodeSuccess({required this.message});
}

final class CheckPromoCodeFailure extends AppState {
  final String error;

  CheckPromoCodeFailure({required this.error});
}

final class UserNotificationLoading extends AppState {}

final class UserNotificationSuccess extends AppState {}

final class UserNotificationFailure extends AppState {
  final String error;

  UserNotificationFailure({required this.error});
}

final class UpdateLocationLoading extends AppState {}

final class UpdateLocationSuccess extends AppState {
  final String message;

  UpdateLocationSuccess({required this.message});
}

final class UpdateLocationFailure extends AppState {
  final String error;

  UpdateLocationFailure({required this.error});
}

final class ProviderOrdersLoading extends AppState {}

final class ProviderOrdersSuccess extends AppState {}

final class ProviderOrdersFailure extends AppState {
  final String error;

  ProviderOrdersFailure({required this.error});
}

final class UpdateOrderStatusLoading extends AppState {}

final class UpdateOrderStatusSuccess extends AppState {
  final String message;

  UpdateOrderStatusSuccess({required this.message});
}

final class UpdateOrderStatusFailure extends AppState {
  final String error;

  UpdateOrderStatusFailure({required this.error});
}

final class UpdateCurrentStepSuccess extends AppState {}

final class NoInternetConnection extends AppState {}

final class ChoosecarImageSuccess extends AppState {}

final class RemovecarImageSuccess extends AppState {}

final class ChooseLicenseImageSuccess extends AppState {}

final class RemoveLicenseImageSuccess extends AppState {}

final class ChooseIdImageSuccess extends AppState {}

final class RemoveIdImageSuccess extends AppState {}

final class StoreOrderPackageLoading extends AppState {}

final class StoreOrderPackageSuccess extends AppState {
  final String message;

  StoreOrderPackageSuccess({required this.message});
}

final class StoreOrderPackageFailure extends AppState {
  final String error;

  StoreOrderPackageFailure({required this.error});
}


final class GetServicesLoading extends AppState {}

final class GetServicesSuccess extends AppState {}

final class GetServicesFailure extends AppState {
  final String error;

  GetServicesFailure({required this.error});
}