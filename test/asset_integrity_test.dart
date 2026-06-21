import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:luna/data/memories.dart';

void main() {
  test('all memory media assets exist and are not empty', () {
    expect(memories, hasLength(30));
    expect(videoMemories, hasLength(5));

    final paths = <String>{
      for (final memory in feedMemories) memory.imagePath,
      for (final memory in feedMemories)
        if (memory.videoPath case final path?) path,
      for (final memory in feedMemories)
        if (memory.audioPath case final path?) path,
    };

    for (final path in paths) {
      final file = File(path);
      expect(file.existsSync(), isTrue, reason: 'Asset ausente: $path');
      expect(file.lengthSync(), greaterThan(0), reason: 'Asset vazio: $path');
    }
  });

  test('story audio tracks keep their intended start positions', () {
    final byTitle = {for (final memory in memories) memory.title: memory};

    expect(byTitle['O começo']?.audioPath, 'assets/audio/yellow.mpeg');
    expect(byTitle['O começo']?.audioStart, const Duration(seconds: 32));
    expect(
      byTitle['Um dia guardado']?.audioStart,
      const Duration(minutes: 2, seconds: 36),
    );
    expect(
      byTitle['marcando']?.audioPath,
      'assets/audio/voce_nao_ama_ninguem.mpeg',
    );
    expect(
      byTitle['melhor foto akaka']?.audioPath,
      'assets/audio/deixe_me_ir.mpeg',
    );
    expect(
      byTitle['Te amo, loirinha']?.audioPath,
      'assets/audio/aqueles_olhos.mpeg',
    );
  });
}
