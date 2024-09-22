import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project152_162/models/anime_model.dart';

class WatchListScreen extends StatefulWidget {
  const WatchListScreen({super.key});

  static const routeName = '/watchlist';

  @override
  State<WatchListScreen> createState() => _WatchListScreenState();
}

class _WatchListScreenState extends State<WatchListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist'),
      ),
      body: ValueListenableBuilder<Box<Anime>>(
        valueListenable: Hive.box<Anime>('watchlistBox').listenable(),
        builder: (context, box, _) {
          final animes = box.values.toList().cast<Anime>();

          if (animes.isEmpty) {
            return const Center(
              child: Text('No anime in your watchlist.'),
            );
          }

          return ListView.builder(
            itemCount: animes.length,
            itemBuilder: (context, index) {
              final anime = animes[index];
              return ListTile(
                leading: anime.imageUrl != null && anime.imageUrl.isNotEmpty
                    ? Image.network(anime.imageUrl)
                    : const Icon(Icons.image_not_supported),
                title: Text(anime.title),
                subtitle: Text('Episodes: ${anime.numEpisodes}, Genres: ${anime.genres}, Year: ${anime.year}'),
                trailing: IconButton(
                  icon: const Icon(Icons.remove_circle),
                  onPressed: () {
                    anime.delete();
                    setState(() {});
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
