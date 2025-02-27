import 'package:flutter/material.dart';

import '/common/styles/paddings.dart';
import 'package:project152_162/widgets/anime_list_title.dart';
import '/models/anime.dart';

class AnimeListView extends StatelessWidget {
  const AnimeListView({
    super.key,
    required this.animes,
  });

  final Iterable<Anime> animes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Paddings.defaultPadding,
      child: ListView.builder(
        itemCount: animes.length,
        itemBuilder: (context, index) {
          final anime = animes.elementAt(index);
          return AnimeListTile(
            anime: anime,
          );
        },
      ),
    );
  }
}
