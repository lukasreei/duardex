class MemoryPost {
  const MemoryPost({
    required this.imagePath,
    required this.date,
    required this.title,
    required this.description,
    this.videoPath,
  });

  final String imagePath;
  final String date;
  final String title;
  final String description;
  final String? videoPath;

  bool get isVideo => videoPath != null;
}
