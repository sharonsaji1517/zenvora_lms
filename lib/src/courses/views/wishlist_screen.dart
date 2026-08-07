import 'package:flutter/material.dart';
import '../../home/view_models/home_view_model.dart';
import '../../home/views/widgets/featured_courses_list.dart';
import '../../../../core/theme/app_theme.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  late final HomeViewModel _viewModel;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _viewModel = HomeViewModel();
    _viewModel.loadHomeData();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.brandBackgroundGradientOf(context),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppTheme.brandThreeColorGradientOf(context),
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            'Wishlist',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        body: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, child) {
            if (_viewModel.isLoading) {
              return Center(
                child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary),
              );
            }
            if (_viewModel.errorMessage != null) {
              return Center(
                child: Text(_viewModel.errorMessage!),
              );
            }

            final favoriteCourses = _viewModel.courses.where((c) => c.isFavorite).toList();

            if (favoriteCourses.isEmpty) {
              return const Center(
                child: Text(
                  'Your wishlist is empty.',
                  style: TextStyle(color: AppTheme.textLight, fontSize: 16),
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: FeaturedCoursesList(
                viewModel: _viewModel,
                courses: favoriteCourses,
              ),
            );
          },
        ),
      ),
    );
  }
}
