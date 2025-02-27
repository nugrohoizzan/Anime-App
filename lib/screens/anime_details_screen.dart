import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import '/api/get_anime_details_api.dart';
import '/common/extensions/extensions.dart';
import '/common/styles/paddings.dart';
import '/common/styles/text_styles.dart';
import '/common/widgets/ios_back_button.dart';
import '/common/widgets/network_image_view.dart';
import '/common/widgets/read_more_text.dart';
import '/core/screens/error_screen.dart';
import '/core/widgets/loader.dart';
import '/cubits/anime_title_language_cubit.dart';
import '/models/anime_details.dart';
import '/models/picture.dart';
import 'package:project152_162/models/anime_model.dart';
import '../views/anime_horizontal_list_view.dart';

class AnimeDetailsScreen extends StatelessWidget {
  const AnimeDetailsScreen({Key? key, required this.id}) : super(key: key);

  final int id;

  static const routeName = '/anime-details';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AnimeDetails>(
      future: getAnimeDetailsApi(id: id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        if (snapshot.data != null) {
          final anime = snapshot.data!;
          return Scaffold(
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: Paddings.defaultPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAnimeImage(imageUrl: anime.mainPicture.large),
                        const SizedBox(height: 20),
                        // title
                        _buildAnimeName(
                          defaultName: anime.title,
                          englishName: anime.alternativeTitles.en,
                        ),
                        const SizedBox(height: 20),
                        // deskripsi
                        ReadMoreText(longText: anime.synopsis),
                        const SizedBox(height: 10),
                        _buildAnimeInfo(anime: anime),
                        const SizedBox(height: 20),
                        if (anime.background.isNotEmpty)
                          _buildAnimeBackground(background: anime.background),
                        const SizedBox(height: 20),
                        _buildAnimeImages(pictures: anime.pictures),
                        const SizedBox(height: 20),
                        // related anime
                        AnimeHorizontalListView(
                          title: 'Related Animes',
                          animes: anime.relatedAnime.map((relatedAnime) => relatedAnime.node).toList(),
                        ),
                        const SizedBox(height: 20),
                        // recommendasi
                        AnimeHorizontalListView(
                          title: 'Recommendations',
                          animes: anime.recommendations.map((recommendation) => recommendation.node).toList(),
                        ),
                        const SizedBox(height: 80), // Extra space for button
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  right: 20,
                  child: ElevatedButton(
                    onPressed: () async {
                      final box = Hive.box<Anime>('watchlistBox');
                      final animeToAdd = Anime(
                        id: anime.id,
                        title: anime.title,
                        imageUrl: anime.mainPicture.large,
                        numEpisodes: anime.numEpisodes,
                        genres: anime.genres.map((genre) => genre.name).join(', '),
                        year: anime.startDate.substring(0, 4),
                      );
                      await box.put(anime.id, animeToAdd);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${anime.title} added to watchlist')),
                      );
                    },
                    child: Text('Add to Watchlist'),
                  ),
                ),
              ],
            ),
          );
        }

        return ErrorScreen(error: snapshot.error.toString());
      },
    );
  }

  Widget _buildAnimeImage({required String imageUrl}) => Stack(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            height: 400,
            width: double.infinity,
          ),
          Positioned(
            top: 30,
            left: 20,
            child: Builder(
              builder: (context) {
                return IosBackButton(onPressed: Navigator.of(context).pop);
              },
            ),
          ),
        ],
      );

  Widget _buildAnimeName({required String englishName, required String defaultName}) => BlocBuilder<AnimeTitleLanguageCubit, bool>(
        builder: (context, state) {
          return Text(
            state ? englishName : defaultName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          );
        },
      );

  Widget _buildAnimeInfo({required AnimeDetails anime}) {
    String studios = anime.studios.map((studio) => studio.name).join(', ');
    String genres = anime.genres.map((genre) => genre.name).join(', ');
    String otherNames = anime.alternativeTitles.synonyms.map((title) => title).join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InfoText(label: 'Genres: ', info: genres),
        InfoText(label: 'Start date: ', info: anime.startDate),
        InfoText(label: 'End date: ', info: anime.endDate),
        InfoText(label: 'Episodes: ', info: anime.numEpisodes.toString()),
        InfoText(label: 'Average Episode Duration: ', info: anime.averageEpisodeDuration.toMinute()),
        InfoText(label: 'Status: ', info: anime.status),
        InfoText(label: 'Rating: ', info: anime.rating),
        InfoText(label: 'Studios: ', info: studios),
        InfoText(label: 'Other Names: ', info: otherNames),
        InfoText(label: 'English Name: ', info: anime.alternativeTitles.en),
        InfoText(label: 'Japanese Name: ', info: anime.alternativeTitles.ja),
      ],
    );
  }

  Widget _buildAnimeBackground({required String background}) => WhiteContainer(
        child: Text(
          background,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
        ),
      );

  Widget _buildAnimeImages({required List<Picture> pictures}) => Column(
        children: [
          Text('Image Gallery', style: TextStyles.smallText),
          GridView.builder(
            itemCount: pictures.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 9 / 16,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final image = pictures[index].medium;
              final largeImage = pictures[index].large;
              return SizedBox(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        NetworkImageView.routeName,
                        arguments: largeImage,
                      );
                    },
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      );
}

class InfoText extends StatelessWidget {
  const InfoText({Key? key, required this.label, required this.info}) : super(key: key);

  final String label;
  final String info;

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          text: label,
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: info,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
}

class WhiteContainer extends StatelessWidget {
  const WhiteContainer({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(15.0),
        color: Colors.white54,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: child,
        ),
      );
}
