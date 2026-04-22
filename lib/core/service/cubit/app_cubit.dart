import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../gen/fonts.gen.dart';
import '../../../generated/locale_keys.g.dart';
import '../../cache/cache_helper.dart';
import '../../constants/colors.dart';
import '../../constants/contsants.dart';
part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(BuildContext context) =>
      BlocProvider.of<AppCubit>(context);


  // void changeProvbottomNavIndex(int index) async {
  //   bottomProviderNavIndex = index;
  //   emit(ChangeBottomNav());
  // }

  double? lat = 0;
  double? lng = 0;
  String? address;
  void changeAddress({required String newAddress}) {
    address = newAddress;
    emit(ChangeIndex());
  }

  int paymentIndex = -1;
  void changePaymentIndex({required int index}) {
    paymentIndex = index;
    emit(ChangeIndex());
  }

  int sathaIndex = -1;
  void changeSathaIndex({required int index}) {
    sathaIndex = index;
    CacheHelper.saveData(key: "sathaIndex", value: index);
    emit(ChangeIndex());
  }

  int carRecovery = -1;
  void changeCarRecovery({required int index}) {
    carRecovery = index;
    CacheHelper.saveData(key: "carRecovery", value: index);
    emit(ChangeIndex());
  }

  List<File> carImage = [];
  Future<void> getCarImage(BuildContext context) async {
    final picker = ImagePicker();
    final int? pickedOption = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secondray,
          title: Text(
            LocaleKeys.select_image_source.tr(),
            style: const TextStyle(
              color: AppColors.primary,
              fontFamily: FontFamily.bahijJannaBold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () => Navigator.pop(context, 1),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () => Navigator.pop(context, 2),
              ),
            ],
          ),
        );
      },
    );

    if (pickedOption == null) return;

    XFile? pickedImage;

    if (pickedOption == 1) {
      pickedImage = await picker.pickImage(source: ImageSource.camera);
    } else if (pickedOption == 2) {
      final pickedImages = await picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        pickedImage = pickedImages.first;
      }
    }

    if (pickedImage != null) {
      carImage = [File(pickedImage.path)];
      emit(ChoosecarImageSuccess());
    }
  }

  void removeCarImage() {
    carImage.clear();
    emit(RemovecarImageSuccess());
  }

  List<File> licenseImage = [];
  Future<void> getLicenseImage(BuildContext context) async {
    final picker = ImagePicker();
    final int? pickedOption = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secondray,
          title: Text(
            LocaleKeys.select_image_source.tr(),
            style: const TextStyle(
              color: AppColors.primary,
              fontFamily: FontFamily.bahijJannaBold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () => Navigator.pop(context, 1),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () => Navigator.pop(context, 2),
              ),
            ],
          ),
        );
      },
    );

    if (pickedOption == null) return;

    XFile? pickedImage;

    if (pickedOption == 1) {
      pickedImage = await picker.pickImage(source: ImageSource.camera);
    } else if (pickedOption == 2) {
      final pickedImages = await picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        pickedImage = pickedImages.first;
      }
    }

    if (pickedImage != null) {
      licenseImage = [File(pickedImage.path)];
      emit(ChooseLicenseImageSuccess());
    }
  }

  void removeLicenseImage() {
    licenseImage.clear();
    emit(RemoveLicenseImageSuccess());
  }

  List<File> idImage = [];
  Future<void> getIdImage(BuildContext context) async {
    final picker = ImagePicker();
    final int? pickedOption = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secondray,
          title: Text(
            LocaleKeys.select_image_source.tr(),
            style: const TextStyle(
              color: AppColors.primary,
              fontFamily: FontFamily.bahijJannaBold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: () => Navigator.pop(context, 1),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: () => Navigator.pop(context, 2),
              ),
            ],
          ),
        );
      },
    );

    if (pickedOption == null) return;

    XFile? pickedImage;

    if (pickedOption == 1) {
      pickedImage = await picker.pickImage(source: ImageSource.camera);
    } else if (pickedOption == 2) {
      final pickedImages = await picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        pickedImage = pickedImages.first;
      }
    }

    if (pickedImage != null) {
      idImage = [File(pickedImage.path)];
      emit(ChooseIdImageSuccess());
    }
  }

  void removeIdImage() {
    idImage.clear();
    emit(RemoveIdImageSuccess());
  }

  int paymentlocatIndex = -1;
  void changePaymentlocatIndex({required int index}) {
    paymentlocatIndex = index;
    emit(ChangeIndex());
  }

  int shipIndex = -1;
  void changeShipIndex({required int index}) {
    shipIndex = index;
    emit(ChangeIndex());
  }

  int count = 1;
  void increseCount() {
    count++;
    emit(ChangeCount());
  }

  void decreseCount() {
    if (count > 0) {
      count--;
    }
    emit(ChangeCount());
  }

  bool hasCertificate = false;
  void changeCertificate() {
    hasCertificate = !hasCertificate;
    emit(ChangeIndex());
  }

  bool isSecureLogIn = true;
  void isSecureLogInIcon(isSecuree) {
    isSecureLogIn = isSecuree;
    emit(IsSecureIcon());
  }

  // void changebottomNavIndex(index) async {
  //   bottomNavIndex = index;
  //   emit(ChangeBottomNav());
  // }

  int changeLangIndex = 0;
  void changeLangIndexs({required int index}) {
    changeLangIndex = index;
    emit(ChangeIndex());
  }

  int changeTypeIndex = 0;
  void changeTypeIndexs({required int index}) {
    changeTypeIndex = index;
    emit(ChangeIndex());
  }

  int changeIndex = 0;
  void changeIndexs({required int index}) {
    changeIndex = index;
    emit(ChangeIndex());
  }

  int changeFavIndex = 0;
  void changeFavIndexs({required int index}) {
    changeFavIndex = index;
    emit(ChangeIndex());
  }

  int changeTermsIndex = -1;
  void changeTermsIndexs({required int index}) {
    changeTermsIndex = index;

    emit(ChangeIndex());
  }

  int changeTimeIndex = -1;
  void changeTimeIndexs({required int index}) {
    changeTimeIndex = index;

    emit(ChangeIndex());
  }

  int changeDayIndex = -1;
  void changeDayIndexs({required int index}) {
    changeDayIndex = index;

    emit(ChangeIndex());
  }

  List<File> trukImage = [];
  Future<void> getTrukImage(BuildContext context) async {
    final picker = ImagePicker();
    final int? pickedOption = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(LocaleKeys.select_image_source.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () => Navigator.pop(context, 1),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(
                  "Gallery",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () => Navigator.pop(context, 2),
              ),
            ],
          ),
        );
      },
    );

    if (pickedOption == null) return;

    final List<File> newImages = [];

    if (pickedOption == 1) {
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        newImages.add(File(pickedImage.path));
      }
    } else if (pickedOption == 2) {
      final pickedImages = await picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        newImages.addAll(pickedImages.map((img) => File(img.path)));
      }
    }

    if (newImages.isNotEmpty) {
      trukImage.addAll(newImages); // ✅ أضفهم بدل ما تستبدلهم
      emit(ChooseImageSuccess());
    }
  }

  void removeTrukImage(int index) {
    trukImage.removeAt(index);
    emit(ChooseImageSuccess());
  }

  List<File> trukDeleveryImage = [];
  Future<void> getTrukDeleveryImage(BuildContext context) async {
    final picker = ImagePicker();
    final int? pickedOption = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(LocaleKeys.select_image_source.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () => Navigator.pop(context, 1),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(
                  "Gallery",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () => Navigator.pop(context, 2),
              ),
            ],
          ),
        );
      },
    );

    if (pickedOption == null) return;

    final List<File> newImages = [];

    if (pickedOption == 1) {
      final pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        newImages.add(File(pickedImage.path));
      }
    } else if (pickedOption == 2) {
      final pickedImages = await picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        newImages.addAll(pickedImages.map((img) => File(img.path)));
      }
    }

    if (newImages.isNotEmpty) {
      trukDeleveryImage.addAll(newImages); // ✅ أضفهم بدل ما تستبدلهم
      emit(ChooseImageSuccess());
    }
  }

  void removeTrukDeleveryImage(int index) {
    trukDeleveryImage.removeAt(index);
    emit(ChooseImageSuccess());
  }

  // Get Images

  List<File> profileImage = [];
  Future<void> getProfileImage(BuildContext context) async {
    final picker = ImagePicker();
    final int? pickedOption = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(LocaleKeys.select_image_source.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () => Navigator.pop(context, 1),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text(
                  "Gallery",
                  style: TextStyle(color: Colors.black),
                ),
                onTap: () => Navigator.pop(context, 2),
              ),
            ],
          ),
        );
      },
    );

    if (pickedOption == null) return;

    XFile? pickedImage;

    if (pickedOption == 1) {
      pickedImage = await picker.pickImage(source: ImageSource.camera);
    } else if (pickedOption == 2) {
      final pickedImages = await picker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        pickedImage = pickedImages.first;
      }
    }

    if (pickedImage != null) {
      profileImage = [File(pickedImage.path)];
      emit(ChooseImageSuccess());
    }
  }

  void removeProfileImage() {
    profileImage.clear();
    emit(RemoveImageSuccess());
  }

  String? profileImageUrl;
  Future uploadProfileImage() async {
    emit(UploadImagesLoading());
    final request = http.MultipartRequest(
      'POST',
      Uri.parse("${baseUrl}api/upload-image"),
    );
    request.fields['lang'] = CacheHelper.getLang();

    for (var image in profileImage) {
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'image',
        stream,
        length,
        filename: image.path.split('/').last,
      );
      request.files.add(multipartFile);
    }
    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    Map<String, dynamic> data = jsonDecode(responseBody);
    profileImageUrl = data["app_url"];
    debugPrint("imageUrl is $profileImageUrl");

    if (data["key"] == 1) {
      emit(UploadImagesSuccess());
    } else {
      emit(UploadImagesFailure());
    }
  }

}
