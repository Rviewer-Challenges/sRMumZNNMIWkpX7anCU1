import '../../../../objectbox.g.dart';

class AppDatabase {
  static final AppDatabase appDatabase = AppDatabase();

  late Store _store;
  Store get store => _store;

  void open() async => _store = await openStore();

  void close() => _store.close();
}
