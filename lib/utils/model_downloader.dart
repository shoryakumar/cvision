// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter/material.dart';

// class ModelDownloader {
//   final Dio dio = Dio();
//   final String modelUrl =
//       "https://huggingface.co/QuantFactory/Llama-3.2-1B-GGUF/resolve/main/Llama-3.2-1B.Q4_K_M.gguf";
//   final String modelName = "3.2-1B.Q4_K_M.gguf";
//   CancelToken? _cancelToken;

//   // Add BuildContext parameter to show SnackBar
//   late BuildContext context;

//   // Constructor to receive context
//   ModelDownloader(this.context);

//   Future<String> getModelPath() async {
//     final dir = await getApplicationDocumentsDirectory();
//     return "${dir.path}/$modelName";
//   }

//   Future<bool> isModelDownloaded() async {
//     try {
//       final path = await getModelPath();
//       final file = File(path);
//       if (!file.existsSync()) return false;

//       // Check if file size is reasonable (e.g., > 100MB)
//       // This helps detect corrupted or partial downloads
//       final fileSize = await file.length();
//       return fileSize > 100 * 1024 * 1024; // 100MB minimum
//     } catch (e) {
//       print('Error checking model status: $e');
//       return false;
//     }
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           message,
//           style: TextStyle(color: Theme.of(context).colorScheme.primary),
//         ),
//         backgroundColor: Colors.white,
//         duration: const Duration(seconds: 5),
//       ),
//     );
//   }

//   Future<void> cancelDownload() async {
//     if (_cancelToken != null && !_cancelToken!.isCancelled) {
//       _cancelToken!.cancel('Download cancelled by user');
//     }
//   }

//   Future<void> downloadModel(Function(double) onProgress) async {
//     final path = await getModelPath();
//     _cancelToken = CancelToken();

//     try {
//       // Validate URL first
//       final uri = Uri.parse(modelUrl);
//       if (!uri.isAbsolute) {
//         throw 'Invalid model URL';
//       }

//       // Try to check if the URL is accessible
//       try {
//         final response = await dio.head(modelUrl);
//         if (response.statusCode != 200) {
//           throw 'Model URL is not accessible';
//         }
//       } on DioException catch (e) {
//         if (e.type == DioExceptionType.connectionTimeout) {
//           throw 'Connection timeout - Please check your internet connection';
//         } else if (e.type == DioExceptionType.connectionError) {
//           throw 'Cannot connect to server - Please check your internet connection';
//         } else if (e.type == DioExceptionType.badResponse) {
//           throw 'Invalid model URL or server error (${e.response?.statusCode})';
//         } else {
//           throw 'Network error: ${e.message}';
//         }
//       }

//       // Proceed with download if URL is valid and accessible
//       await dio.download(
//         modelUrl,
//         path,
//         cancelToken: _cancelToken,
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             double progress = received / total;
//             onProgress(progress);
//           }
//         },
//         options: Options(
//           receiveTimeout: const Duration(minutes: 5),
//           sendTimeout: const Duration(minutes: 5),
//         ),
//       );

//       // Verify downloaded file
//       final file = File(path);
//       if (!await file.exists() || await file.length() == 0) {
//         throw 'Download failed: File is empty or not found';
//       }

//       // Clean up any partial downloads if cancelled
//       if (_cancelToken?.isCancelled ?? false) {
//         await file.delete();
//         throw 'Download cancelled';
//       }

//       _showSnackBar('Model downloaded successfully!');
//     } catch (e) {
//       if (e is DioException && e.type == DioExceptionType.cancel) {
//         _showSnackBar('Download cancelled');
//       } else {
//         String errorMessage =
//             e is String ? e : 'Download failed: ${e.toString()}';
//         _showSnackBar(errorMessage);
//       }
//       rethrow;
//     } finally {
//       _cancelToken = null;
//     }
//   }
// }
