import 'package:shared_preferences/shared_preferences.dart';

import '/constants/constants.dart';

class DatabaseHelper {
  // Memba=uat kelas ini menjadi singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static SharedPreferences? _database;

  //! get Database
  Future<SharedPreferences> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  //! inisialisasi Shared Preferences
  Future<SharedPreferences> _initDatabase() async {
    _database = await SharedPreferences.getInstance();
    return _database!;
  }

  // setters dan getters theme mode
  Future<bool> get isDarkMode async {
    final db = await instance.database;
    return db.getBool(Constants.isDarkMode) ?? false;
  }

  Future<bool> setDarkMode(bool isDark) async {
    final db = await instance.database;
    return await db.setBool(Constants.isDarkMode, isDark);
  }

  // setters dan getters anime title language
  Future<bool> get isEnglish async {
    final db = await instance.database;
    return db.getBool(Constants.isEnglish) ?? false;
  }

  Future<bool> setIsEnglish(bool isEnglish) async {
    final db = await instance.database;
    return await db.setBool(Constants.isEnglish, isEnglish);
  }
// Fungsi untuk mendapatkan path gambar logo sesuai dengan tema yang aktif
  Future<String> getLogoImagePath() async {
    final isDarkMode = await this.isDarkMode;
    final imageName = isDarkMode ? 'anime_logo1.png' : 'anime_logo.png';
    return 'assets/images/$imageName';
  }
}
