// @dart=2.9
//packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/models/search_category.dart';
//Models
import '../models/main_page_data.dart';
import '../models/movie.dart';
//Services
import '../services/movie_service.dart';

class MainPageDataController extends StateNotifier<MainPageData> {
  MainPageDataController([MainPageData state])
      : super(state ?? MainPageData.inital()) {
    getMovies();
  }

  final MovieService movieService = GetIt.instance.get<MovieService>();

  Future<void> getMovies() async {
    try {
      List<Movie> movies = [];

      if (state.searchText.isEmpty) {
        if (state.searchCategory == SearchCategory.popular) {
          movies = await movieService.getPopularMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.upcoming) {
          movies = await movieService.getUpcomingMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.none) {
          movies = [];
        }
      } else {
        movies = await movieService.searchMovies(state.searchText);
      }
      state = state
          .copiWith(movies: [...state.movies, ...movies], page: state.page + 1);
      // ignore: empty_catches
    } catch (e) {}
  }

  void updateSearchCategory(String category) {
    try {
      state = state.copiWith(
          movies: [], page: 1, searchCategory: category, searchText: '');
      getMovies();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  void updateTextSearch(String searchText) {
    try {
      state = state.copiWith(
          movies: [],
          page: 1,
          searchCategory: SearchCategory.none,
          searchText: searchText);
      getMovies();
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
