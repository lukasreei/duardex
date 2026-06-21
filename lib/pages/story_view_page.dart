import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../models/memory_post.dart';
import '../theme/app_colors.dart';

class StoryViewPage extends StatefulWidget {
  const StoryViewPage({
    super.key,
    required this.memories,
    required this.initialIndex,
  });

  final List<MemoryPost> memories;
  final int initialIndex;

  @override
  State<StoryViewPage> createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage>
    with TickerProviderStateMixin {
  static const _storyDuration = Duration(seconds: 30);
  static const _dismissDistance = 110.0;

  late final AnimationController _progressController;
  late final AnimationController _dragResetController;
  late final AudioPlayer _audioPlayer;
  late int _currentIndex;
  double _dragOffset = 0;
  double _dragResetStart = 0;

  MemoryPost get _memory => widget.memories[_currentIndex];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.memories.length - 1);
    _audioPlayer = AudioPlayer();
    _progressController = AnimationController(
      vsync: this,
      duration: _storyDuration,
    )..addStatusListener(_handleProgressStatus);
    _dragResetController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 180),
        )..addListener(() {
          setState(() {
            _dragOffset =
                _dragResetStart *
                (1 - Curves.easeOut.transform(_dragResetController.value));
          });
        });
    _progressController.forward();
    _playCurrentStoryAudio();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _dragResetController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playCurrentStoryAudio() async {
    await _audioPlayer.stop();
    final audioPath = _memory.audioPath;
    if (audioPath == null) return;

    final assetPath = audioPath.startsWith('assets/')
        ? audioPath.substring('assets/'.length)
        : audioPath;
    await _audioPlayer.play(
      AssetSource(assetPath),
      position: _memory.audioStart,
    );
  }

  void _handleProgressStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _nextStory();
    }
  }

  void _showStory(int index) {
    if (index < 0 || index >= widget.memories.length) return;
    setState(() => _currentIndex = index);
    _progressController.forward(from: 0);
    _playCurrentStoryAudio();
  }

  void _nextStory() {
    if (_currentIndex < widget.memories.length - 1) {
      _showStory(_currentIndex + 1);
    } else if (mounted) {
      Navigator.of(context).pop();
    }
  }

  void _previousStory() {
    if (_currentIndex > 0) {
      _showStory(_currentIndex - 1);
    } else {
      _progressController.forward(from: 0);
      _playCurrentStoryAudio();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    final width = MediaQuery.sizeOf(context).width;
    if (details.localPosition.dx < width * .35) {
      _previousStory();
    } else {
      _nextStory();
    }
  }

  void _handleDragStart(DragStartDetails details) {
    _dragResetController.stop();
    _progressController.stop();
    _audioPlayer.pause();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() => _dragOffset += details.delta.dy);
  }

  void _handleDragEnd(DragEndDetails details) {
    final velocity = details.primaryVelocity ?? 0;
    if (_dragOffset.abs() >= _dismissDistance || velocity.abs() > 700) {
      Navigator.of(context).pop();
      return;
    }

    _dragResetStart = _dragOffset;
    _dragResetController.forward(from: 0);
    _progressController.forward();
    _audioPlayer.resume();
  }

  void _handleDragCancel() {
    _dragResetStart = _dragOffset;
    _dragResetController.forward(from: 0);
    _progressController.forward();
    _audioPlayer.resume();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final opacity = 1.0 - math.min(_dragOffset.abs() / screenHeight, .65);

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _progressController,
        builder: (context, _) {
          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(0, _dragOffset),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapUp: _handleTapUp,
                onVerticalDragStart: _handleDragStart,
                onVerticalDragUpdate: _handleDragUpdate,
                onVerticalDragEnd: _handleDragEnd,
                onVerticalDragCancel: _handleDragCancel,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'story-$_currentIndex-${_memory.imagePath}',
                      child: Image.asset(
                        _memory.imagePath,
                        key: ValueKey(_memory.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black87,
                            Colors.transparent,
                            Colors.black87,
                          ],
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: Padding(
                            padding: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: _buildProgressBars()),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      icon: const Icon(Icons.close_rounded),
                                      color: Colors.white,
                                      tooltip: 'Fechar',
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  _memory.title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  _memory.date,
                                  style: const TextStyle(
                                    color: AppColors.highlight,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  _memory.description,
                                  maxLines: 6,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressBars() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        children: List.generate(widget.memories.length, (index) {
          final value = index < _currentIndex
              ? 1.0
              : index == _currentIndex
              ? _progressController.value
              : 0.0;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index == widget.memories.length - 1 ? 0 : 4,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: value,
                  minHeight: 3,
                  backgroundColor: Colors.white30,
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
