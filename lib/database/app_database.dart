import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// Bảng tài khoản
class Accounts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get email => text().withLength(min: 5, max: 100)();
  TextColumn get password => text()();
  TextColumn get role => text().withDefault(Constant('user'))();
}

// Bảng sản phẩm (bảng mới thêm)
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  RealColumn get price => real()();
}

@DriftDatabase(tables: [Accounts, Products])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onUpgrade: (migrator, from, to) async {
      if (from == 1) {
        await migrator.createTable(products);
      }
    },
    beforeOpen: (details) async {
      // Bạn có thể thêm logic nếu cần trước khi mở DB
    },
  );

  // CRUD cho bảng accounts
  Future<List<Account>> getAllAccounts() => select(accounts).get();
  Future<int> insertAccount(AccountsCompanion entry) => into(accounts).insert(entry);
  Future<Account?> getByEmailAndPassword(String email, String password) {
    return (select(accounts)
      ..where((tbl) => tbl.email.equals(email) & tbl.password.equals(password)))
        .getSingleOrNull();
  }

  // CRUD cho bảng products
  Future<List<Product>> getAllProducts() => select(products).get();
  Future<int> insertProduct(ProductsCompanion entry) => into(products).insert(entry);
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'efb_db.sqlite'));
    return NativeDatabase(file);
  });
}
