// lib/features/dashboard/modelus/Videos/view/VideosScreen.dart
import 'package:flutter/material.dart';
//import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_api_service.dart';
import 'package:greanspherproj/features/dashboard/modelus/Component/model/app_models_and_api_service.dart'; // ApiService, ShortItem
import 'package:url_launcher/url_launcher.dart';

class VideosScreen extends StatefulWidget {
  final String categoryName; // اسم الـ category الذي تم اختياره

  const VideosScreen({Key? key, required this.categoryName}) : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> {
  final ApiService _apiService = ApiService();
  List<ShortItem> _videos = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchVideosByCategory(); // جلب الفيديوهات حسب الـ category
  }

  Future<void> _fetchVideosByCategory() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final videos = await _apiService
          .fetchShortsByCategory(widget.categoryName); // جلب الفيديوهات
      setState(() {
        _videos = videos;
      });
    } catch (e) {
      print("Error fetching videos for category ${widget.categoryName}: $e");
      setState(() {
        _errorMessage = 'Failed to load videos: $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.categoryName,
            style: const TextStyle(
                color: Colors.black,
                fontWeight:
                    FontWeight.bold)), // عنوان الشاشة هو اسم الـ category
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : _videos.isEmpty
                  ? const Center(
                      child: Text("No videos found for this category.",
                          style: TextStyle(color: Colors.grey)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _videos.length,
                      itemBuilder: (context, index) {
                        final video = _videos[index];
                        return Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                video.thumbnailUrl ??
                                    'assets/images/shortvideo1.png', // صورة مصغرة للفيديو
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset('assets/images/shortvideo1.png',
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(video.title,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                    const SizedBox(height: 4),
                                    Text(video.description,
                                        style: const TextStyle(
                                            color: Colors.grey, fontSize: 14)),
                                    const SizedBox(height: 8),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final url = Uri.parse(video.videoUrl);
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Could not launch ${video.videoUrl}')),
                                          );
                                          print('Could not launch $url');
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      child: const Text('Watch Video',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
