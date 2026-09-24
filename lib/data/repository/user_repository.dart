import 'package:hive/hive.dart';
import 'package:todo_app/data/model/user_model.dart';

class UserRepository {
  UserRepository(this._box);

  static const String _profileKey = 'profile';

  final Box<UserModel> _box;

  UserModel? get user => _box.get(_profileKey);

  bool get hasProfile => user != null;

  Future<void> saveFullName(String fullName) async {
    await _box.put(_profileKey, UserModel(fullName: fullName.trim()));
  }
}
