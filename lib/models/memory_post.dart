class MemoryPost {
  const MemoryPost({
    required this.imagePath,
    required this.date,
    required this.title,
    required this.description,
    this.videoPath,
    this.audioPath,
    this.audioStart = Duration.zero,
  });

  final String imagePath;
  final String date;
  final String title;
  final String description;
  final String? videoPath;
  final String? audioPath;
  final Duration audioStart;

  bool get isVideo => videoPath != null;
}
