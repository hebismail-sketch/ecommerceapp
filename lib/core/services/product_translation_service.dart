import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class ProductTranslationService {
  static final _modelManager = OnDeviceTranslatorModelManager();

  static Future<void> _ensureModelsDownloaded() async {
    await Future.wait([
      _modelManager.downloadModel(TranslateLanguage.arabic.bcpCode),
      _modelManager.downloadModel(TranslateLanguage.english.bcpCode),
    ]);
  }

  static Future<String> translate({
    required String text,
    required bool fromArabic,
  }) async {
    if (text.trim().isEmpty) return '';
    await _ensureModelsDownloaded();

    final translator = OnDeviceTranslator(
      sourceLanguage:
          fromArabic ? TranslateLanguage.arabic : TranslateLanguage.english,
      targetLanguage:
          fromArabic ? TranslateLanguage.english : TranslateLanguage.arabic,
    );

    try {
      return await translator.translateText(text.trim());
    } finally {
      translator.close();
    }
  }

  static Future<List<String>> translateAll({
    required List<String> texts,
    required bool fromArabic,
  }) async {
    await _ensureModelsDownloaded();
    final translator = OnDeviceTranslator(
      sourceLanguage:
          fromArabic ? TranslateLanguage.arabic : TranslateLanguage.english,
      targetLanguage:
          fromArabic ? TranslateLanguage.english : TranslateLanguage.arabic,
    );

    try {
      return [
        for (final text in texts)
          text.trim().isEmpty
              ? ''
              : await translator.translateText(text.trim()),
      ];
    } finally {
      translator.close();
    }
  }
}
