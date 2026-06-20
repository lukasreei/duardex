import 'package:flutter/material.dart';

import '../models/memory_post.dart';

class TimelineMemoryCard extends StatelessWidget {
  const TimelineMemoryCard({
    super.key,
    required this.memory,
    required this.isFirst,
    required this.isLast,
  });

  final MemoryPost memory;
  final bool isFirst;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 34,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst ? Colors.transparent : Colors.white12,
                  ),
                ),
                Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFF6B9A),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast ? Colors.transparent : Colors.white12,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxWidth < 390;
                  final image = ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      memory.imagePath,
                      width: compact ? double.infinity : 84,
                      height: compact ? 150 : 104,
                      fit: BoxFit.cover,
                    ),
                  );
                  final details = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        memory.date,
                        style: const TextStyle(
                          color: Color(0xFFFFB7CB),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        memory.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        memory.description,
                        maxLines: compact ? 5 : 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  );

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111116),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white10),
                    ),
                    child: compact
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              image,
                              const SizedBox(height: 12),
                              details,
                            ],
                          )
                        : Row(
                            children: [
                              image,
                              const SizedBox(width: 14),
                              Expanded(child: details),
                            ],
                          ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
