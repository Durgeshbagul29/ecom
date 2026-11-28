import 'dart:convert';
import 'dart:io';

import 'package:ecom/utils/constants/cloudinary_constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryUploadResult {
  const CloudinaryUploadResult({
    required this.secureUrl,
    this.deleteToken,
    this.publicId,
  });

  final String secureUrl;
  final String? deleteToken;
  final String? publicId;
}

class CloudinaryService {
  CloudinaryService._();

  static String get uploadPresetName => CloudinaryConstants.uploadPreset;

  static const Set<String> _supportedExtensions = {
    'png',
    'jpg',
    'jpeg',
  };

  /// Detects `'png'` or `'jpg'` from file header magic bytes, or `null` for
  /// unsupported formats such as GIF/WebP/SVG.
  static String? detectPngOrJpgExtension(List<int> bytes) {
    if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'png';
    }
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return 'jpg';
    }
    return null;
  }

  /// Returns `true` only when [image] is a PNG or JPG/JPEG image.
  static bool isPngOrJpg(XFile image, {List<int>? headerBytes}) {
    if (headerBytes != null && headerBytes.isNotEmpty) {
      return detectPngOrJpgExtension(headerBytes) != null;
    }

    final mime = image.mimeType?.toLowerCase().trim() ?? '';
    if (mime == 'image/png' || mime == 'image/jpeg' || mime == 'image/jpg') {
      return true;
    }
    if (mime.isNotEmpty) return false;

    final nameOrPath =
        image.name.trim().isNotEmpty ? image.name.trim() : image.path.trim();
    if (!nameOrPath.contains('.')) return false;
    final ext = nameOrPath.split('.').last.toLowerCase();
    return _supportedExtensions.contains(ext);
  }

  /// Resolves a non-empty upload filename with a valid `.png`, `.jpg`, or
  /// `.jpeg` extension.
  @visibleForTesting
  static String resolveUploadFileName(
    XFile image, {
    List<int>? headerBytes,
  }) {
    final rawName = image.name.trim().isNotEmpty
        ? image.name.trim().split(RegExp(r'[/\\]')).last.trim()
        : '';
    final pathName = image.path.trim().isNotEmpty
        ? image.path.trim().split(RegExp(r'[/\\]')).last.trim()
        : '';
    final baseCandidate = rawName.isNotEmpty ? rawName : pathName;

    if (baseCandidate.isNotEmpty && baseCandidate.contains('.')) {
      final ext = baseCandidate.split('.').last.toLowerCase();
      if (_supportedExtensions.contains(ext)) {
        return baseCandidate;
      }
    }

    final ext = _inferExtension(image.mimeType, headerBytes);
    final stem = baseCandidate.isNotEmpty
        ? baseCandidate.replaceAll(RegExp(r'\.[^.]+$'), '')
        : 'upload_${DateTime.now().millisecondsSinceEpoch}';
    return '$stem.$ext';
  }

  static String _inferExtension(String? mimeType, List<int>? bytes) {
    if (bytes != null) {
      final detected = detectPngOrJpgExtension(bytes);
      if (detected != null) return detected;
    }

    final mime = mimeType?.toLowerCase().trim() ?? '';
    if (mime == 'image/jpeg' || mime == 'image/jpg') return 'jpg';
    return 'png';
  }

  static Future<String> uploadImage(
    XFile image, {
    String? folder,
    String? uploadPreset,
  }) async {
    final result = await uploadImageWithDetails(
      image,
      folder: folder,
      uploadPreset: uploadPreset,
    );
    return result.secureUrl;
  }

  static Future<CloudinaryUploadResult> uploadImageWithDetails(
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

      if (kIsWeb || image.path.isEmpty) {
        final bytes = await image.readAsBytes();
        if (!isPngOrJpg(image, headerBytes: bytes)) {
          throw 'Only PNG and JPG images are supported.';
        }
        final fileName = resolveUploadFileName(image, headerBytes: bytes);
        request.files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: fileName),
        );
        _logUploadRequest(uri, request, fileName);
      } else {
        List<int>? headerBytes;
        try {
          headerBytes = await File(image.path).openRead(0, 12).first;
        } catch (_) {}
        if (!isPngOrJpg(image, headerBytes: headerBytes)) {
          throw 'Only PNG and JPG images are supported.';
        }
        final fileName = resolveUploadFileName(image, headerBytes: headerBytes);
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            image.path,
            filename: fileName,
          ),
        );
        _logUploadRequest(uri, request, fileName);
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
        return CloudinaryUploadResult(
          secureUrl: secureUrl,
          deleteToken: data['delete_token'] as String?,
          publicId: data['public_id'] as String?,
        );
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

  /// Best-effort deletion of a recently uploaded unsigned asset using the
  /// short-lived `delete_token` (valid for 10 minutes when enabled on preset).
  static Future<bool> deleteByToken(
    String deleteToken, {
    http.Client? client,
  }) async {
    final token = deleteToken.trim();
    if (token.isEmpty) return false;

    final httpClient = client ?? http.Client();
    final shouldCloseClient = client == null;
    try {
      final uri = Uri.parse(CloudinaryConstants.deleteByTokenUrl);
      if (kDebugMode) {
        debugPrint('==================== [CLOUDINARY SERVICE - DELETE REQUEST] ====================');
        debugPrint('URL : ${uri.toString()}');
        debugPrint('================================================================================');
      }

      final response = await httpClient.post(
        uri,
        body: {'token': token},
      );

      if (kDebugMode) {
        debugPrint('==================== [CLOUDINARY SERVICE - DELETE RESPONSE] ====================');
        debugPrint('Status : ${response.statusCode}');
        debugPrint('Body   : ${response.body}');
        debugPrint('=================================================================================');
      }

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Cloudinary deleteByToken skipped: $e');
      }
      return false;
    } finally {
      if (shouldCloseClient) {
        httpClient.close();
      }
    }
  }

  static void _logUploadRequest(
    Uri uri,
    http.MultipartRequest request,
    String fileName,
  ) {
    if (!kDebugMode) return;
    debugPrint('==================== [CLOUDINARY SERVICE - UPLOAD REQUEST] ====================');
    debugPrint('URL : ${uri.toString()}');
    debugPrint('Preset : ${request.fields['upload_preset']}');
    debugPrint('Folder : ${request.fields['folder'] ?? '(root)'}');
    debugPrint('File : $fileName');
    debugPrint('================================================================================');
  }
}
