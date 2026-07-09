class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String photoUrl;
  final String loginMethod; // 'email' or 'google'

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.photoUrl,
    required this.loginMethod,
  });

  UserProfile copyWith({
    String? uid,
    String? displayName,
    String? email,
    String? photoUrl,
    String? loginMethod,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      loginMethod: loginMethod ?? this.loginMethod,
    );
  }
}
