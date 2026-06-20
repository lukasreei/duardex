import 'package:flutter/material.dart';

import '../models/memory_post.dart';
import '../pages/story_view_page.dart';

class StoryStrip extends StatelessWidget {
  const StoryStrip({super.key, required this.memories});

  final List<MemoryPost> memories;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 126,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 12),
        scrollDirection: Axis.horizontal,
        itemCount: memories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (context, index) => _StoryBubble(memory: memories[index]),
      ),
    );
  }
}

class _StoryBubble extends StatelessWidget {
  const _StoryBubble({required this.memory});

  final MemoryPost memory;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(46),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 380),
            reverseTransitionDuration: const Duration(milliseconds: 260),
            pageBuilder: (_, animation, __) => FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: StoryViewPage(memory: memory),
            ),
          ),
        );
      },
      child: SizedBox(
        width: 76,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFFF6B9A),
                    Color(0xFFFFD3DF),
                    Color(0xFF8E8DFF),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B9A).withValues(alpha: 0.24),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Color(0xFF07070A),
                  shape: BoxShape.circle,
                ),
                child: Hero(
                  tag: 'story-${memory.imagePath}',
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(memory.imagePath),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              memory.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
