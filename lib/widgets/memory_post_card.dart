import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../models/memory_post.dart';

class MemoryPostCard extends StatefulWidget {
  const MemoryPostCard({super.key, required this.memory});

  final MemoryPost memory;

  @override
  State<MemoryPostCard> createState() => _MemoryPostCardState();
}

class _MemoryPostCardState extends State<MemoryPostCard> {
  bool _liked = true;

  @override
  Widget build(BuildContext context) {
    final memory = widget.memory;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF111116),
          border: Border.all(
            color: memory.isVideo ? const Color(0x55FF6B9A) : Colors.white10,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x66000000),
              blurRadius: 24,
              offset: Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(memory.imagePath),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          memory.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w800),
                        ),
                        Text(
                          memory.date,
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (memory.isVideo) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0x22FF6B9A),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0x55FF6B9A)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_circle_fill_rounded,
                            size: 14,
                            color: Color(0xFFFF6B9A),
                          ),
                          SizedBox(width: 4),
                          Text(
                            'VIDEO',
                            style: TextStyle(
                              color: Color(0xFFFFA2BE),
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  const Icon(Icons.more_horiz_rounded, color: Colors.white70),
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 4 / 5,
              child: memory.isVideo
                  ? _MemoryVideo(path: memory.videoPath!)
                  : Image.asset(
                      memory.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        tooltip: 'Curtir memoria',
                        onPressed: () => setState(() => _liked = !_liked),
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, animation) =>
                              ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            _liked
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            key: ValueKey(_liked),
                            color: _liked
                                ? const Color(0xFFFF6B9A)
                                : Colors.white,
                          ),
                        ),
                      ),
                      const Icon(Icons.chat_bubble_outline_rounded),
                      const SizedBox(width: 14),
                      const Icon(Icons.send_outlined),
                      const Spacer(),
                      const Icon(Icons.bookmark_border_rounded),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    memory.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    memory.description,
                    style: const TextStyle(
                      color: Color(0xFFE5E5EA),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemoryVideo extends StatefulWidget {
  const _MemoryVideo({required this.path});

  final String path;

  @override
  State<_MemoryVideo> createState() => _MemoryVideoState();
}

class _MemoryVideoState extends State<_MemoryVideo> {
  late final VideoPlayerController _controller;
  bool _initializationFailed = false;
  bool _muted = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.path)
      ..setLooping(true)
      ..initialize()
          .then((_) {
            if (mounted) setState(() {});
          })
          .catchError((_) {
            if (mounted) setState(() => _initializationFailed = true);
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayback() {
    if (!_controller.value.isInitialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  void _toggleSound() {
    setState(() {
      _muted = !_muted;
      _controller.setVolume(_muted ? 0 : 1);
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_initializationFailed) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: Icon(Icons.videocam_off_rounded, color: Colors.white54),
        ),
      );
    }

    if (!_controller.value.isInitialized) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return ValueListenableBuilder<VideoPlayerValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        return GestureDetector(
          onTap: _togglePlayback,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF24151D), Color(0xFF050507)],
                  ),
                ),
              ),
              Center(
                child: AspectRatio(
                  aspectRatio: value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x33000000),
                      Colors.transparent,
                      Color(0xB8000000),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 14,
                left: 14,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0x99000000),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.videocam_rounded,
                        color: Color(0xFFFF8AAF),
                        size: 15,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'NOSSO MOMENTO',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 10,
                          letterSpacing: 0.7,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton.filledTonal(
                  tooltip: _muted ? 'Ativar som' : 'Silenciar',
                  onPressed: _toggleSound,
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0x99000000),
                    foregroundColor: Colors.white,
                  ),
                  icon: Icon(
                    _muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                    size: 21,
                  ),
                ),
              ),
              IgnorePointer(
                ignoring: value.isPlaying,
                child: AnimatedScale(
                  scale: value.isPlaying ? 0.72 : 1,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  child: AnimatedOpacity(
                    opacity: value.isPlaying ? 0 : 1,
                    duration: const Duration(milliseconds: 180),
                    child: Center(
                      child: Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: const Color(0xDDFF6B9A),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white70, width: 2),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x88FF3D7A),
                              blurRadius: 28,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 14,
                right: 14,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 7),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: VideoProgressIndicator(
                        _controller,
                        allowScrubbing: true,
                        padding: EdgeInsets.zero,
                        colors: const VideoProgressColors(
                          playedColor: Color(0xFFFF6B9A),
                          bufferedColor: Colors.white38,
                          backgroundColor: Colors.white24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
