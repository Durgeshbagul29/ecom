import 'dart:convert';
import 'dart:io';

import 'package:ecom/utils/constants/cloudinary_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  CloudinaryService._();

  static Future<String> uploadImage(
    XFile image, {
    String? folder,
    String? uploadPreset,
  }) async {
    try {
      final uri = Uri.parse(CloudinaryConstants.uploadUrl);
      final request = http.MultipartRequest('POST', uri);

      request.fields['upload_preset'] =
          uploadPreset ?? CloudinaryConstants.uploadPreset;

      if (folder != null && folder.isNotEmpty) {
        request.fields['folder'] = folder;
      }

      final rawName = image.name.trim();
      final pathName = image.path.trim().isNotEmpty
          ? image.path.split(RegExp(r'[/\\]')).last.trim()
          : '';
      final fileName = rawName.isNotEmpty
          ? rawName
          : (pathName.isNotEmpty
              ? pathName
              : 'upload_${DateTime.now().millisecondsSinceEpoch}.png');

      if (kIsWeb || image.path.isEmpty) {
        final bytes = await image.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: fileName),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            image.path,
            filename: fileName,
          ),
        );
      }

      if (kDebugMode) {
        debugPrint('==================== [CLOUDINARY SERVICE - UPLOAD REQUEST] ====================');
        debugPrint('URL : ${uri.toString()}');
        debugPrint('Preset : ${request.fields['upload_preset']}');
        debugPrint('Folder : ${request.fields['folder'] ?? '(root)'}');
        debugPrint('File : $fileName');
        debugPrint('================================================================================');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        debugPrint('==================== [CLOUDINARY SERVICE - UPLOAD RESPONSE] ====================');
        debugPrint('Status : ${response.statusCode}');
        debugPrint('Body   : ${response.body}');
        debugPrint('=================================================================================');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final secureUrl = data['secure_url'] as String?;
        if (secureUrl == null || secureUrl.isEmpty) {
          throw 'Cloudinary returned success but no secure_url was found.';
        }
        return secureUrl;
      } else {
        final errorBody = jsonDecode(response.body) as Map<String, dynamic>?;
        final errorMsg = errorBody?['error']?['message'] as String? ??
            'Upload failed (HTTP ${response.statusCode}).';
        throw errorMsg;
      }
    } on SocketException {
      throw 'No internet connection. Please check your network and try again.';
    } on http.ClientException catch (e) {
      throw 'Network error: ${e.message}';
    } on FormatException {
      throw 'Invalid response from Cloudinary. Please try again.';
    } catch (e) {
      if (e is String) rethrow;
      throw 'Failed to upload image: $e';
    }
  }
}
