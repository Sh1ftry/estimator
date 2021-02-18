import 'package:flutter/widgets.dart';
import 'package:estimator/screens/configuration.dart';
import 'package:estimator/screens/join_session.dart';
import 'package:estimator/screens/start_session.dart';
import 'package:estimator/screens/task_voting.dart';
import 'package:estimator/screens/tasks_list.dart';
import 'package:estimator/screens/voting_results.dart';

final Map<String, WidgetBuilder> routes = {
  '/start': (context) => StartSession(),
  '/join': (context) => JoinSession(),
  '/config': (context) => Configuration(),
  '/tasks': (context) => TaskList(),
  '/vote/host': (context) => TaskVoting(isHost: true),
  '/vote/user': (context) => TaskVoting(isHost: false),
  '/results/host': (context) => VotingResults(isHost: true),
  '/results/user': (context) => VotingResults(isHost: false),
};