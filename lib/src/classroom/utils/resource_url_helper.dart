class ResourceUrlHelper {
  static const String serverHost = 'https://zen.trynet.work';

  /// Resolves any resource URL (relative or absolute) to a full, valid URL.
  static String resolveUrl(String? url) {
    if (url == null || url.trim().isEmpty) {
      return '';
    }

    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    if (trimmed.startsWith('/')) {
      return '$serverHost$trimmed';
    }

    return '$serverHost/$trimmed';
  }
}
