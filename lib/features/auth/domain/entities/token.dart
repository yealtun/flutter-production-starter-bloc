/// Authentication token entity
class Token {
  const Token({
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn,
  });

  final String accessToken;
  final String refreshToken;
  final int? expiresIn;

  Token copyWith({
    String? accessToken,
    String? refreshToken,
    int? expiresIn,
  }) {
    return Token(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresIn: expiresIn ?? this.expiresIn,
    );
  }
}
