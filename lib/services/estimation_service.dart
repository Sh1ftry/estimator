import 'dart:async';
import 'package:estimator/models/vote.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:rxdart/rxdart.dart';

class EstimationService {
  static final EstimationService _singleton = EstimationService._internal();

  factory EstimationService() {
    return _singleton;
  }

  EstimationService._internal();

  final _sessionCodeSubject = ReplaySubject<String>(maxSize: 1);
  final _taskSubject = ReplaySubject<String>(maxSize: 1);
  final _votesSubject = ReplaySubject<int>(maxSize: 1);
  final _maxVotesSubject = ReplaySubject<int>(maxSize: 1);
  final _estimatesSubject = ReplaySubject<List<String>>(maxSize: 1);
  final _resultsSubject = PublishSubject<List<EstimatorVote>>();
  final _hostLeftSubject = PublishSubject<int>();

  void _onJoined(users) {
    _maxVotesSubject.add(users);
  }

  void _onChanged(task) {
    _taskSubject.add(task);
    _votesSubject.add(0);
  }

  void _onFinished(results) {
    _resultsSubject.add((results as List)
        .map((result) => EstimatorVote(result["name"], result["vote"]))
        .toList());
    _votesSubject.add(0);
  }

  void _onVoted(votes) {
    _votesSubject.add(votes);
  }

  void _onHostLeft(ignore) {
    _hostLeftSubject.add(66);
  }

  void _onUserLeft(users) {
    _maxVotesSubject.add(users);
  }

  void connect() {
    socket.connect();
    socket.on('joined', _onJoined);
    socket.on('changed', _onChanged);
    socket.on('finished', _onFinished);
    socket.on('voted', _onVoted);
    socket.on('host left', _onHostLeft);
    socket.on('user left', _onUserLeft);
  }

  void disconnect() {
    socket.off('joined', _onJoined);
    socket.off('changed', _onChanged);
    socket.off('finished', _onFinished);
    socket.off('voted', _onVoted);
    socket.off('host left', _onHostLeft);
    socket.off('user left', _onUserLeft);
    socket.disconnect();
  }

  Future startSession(String userId, String displayName, String estimates) async {
    Completer c = new Completer();
    socket.emitWithAck(
      'start',
      [userId, displayName, estimates],
      ack: (String sessionCode) {
        _sessionCodeSubject.add(sessionCode);
        _estimatesSubject.add(estimates.split(" "));
        c.complete(sessionCode);
      },
    );
    return c.future.timeout(Duration(seconds: 3));
  }

  Future joinSession(String roomId, String userId, String displayName) async {
    _sessionCodeSubject.add(roomId);
    Completer c = new Completer();
    socket.emitWithAck(
      'join',
      [roomId, userId, displayName],
      ack: (data) {
        _taskSubject.add(data["task"]);
        _maxVotesSubject.add(data["users"]);
        _estimatesSubject.add(data["estimates"].split(" "));
        _votesSubject.add(data["votes"]);
        c.complete(data);
      },
    );
    return c.future.timeout(Duration(seconds: 3));
  }

  void changeTask(String task) {
    socket.emit('change', [task]);
    _taskSubject.add(task);
  }

  void finishVoting() {
    socket.emit('finish');
  }

  void vote(String vote) {
    socket.emit('vote', [vote]);
  }

  Stream<String> get sessionCode {
    return _sessionCodeSubject.stream;
  }

  Stream<String> get task {
    return _taskSubject.stream;
  }

  Stream<int> get votes {
    return _votesSubject.stream;
  }

  Stream<int> get maxVotes {
    return _maxVotesSubject.stream;
  }

  Stream<List<EstimatorVote>> get results {
    return _resultsSubject.stream;
  }

  Stream<List<String>> get estimates {
    return _estimatesSubject.stream;
  }

  Stream<int> get hostLeft {
    return _hostLeftSubject.stream;
  }

  final IO.Socket socket = IO.io(
    'http://estimator.cvapr.xyz:3000',
    OptionBuilder().disableAutoConnect().setTransports(['websocket']).build(),
  );
}
