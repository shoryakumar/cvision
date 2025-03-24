import 'package:Cvision/models/combined_predictor.dart';
import 'package:Cvision/screens/gemini_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Cvision/models/densenet_predictor.dart';
import 'package:Cvision/models/model_predictor.dart'; // Import ModelPredictor
import 'package:Cvision/models/mobilenet_predictor.dart';
import 'package:Cvision/models/vgg_predictor.dart';
import 'package:Cvision/models/eye_detector.dart'; // Import EyeDetector
import 'dart:io';
import 'package:mime/mime.dart';

class ModelPredictPage extends StatefulWidget {
  final String modelName;

  const ModelPredictPage({
    super.key,
    required this.modelName,
  });

  @override
  State<ModelPredictPage> createState() => _ModelPredictPageState();
}

class _ModelPredictPageState extends State<ModelPredictPage> {
  late ModelPredictor _modelPredictor;
  late EyeDetector _eyeDetector; // Add EyeDetector
  File? _image;
  List<String>? _results;
  final ImagePicker _picker = ImagePicker();
  bool _isProcessing = false;

  Color get primaryColor => Theme.of(context).colorScheme.primary;

  @override
  void initState() {
    super.initState();
    _initializeModelPredictor();
    _initializeEyeDetector(); // Initialize EyeDetector
    _loadModel();
  }

  void _initializeModelPredictor() {
    switch (widget.modelName) {
      case 'MobileNet-v2':
        _modelPredictor = MobileNetPredictor();
        break;
      case 'VGG-19':
        _modelPredictor = VggPredictor();
        break;
      case 'DenseNet-121':
        _modelPredictor = DenseNetPredictor();
        break;
      case 'Combined Model':
        _modelPredictor = CombinedPredictor();
        break;
      default:
        throw Exception('Unknown model: ${widget.modelName}');
    }
  }

  void _initializeEyeDetector() {
    _eyeDetector = EyeDetector();
  }

  Future<void> _loadModel() async {
    try {
      await _modelPredictor.loadModel();
      await _eyeDetector.loadModel(); // Load eye detection model
      print('Models loaded successfully');
    } catch (e) {
      print('Error loading models: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
      _processImage();
    }
  }

  Future<void> _processImage() async {
    if (_image == null) return;

    setState(() {
      _isProcessing = true;
      _results = null; // Clear previous results while processing
    });

    try {
      // Check image validity first
      final isValid = await _isImageValid(_image!);
      if (!isValid) {
        _updateResults(['Invalid image format. Use JPEG/PNG']);
        return;
      }

      // Eye detection
      final isEyePresent = await _eyeDetector.isEyeDetected(_image!);
      if (!isEyePresent) {
        _updateResults(['No eye detected. Please select a clear eye image.']);
        return;
      }

      // Process with selected model
      final results = await _modelPredictor.processImage(_image!);
      _updateResults(results);
    } catch (e) {
      _updateResults(['Processing error: ${e.toString()}']);
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<bool> _isImageValid(File image) async {
    // Implement your image validation logic here
    // For example, check if the image is a valid JPEG or PNG
    final mimeType = lookupMimeType(image.path);
    return mimeType == 'image/jpeg' || mimeType == 'image/png';
  }

  void _showSourceSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildImageSourceOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                    _buildImageSourceOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    size: 32,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Disclaimer',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'This app is for educational and research purposes only. It does not provide medical diagnosis or treatment. Always consult a healthcare professional for any medical concerns.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showSourceSelectionDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'I Agree',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                size: 40,
                color:
                    isDarkMode ? Colors.white : colorScheme.onPrimaryContainer),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color:
                    isDarkMode ? Colors.white : colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _modelPredictor.dispose();
    _eyeDetector.dispose(); // Dispose eye detector
    super.dispose();
  }

  void _updateResults(List<String> results) {
    setState(() {
      _results = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          widget.modelName,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.onPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_image == null)
                  GestureDetector(
                    onTap: _showImageSourceDialog,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/images/eye.GIF',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Upload Eye Image',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Select or take a photo of the eye',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                          child: Image.file(
                            _image!,
                            width: double.infinity,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (_isProcessing)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(20),
                              ),
                              border: Border(
                                top: BorderSide(
                                  color: primaryColor.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                Text(
                                  'Analyzing image...',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Please wait while our AI processes your image',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        else if (_results != null)
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(20),
                              ),
                              border: Border.all(
                                color: primaryColor.withOpacity(0.1),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      _results!.first.contains(
                                                  'No eye detected') ||
                                              _results!.first.startsWith(
                                                  'Processing error') ||
                                              _results!.first
                                                  .startsWith('Invalid')
                                          ? Icons.error_outline
                                          : Icons.check_circle_outline,
                                      color: _results!.first.contains(
                                                  'No eye detected') ||
                                              _results!.first.startsWith(
                                                  'Processing error') ||
                                              _results!.first
                                                  .startsWith('Invalid')
                                          ? Colors.red
                                          : Colors.green,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      _results!.first.contains(
                                                  'No eye detected') ||
                                              _results!.first.startsWith(
                                                  'Processing error') ||
                                              _results!.first
                                                  .startsWith('Invalid')
                                          ? 'Invalid Image'
                                          : 'Analysis Results',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: _results!.first.contains(
                                                    'No eye detected') ||
                                                _results!.first.startsWith(
                                                    'Processing error') ||
                                                _results!.first
                                                    .startsWith('Invalid')
                                            ? Colors.red
                                            : primaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                ..._results!.map((result) => Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _results!.first.contains(
                                                    'No eye detected') ||
                                                _results!.first.startsWith(
                                                    'Processing error') ||
                                                _results!.first
                                                    .startsWith('Invalid')
                                            ? Colors.red.withOpacity(0.1)
                                            : primaryColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _results!.first.contains(
                                                      'No eye detected') ||
                                                  _results!.first.startsWith(
                                                      'Processing error') ||
                                                  _results!.first
                                                      .startsWith('Invalid')
                                              ? Colors.red.withOpacity(0.3)
                                              : primaryColor.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            _results!.first.contains(
                                                        'No eye detected') ||
                                                    _results!.first.startsWith(
                                                        'Processing error') ||
                                                    _results!.first
                                                        .startsWith('Invalid')
                                                ? Icons.warning_amber_rounded
                                                : Icons.analytics_outlined,
                                            color: _results!.first.contains(
                                                        'No eye detected') ||
                                                    _results!.first.startsWith(
                                                        'Processing error') ||
                                                    _results!.first
                                                        .startsWith('Invalid')
                                                ? Colors.red
                                                : primaryColor,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              result,
                                              style: TextStyle(
                                                color: _results!.first
                                                            .contains(
                                                                'No eye detected') ||
                                                        _results!.first.startsWith(
                                                            'Processing error') ||
                                                        _results!.first
                                                            .startsWith(
                                                                'Invalid')
                                                    ? Colors.red
                                                    : primaryColor,
                                                fontSize: 16,
                                                height: 1.4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )),
                                if (!_results!.first
                                        .contains('No eye detected') &&
                                    !_results!.first
                                        .startsWith('Processing error') &&
                                    !_results!.first.startsWith('Invalid'))
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ChatbotPage(),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 2,
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(Icons.chat_bubble_outline),
                                          SizedBox(width: 12),
                                          Text(
                                            'Discuss with AI Assistant',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showImageSourceDialog,
        icon: const Icon(Icons.add_photo_alternate),
        label: const Text('Add Image'),
        backgroundColor: Colors.white,
        foregroundColor: primaryColor,
      ),
    );
  }
}
