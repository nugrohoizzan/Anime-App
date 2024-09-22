import 'package:project152_162/common/styles/paddings.dart';
import 'package:project152_162/models/anime.dart';
import 'package:project152_162/widgets/anime_list_title.dart';
import 'package:flutter/material.dart';

class RankedAnimesListView extends StatelessWidget {
  const RankedAnimesListView({
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
