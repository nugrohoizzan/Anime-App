import 'package:flutter/material.dart';
import 'package:project152_162/views/featured_animes.dart';

import '/common/extensions/extensions.dart';
import '/common/utils/utils.dart';
import '/common/styles/paddings.dart';
import '/screens/home_screen.dart';
import '/widgets/seasonal_anime_view.dart';
import '/widgets/top_animes_list.dart';
import '/database_helper/database_helper.dart'; 

class AnimesScreen extends StatefulWidget {
  const AnimesScreen({Key? key}) : super(key: key);

  @override
  State<AnimesScreen> createState() => _AnimesScreenState();
}

class _AnimesScreenState extends State<AnimesScreen> {
  late Future<String> _logoImagePathFuture;

  @override
  void initState() {
    super.initState();
    _logoImagePathFuture = _setLogoImagePath();
  }

  // function untuk set logo sesuai tema
  Future<String> _setLogoImagePath() async {
    return await DatabaseHelper.instance.getLogoImagePath();
  }

  @override
  Widget build(BuildContext context) {
    final currentSeason = getCurrentSeason().capitalize();
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: _logoImagePathFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); 
            } else if (snapshot.hasError) {
              return const Text('Error loading logo'); 
            } else if (snapshot.hasData) {
              return Image.asset(
                snapshot.data!,
                width: 100,
              );
            } else {
              return const Text('Welcome to Animek'); 
            }
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(
                HomeScreen.routeName,
                arguments: 1,
              );
            },
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          
          setState(() {
            _logoImagePathFuture = _setLogoImagePath();
          });
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              // top Anime Slider
              const SizedBox(
                height: 300,
                child: TopAnimesList(),
              ),

              Padding(
                padding: Paddings.noBottomPadding,
                child: Column(
                  children: [
                    // top Ranked anime
                    const SizedBox(
                      height: 350,
                      child: FeaturedAnimes(
                        rankingType: 'all',
                        label: 'Top Ranked',
                      ),
                    ),

                    // top popular anime
                    const SizedBox(
                      height: 350,
                      child: FeaturedAnimes(
                        rankingType: 'bypopularity',
                        label: 'Top Popular',
                      ),
                    ),

                    // top Movie Anime
                    const SizedBox(
                      height: 350,
                      child: FeaturedAnimes(
                        rankingType: 'movie',
                        label: 'Top Movie Anime',
                      ),
                    ),

                    // top upcoming anime
                    const SizedBox(
                      height: 350,
                      child: FeaturedAnimes(
                        rankingType: 'upcoming',
                        label: 'Top Upcoming Anime',
                      ),
                    ),

                    // top movie anime
                    SizedBox(
                      height: 350,
                      child: SeasonalAnimeView(
                        label: 'Top Anime this $currentSeason',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
