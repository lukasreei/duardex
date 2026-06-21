import 'package:flutter/material.dart';

import '../models/memory_post.dart';
import '../theme/app_colors.dart';

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
    return Stack(
      children: [
        if (!isFirst)
          const Positioned(
            left: 16,
            top: 0,
            height: 22,
            child: VerticalDivider(
              width: 2,
              thickness: 2,
              color: AppColors.highlight,
            ),
          ),
        if (!isLast)
          const Positioned(
            left: 16,
            top: 35,
            bottom: 0,
            child: VerticalDivider(
              width: 2,
              thickness: 2,
              color: AppColors.highlight,
            ),
          ),
        Positioned(
          left: 10,
          top: 21,
          child: Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
              border: Border.all(color: AppColors.background, width: 2),
            ),
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 34),
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
                            color: AppColors.secondary,
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
                          style: const TextStyle(color: AppColors.mutedText),
                        ),
                      ],
                    );

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
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
      ],
    );
  }
}
