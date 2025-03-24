// import 'package:Cvision/screens/download_section.dart';
// import 'package:flutter/material.dart';
// import '../widgets/chat_message.dart';
// import '../utils/model_downloader.dart';
// import 'package:dio/dio.dart';
// import 'dart:io';

// class ChatbotPage extends StatefulWidget {
//   const ChatbotPage({super.key});

//   @override
//   State<ChatbotPage> createState() => _ChatbotPageState();
// }

// class _ChatbotPageState extends State<ChatbotPage> {
//   final TextEditingController _messageController = TextEditingController();
//   final ScrollController _scrollController = ScrollController();
//   final List<ChatMessage> _messages = [];
//   late final ModelDownloader _modelDownloader;
//   bool _isTyping = false;
//   bool _isModelDownloaded = false;
//   bool _isDownloading = false;
//   bool _isCancelling = false;
//   double _downloadProgress = 0.0;
//   bool _isModelLoaded = false;

//   @override
//   void initState() {
//     super.initState();
//     _modelDownloader = ModelDownloader(context);
//     _checkModelStatus();
//   }

//   @override
//   void dispose() {
//     if (_isDownloading) {
//       _modelDownloader.cancelDownload();
//     }
//     _messageController.dispose();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   Future<void> _loadModel() async {
//     if (!mounted) return;

//     try {
//       setState(() {
//         _isModelLoaded = true;
//       });
//     } catch (e) {
//       print('Error loading model: $e');
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Error loading AI model: ${e.toString()}',
//               style: TextStyle(color: Theme.of(context).colorScheme.primary),
//             ),
//             backgroundColor: Colors.white,
//             duration: const Duration(seconds: 5),
//           ),
//         );
//       }
//     }
//   }

//   Future<void> _checkModelStatus() async {
//     final isDownloaded = await _modelDownloader.isModelDownloaded();
//     setState(() {
//       _isModelDownloaded = isDownloaded;
//     });
//   }

//   void _scrollToBottom() {
//     Future.delayed(const Duration(milliseconds: 50), () {
//       if (_scrollController.hasClients) {
//         _scrollController.animateTo(
//           _scrollController.position.maxScrollExtent,
//           duration: const Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//         );
//       }
//     });
//   }

//   Future<void> _sendMessage() async {
//     if (_messageController.text.trim().isEmpty) return;
//     if (!_isModelLoaded) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(
//             'AI model is not ready yet',
//             style: TextStyle(color: Theme.of(context).colorScheme.primary),
//           ),
//           backgroundColor: Colors.white,
//         ),
//       );
//       return;
//     }

//     final message = _messageController.text;
//     _messageController.clear();

//     setState(() {
//       _messages.add(ChatMessage(
//         text: message,
//         isUser: true,
//       ));
//       _isTyping = true;
//     });

//     _scrollToBottom();

//     // Simulate AI response with default message
//     await Future.delayed(const Duration(milliseconds: 1000));

//     setState(() {
//       _isTyping = false;
//       _messages.add(ChatMessage(
//         text:
//             "This feature is currently under development. Our AI assistant will be ready to help you soon! Stay tuned for updates.",
//         isUser: false,
//       ));
//     });

//     _scrollToBottom();
//   }

//   Future<void> _startModelDownload() async {
//     // If already downloading, cancel the current download first
//     if (_isDownloading) {
//       await _cancelDownload();
//     }

//     // Reset all download-related states
//     setState(() {
//       _isDownloading = true;
//       _downloadProgress = 0.0;
//       _isCancelling = false;
//     });

//     // Clean up any partial downloads
//     final modelPath = await _modelDownloader.getModelPath();
//     final file = File(modelPath);
//     if (await file.exists()) {
//       await file.delete();
//     }

//     if (!mounted) return;

//     try {
//       await _modelDownloader.downloadModel((progress) {
//         if (!mounted) return;
//         setState(() {
//           _downloadProgress = progress;
//         });
//       });

//       if (!mounted) return;

//       setState(() {
//         _isModelDownloaded = true;
//         _isDownloading = false;
//       });

//       // Load the model after successful download
//       await _loadModel();
//     } catch (e) {
//       if (!mounted) return;

//       setState(() {
//         _isDownloading = false;
//         _downloadProgress = 0.0;
//       });

//       if (e is DioException && e.type == DioExceptionType.cancel) {
//         return;
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(
//               'Download failed. Please try again.',
//               style: TextStyle(color: Theme.of(context).colorScheme.primary),
//             ),
//             backgroundColor: Colors.white,
//             duration: const Duration(seconds: 5),
//           ),
//         );
//       }
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isCancelling = false;
//         });
//       }
//     }
//   }

//   Future<void> _cancelDownload() async {
//     setState(() {
//       _isCancelling = true;
//     });
//     await _modelDownloader.cancelDownload();

//     // Clean up any partial downloads
//     try {
//       final modelPath = await _modelDownloader.getModelPath();
//       final file = File(modelPath);
//       if (await file.exists()) {
//         await file.delete();
//       }
//     } catch (e) {
//       // Ignore file deletion errors
//       print('Warning: Could not delete model file: $e');
//     }

//     setState(() {
//       _isDownloading = false;
//       _downloadProgress = 0.0;
//       _isCancelling = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).colorScheme.primary;

//     return WillPopScope(
//       onWillPop: () async {
//         if (_isDownloading) {
//           await _cancelDownload();
//         }
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           elevation: 0,
//           backgroundColor: Colors.transparent,
//           title: Text(
//             'AI Assistant',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Theme.of(context).colorScheme.onPrimary,
//             ),
//           ),
//           centerTitle: true,
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios,
//               color: Theme.of(context).colorScheme.onPrimary,
//             ),
//             onPressed: () async {
//               if (_isDownloading) {
//                 await _cancelDownload();
//               }
//               if (mounted) {
//                 Navigator.pop(context);
//               }
//             },
//           ),
//         ),
//         extendBodyBehindAppBar: true,
//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [primaryColor, primaryColor],
//             ),
//           ),
//           child: SafeArea(
//             child: Column(
//               children: [
//                 if (!_isModelDownloaded)
//                   DownloadSection(
//                     modelDownloader: _modelDownloader,
//                     isDownloading: _isDownloading,
//                     isCancelling: _isCancelling,
//                     downloadProgress: _downloadProgress,
//                     startModelDownload: _startModelDownload,
//                     cancelDownload: _cancelDownload,
//                   ),
//                 if (_isModelDownloaded) ...[
//                   Expanded(
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: ListView.builder(
//                         controller: _scrollController,
//                         itemCount: _messages.length,
//                         itemBuilder: (context, index) {
//                           return _messages[index];
//                         },
//                       ),
//                     ),
//                   ),
//                   if (_isTyping)
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       alignment: Alignment.centerLeft,
//                       child: const CircularProgressIndicator(),
//                     ),
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           blurRadius: 10,
//                           offset: const Offset(0, -5),
//                         ),
//                       ],
//                     ),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: _messageController,
//                             decoration: InputDecoration(
//                               hintText: 'Ask about eye health...',
//                               hintStyle: TextStyle(
//                                 color: Theme.of(context).brightness ==
//                                         Brightness.dark
//                                     ? Colors.grey[400]
//                                     : Colors.grey[600],
//                               ),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(25),
//                                 borderSide: BorderSide.none,
//                               ),
//                               filled: true,
//                               fillColor: Theme.of(context).brightness ==
//                                       Brightness.dark
//                                   ? Colors.grey[800]
//                                   : Colors.grey[100],
//                               contentPadding: const EdgeInsets.symmetric(
//                                 horizontal: 20,
//                                 vertical: 10,
//                               ),
//                             ),
//                             onSubmitted: (_) => _sendMessage(),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         Container(
//                           decoration: BoxDecoration(
//                             color: primaryColor,
//                             shape: BoxShape.circle,
//                           ),
//                           child: IconButton(
//                             onPressed: _sendMessage,
//                             icon: const Icon(
//                               Icons.send_rounded,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }