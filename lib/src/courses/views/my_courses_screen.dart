import 'package:flutter/material.dart';
import '../../home/view_models/home_view_model.dart';
import '../../home/views/widgets/left_navigation_drawer.dart';
import '../../home/views/widgets/featured_courses_list.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/routes/app_routes.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
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
      decoration: const BoxDecoration(
        gradient: AppTheme.brandBackgroundGradient,
      ),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        drawer: const LeftNavigationDrawer(activeRoute: AppRoutes.myCourses),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          titleSpacing: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.brandThreeColorGradient,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: const Text(
            'My Courses',
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
              return const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryBlue),
              );
            }
            if (_viewModel.errorMessage != null) {
              return Center(
                child: Text(_viewModel.errorMessage!),
              );
            }
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: FeaturedCoursesList(
                viewModel: _viewModel,
                courses: _viewModel.courses,
              ),
            );
          },
        ),
      ),
    );
  }
}
