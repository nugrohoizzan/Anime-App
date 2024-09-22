import 'package:project152_162/api/get_anime_by_ranking_type_api.dart';
import 'package:project152_162/core/screens/error_screen.dart';
import 'package:project152_162/core/widgets/loader.dart';
import 'package:project152_162/models/anime_category.dart';
import 'package:project152_162/views/animes_grid_list.dart';
import 'package:flutter/material.dart';

class AnimeGridView extends StatelessWidget {
  const AnimeGridView({
    super.key,
    required this.category,
  });

  final AnimeCategory category;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAnimeByRankingTypeApi(
        rankingType: category.rankingType,
        limit: 100,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        if (snapshot.data != null) {
          final animes = snapshot.data;

          return AnimesGridList(
            title: category.title,
            animes: animes!,
          );
        }

        return ErrorScreen(error: snapshot.error.toString());
      },
    );
  }
}
