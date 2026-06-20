import 'package:flutter/material.dart';

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
      borderRadius: BorderRadius.circular(8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF111116),
          border: Border.all(color: Colors.white10),
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
                  const Icon(Icons.more_horiz_rounded, color: Colors.white70),
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 4 / 5,
              child: Image.asset(
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
