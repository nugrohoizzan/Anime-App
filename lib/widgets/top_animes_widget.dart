import 'package:project152_162/api/get_anime_by_ranking_type_api.dart';
import 'package:project152_162/core/screens/error_screen.dart';
import 'package:project152_162/core/widgets/loader.dart';
import 'package:project152_162/widgets/top_animes_image_slider.dart';
import 'package:flutter/material.dart';

class TopAnimesList extends StatelessWidget {
  const TopAnimesList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getAnimeByRankingTypeApi(rankingType: 'all', limit: 4),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        if (snapshot.data != null) {
          final animes = snapshot.data!.toList();
          // return data
          return TopAnimesImageSlider(animes: animes);
        }

        return ErrorScreen(error: snapshot.error.toString());
      },
    );
  }
}
