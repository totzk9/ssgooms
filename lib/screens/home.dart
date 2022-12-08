import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../routes/pages.dart';
import '../services/nhost_service.dart';
import '../viewmodels/students_viewmodel.dart';
import '../viewmodels/electionviewmodel.dart';
import '../viewmodels/eventsviewmodel.dart';
import '../viewmodels/homeviewmodel.dart';
import 'pages/students.dart';
import 'pages/election.dart';
import 'pages/events.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _MainScaffold(
      child: Selector<HomeViewModel, int>(
        selector: (_, HomeViewModel viewModel) => viewModel.index,
        builder: (_, int index, __) {
          return IndexedStack(
            index: index,
            children: <Widget>[
              ChangeNotifierProvider<EventsViewModel>(
                create: (BuildContext context) => EventsViewModel(),
                child: const EventsView(),
              ),
              ChangeNotifierProvider<StudentsViewModel>(
                create: (BuildContext context) => StudentsViewModel(),
                child: const StudentsView(),
              ),
              ChangeNotifierProvider<ElectionViewModel>(
                create: (BuildContext context) => ElectionViewModel(),
                child: const ElectionView(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MainScaffold extends StatelessWidget {
  const _MainScaffold({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          const _NavBar(),
          Container(
            width: 1,
            decoration: const BoxDecoration(
              color: Colors.grey,
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  const _NavBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Selector<HomeViewModel, int>(
      selector: (_, HomeViewModel viewModel) => viewModel.index,
      builder: (_, int index, __) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: NavigationRail(
            leading: Text(
              'SSGO-OMS\nAdmin Portal',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                label: Text('Events'),
                icon: Icon(Icons.event),
              ),
              NavigationRailDestination(
                label: Text('Attendance'),
                icon: Icon(Icons.check_box),
              ),
              NavigationRailDestination(
                label: Text('Election'),
                icon: Icon(Icons.local_police),
              ),
              NavigationRailDestination(
                label: Text('Logout'),
                icon: Icon(Icons.logout),
              ),
            ],
            selectedIndex: index,
            onDestinationSelected: (int i) =>
                context.read<HomeViewModel>().onIndexSelected(i),
          ),
        );
      },
    );
  }
}
