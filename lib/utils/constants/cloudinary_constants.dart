import 'package:ecom/utils/constants/cloudinary_config.dart';

class CloudinaryConstants {
  CloudinaryConstants._();

  static const String cloudName = CloudinaryConfig.cloudName;
  static const String uploadPreset = CloudinaryConfig.uploadPreset;
  static const String uploadUrl =
      'https://api.cloudinary.com/v1_1/$cloudName/image/upload';
  static const String deleteByTokenUrl =
      'https://api.cloudinary.com/v1_1/$cloudName/delete_by_token';
}
