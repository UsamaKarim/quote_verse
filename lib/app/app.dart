import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quote_verse/app/features/quotes/data/datasources/quotes_data_source.dart';
import 'package:quote_verse/app/features/quotes/data/datasources/quotes_local_data_source_impl.dart';
import 'package:quote_verse/app/features/quotes/data/repositories/quotes_repository_impl.dart';
import 'package:quote_verse/app/features/quotes/domain/repositories/quotes_repository.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/add_quote.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/get_all_quotes.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/get_favorite_quotes.dart';
import 'package:quote_verse/app/features/quotes/domain/usecases/toggle_favorite.dart';
import 'package:quote_verse/app/features/quotes/presentation/bloc/add_quote/add_quote_bloc.dart';
import 'package:quote_verse/app/features/quotes/presentation/bloc/favorites/favorites_bloc.dart';
import 'package:quote_verse/app/features/quotes/presentation/bloc/quotes/quotes_bloc.dart';
import 'package:quote_verse/app/features/quotes/presentation/pages/add_quote_page.dart';
import 'package:quote_verse/app/features/quotes/presentation/pages/favorite_quotes_page.dart';
import 'package:quote_verse/app/features/quotes/presentation/pages/quotes_list_page.dart';
import 'package:toastification/toastification.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<QuotesDataSource>(
          create: (context) => QuotesLocalDataSourceImpl(),
        ),
        RepositoryProvider<QuotesRepository>(
          create: (context) => QuotesRepositoryImpl(
            dataSource: context.read<QuotesDataSource>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<QuotesBloc>(
            create: (context) => QuotesBloc(
              getAllQuotes: GetAllQuotes(context.read<QuotesRepository>()),
            )..add(const LoadQuotes()),
          ),
          BlocProvider<FavoritesBloc>(
            create: (context) => FavoritesBloc(
              getFavoriteQuotes: GetFavoriteQuotes(
                context.read<QuotesRepository>(),
              ),
              toggleFavorite: ToggleFavorite(
                context.read<QuotesRepository>(),
              ),
            )..add(const LoadFavorites()),
          ),
          BlocProvider<AddQuoteBloc>(
            create: (context) => AddQuoteBloc(
              addQuote: AddQuote(context.read<QuotesRepository>()),
            ),
          ),
        ],
        child: ToastificationWrapper(
          config: const ToastificationConfig(
            maxToastLimit: 3,
          ),
          child: MaterialApp(
            title: 'Quote Verse',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepPurple,
              ),
              useMaterial3: true,
              textTheme: GoogleFonts.interTextTheme(),
              appBarTheme: AppBarTheme(
                centerTitle: true,
                elevation: 0,
                scrolledUnderElevation: 1,
                titleTextStyle: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            home: const HomePage(),
          ),
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Quote Verse',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(
              context,
            ).colorScheme.onSurfaceVariant,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(
                icon: Icon(Icons.format_quote),
                text: 'All Quotes',
              ),
              Tab(
                icon: Icon(Icons.favorite),
                text: 'Favorites',
              ),
              Tab(
                icon: Icon(Icons.add),
                text: 'Add Quote',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            QuotesListPage(),
            FavoriteQuotesPage(),
            AddQuotePage(),
          ],
        ),
      ),
    );
  }
}
