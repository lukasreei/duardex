import 'package:flutter/material.dart';

import '../data/memories.dart';
import '../widgets/timeline_memory_card.dart';
import '../widgets/responsive_content.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveContent(
        maxWidth: 820,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverAppBar(pinned: true, title: Text('Linha do tempo')),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 32),
              sliver: SliverList.builder(
                itemCount: memories.length,
                itemBuilder: (context, index) {
                  return TimelineMemoryCard(
                    memory: memories[index],
                    isFirst: index == 0,
                    isLast: index == memories.length - 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
