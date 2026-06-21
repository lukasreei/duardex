import 'package:flutter/material.dart';

import '../data/memories.dart';
import '../widgets/luna_bottom_nav.dart';
import '../widgets/memory_post_card.dart';
import '../widgets/responsive_content.dart';
import '../widgets/story_strip.dart';
import 'letter_page.dart';
import 'timeline_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [const _FeedPage(), const TimelinePage(), const LetterPage()];

    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 840;
        final page = AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: KeyedSubtree(
            key: ValueKey(_currentIndex),
            child: pages[_currentIndex],
          ),
        );

        return Scaffold(
          body: useRail
              ? Row(
                  children: [
                    SafeArea(
                      child: NavigationRail(
                        selectedIndex: _currentIndex,
                        onDestinationSelected: (index) =>
                            setState(() => _currentIndex = index),
                        labelType: NavigationRailLabelType.all,
                        backgroundColor: const Color(0xFF0B0B10),
                        indicatorColor: const Color(0x33FF6B9A),
                        destinations: const [
                          NavigationRailDestination(
                            icon: Icon(Icons.home_outlined),
                            selectedIcon: Icon(Icons.home_rounded),
                            label: Text('Inicio'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.timeline_outlined),
                            selectedIcon: Icon(Icons.timeline_rounded),
                            label: Text('Tempo'),
                          ),
                          NavigationRailDestination(
                            icon: Icon(Icons.mail_outline_rounded),
                            selectedIcon: Icon(Icons.mail_rounded),
                            label: Text('Carta'),
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(width: 1, color: Colors.white10),
                    Expanded(child: page),
                  ],
                )
              : page,
          bottomNavigationBar: useRail
              ? null
              : LunaBottomNav(
                  currentIndex: _currentIndex,
                  onChanged: (index) => setState(() => _currentIndex = index),
                ),
        );
      },
    );
  }
}

class _FeedPage extends StatelessWidget {
  const _FeedPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveContent(
        maxWidth: 720,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              title: const Text(
                'Luna',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0,
                ),
              ),
              actions: const [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.favorite_rounded, color: Color(0xFFFF6B9A)),
                ),
              ],
            ),
            const SliverToBoxAdapter(child: StoryStrip(memories: memories)),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
              sliver: SliverList.separated(
                itemCount: memories.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, index) {
                  return TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: Duration(milliseconds: 360 + index * 80),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, 18 * (1 - value)),
                          child: child,
                        ),
                      );
                    },
                    child: MemoryPostCard(memory: memories[index]),
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
