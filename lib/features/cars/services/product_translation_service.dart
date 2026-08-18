import 'package:google_mlkit_language_id/google_mlkit_language_id.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';

class ProductTranslationService {
  final LanguageIdentifier _languageIdentifier =
  LanguageIdentifier(confidenceThreshold: 0.5);

  final OnDeviceTranslatorModelManager _modelManager =
  OnDeviceTranslatorModelManager();

  bool _modelsChecked = false;

  /// Detects whether the given text is Arabic or English.
  /// Returns 'ar' or 'en'.
  Future<String?> detectLanguage(String text) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty) {
      return null;
    }

    final detectedLanguage =
    await _languageIdentifier.identifyLanguage(cleanText);

    if (detectedLanguage == 'ar') {
      return 'ar';
    }

    if (detectedLanguage == 'en') {
      return 'en';
    }

    return null;
  }

  /// Makes sure that both Arabic and English translation
  /// models are available on the device.
  Future<void> ensureModelsDownloaded() async {
    if (_modelsChecked) {
      return;
    }

    final arabicDownloaded = await _modelManager.isModelDownloaded(
      TranslateLanguage.arabic.bcpCode,
    );

    if (!arabicDownloaded) {
      await _modelManager.downloadModel(
        TranslateLanguage.arabic.bcpCode,
      );
    }

    final englishDownloaded = await _modelManager.isModelDownloaded(
      TranslateLanguage.english.bcpCode,
    );

    if (!englishDownloaded) {
      await _modelManager.downloadModel(
        TranslateLanguage.english.bcpCode,
      );
    }

    _modelsChecked = true;
  }

  /// Translates Arabic text to English.
  Future<String> translateArabicToEnglish(String text) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty) {
      return '';
    }

    await ensureModelsDownloaded();

    final translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.arabic,
      targetLanguage: TranslateLanguage.english,
    );

    try {
      return await translator.translateText(cleanText);
    } finally {
      await translator.close();
    }
  }

  /// Translates English text to Arabic.
  Future<String> translateEnglishToArabic(String text) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty) {
      return '';
    }

    await ensureModelsDownloaded();

    final translator = OnDeviceTranslator(
      sourceLanguage: TranslateLanguage.english,
      targetLanguage: TranslateLanguage.arabic,
    );

    try {
      return await translator.translateText(cleanText);
    } finally {
      await translator.close();
    }
  }

  /// Automatically detects Arabic/English and translates
  /// the text to the other language.
  Future<TranslatedText> translateAutomatically(String text) async {
    final cleanText = text.trim();

    if (cleanText.isEmpty) {
      throw Exception('Cannot translate empty text.');
    }

    final detectedLanguage = await detectLanguage(cleanText);

    if (detectedLanguage == null) {
      throw Exception(
        'Could not determine whether the text is Arabic or English.',
      );
    }

    if (detectedLanguage == 'ar') {
      final english = await translateArabicToEnglish(cleanText);

      return TranslatedText(
        arabic: cleanText,
        english: english,
        sourceLanguage: 'ar',
      );
    }

    final arabic = await translateEnglishToArabic(cleanText);

    return TranslatedText(
      arabic: arabic,
      english: cleanText,
      sourceLanguage: 'en',
    );
  }

  /// Releases ML Kit resources.
  Future<void> dispose() async {
    await _languageIdentifier.close();
  }
}

class TranslatedText {
  final String arabic;
  final String english;
  final String sourceLanguage;

  const TranslatedText({
    required this.arabic,
    required this.english,
    required this.sourceLanguage,
  });
}