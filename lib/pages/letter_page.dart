import 'package:flutter/material.dart';

import '../data/memories.dart';
import '../widgets/responsive_content.dart';

class LetterPage extends StatelessWidget {
  const LetterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveContent(
        maxWidth: 720,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            const SliverAppBar(pinned: true, title: Text('Carta')),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(22, 26, 22, 40),
              sliver: SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(
                    MediaQuery.sizeOf(context).width < 360 ? 18 : 24,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101015),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white10),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x55000000),
                        blurRadius: 26,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Para Você,',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        loveLetter,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFECECF1),
                          fontSize: 18,
                          height: 1.65,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
