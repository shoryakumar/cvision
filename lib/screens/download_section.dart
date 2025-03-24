// import 'package:flutter/material.dart';
// import '../utils/model_downloader.dart';

// class DownloadSection extends StatefulWidget {
//   final ModelDownloader modelDownloader;
//   final bool isDownloading;
//   final bool isCancelling;
//   final double downloadProgress;
//   final Function startModelDownload;
//   final Function cancelDownload;

//   const DownloadSection({
//     Key? key,
//     required this.modelDownloader,
//     required this.isDownloading,
//     required this.isCancelling,
//     required this.downloadProgress,
//     required this.startModelDownload,
//     required this.cancelDownload,
//   }) : super(key: key);

//   @override
//   _DownloadSectionState createState() => _DownloadSectionState();
// }

// class _DownloadSectionState extends State<DownloadSection> {
//   @override
//   Widget build(BuildContext context) {
//     final primaryColor = Theme.of(context).colorScheme.primary;

//     return Expanded(
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(20),
//               margin: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: primaryColor.withOpacity(0.1),
//                     blurRadius: 20,
//                     spreadRadius: 2,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: primaryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.download_rounded,
//                       color: primaryColor,
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'AI Model Required',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: primaryColor,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Please download the AI model to use the chatbot (1GB)',
//                     style: TextStyle(
//                       fontSize: 14,
//                       color: Colors.grey[600],
//                       height: 1.5,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   if (widget.isDownloading) ...[
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: LinearProgressIndicator(
//                         value: widget.downloadProgress,
//                         backgroundColor: primaryColor.withOpacity(0.1),
//                         valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
//                         minHeight: 8,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${(widget.downloadProgress * 100).toStringAsFixed(1)}%',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                             color: primaryColor,
//                           ),
//                         ),
//                         TextButton.icon(
//                           onPressed: widget.isCancelling
//                               ? null
//                               : () => widget.cancelDownload(),
//                           icon: widget.isCancelling
//                               ? SizedBox(
//                                   width: 20,
//                                   height: 20,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 2,
//                                     valueColor: AlwaysStoppedAnimation<Color>(
//                                         primaryColor),
//                                   ),
//                                 )
//                               : Icon(Icons.cancel, color: primaryColor),
//                           label: Text(
//                             widget.isCancelling ? 'Cancelling...' : 'Cancel',
//                             style: TextStyle(color: primaryColor),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ] else
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () => widget.startModelDownload(),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: primaryColor,
//                           foregroundColor: Colors.white,
//                           padding: const EdgeInsets.symmetric(
//                             horizontal: 24,
//                             vertical: 16,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           elevation: 2,
//                         ),
//                         child: const Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Icon(Icons.download_rounded),
//                             SizedBox(width: 12),
//                             Text(
//                               'Download Model',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(20),
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: primaryColor.withOpacity(0.1),
//                     blurRadius: 20,
//                     spreadRadius: 2,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: primaryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.lightbulb_outline,
//                       color: primaryColor,
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Why Download?',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: primaryColor,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildBenefitItem(
//                     icon: Icons.lock_outlined,
//                     title: 'Privacy Focused',
//                     description:
//                         'All processing happens locally on your device',
//                   ),
//                   const SizedBox(height: 12),
//                   _buildBenefitItem(
//                     icon: Icons.wifi_off_outlined,
//                     title: 'Works Offline',
//                     description: 'No internet required after initial download',
//                   ),
//                   const SizedBox(height: 12),
//                   _buildBenefitItem(
//                     icon: Icons.speed_outlined,
//                     title: 'Fast Response',
//                     description: 'Get instant answers to your questions',
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(20),
//               margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//                 boxShadow: [
//                   BoxShadow(
//                     color: primaryColor.withOpacity(0.1),
//                     blurRadius: 20,
//                     spreadRadius: 2,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.all(12),
//                     decoration: BoxDecoration(
//                       color: primaryColor.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.help_outline,
//                       color: primaryColor,
//                       size: 24,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'How It Works',
//                     style: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: primaryColor,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   _buildBenefitItem(
//                     icon: Icons.download_rounded,
//                     title: 'Download the Model',
//                     description:
//                         'Click the download button to start downloading the AI model.',
//                   ),
//                   const SizedBox(height: 12),
//                   _buildBenefitItem(
//                     icon: Icons.install_mobile,
//                     title: 'Install the Model',
//                     description:
//                         'The model will be installed on your device after download.',
//                   ),
//                   const SizedBox(height: 12),
//                   _buildBenefitItem(
//                     icon: Icons.chat_bubble_outline,
//                     title: 'Start Chatting',
//                     description:
//                         'Once installed, you can start chatting with the AI assistant.',
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBenefitItem({
//     required IconData icon,
//     required String title,
//     required String description,
//   }) {
//     final primaryColor = Theme.of(context).colorScheme.primary;
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: primaryColor.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: primaryColor.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Icon(
//               icon,
//               color: primaryColor,
//               size: 20,
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                     color: primaryColor,
//                     letterSpacing: 0.3,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   description,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[600],
//                     height: 1.3,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
