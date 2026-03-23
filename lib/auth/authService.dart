//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Authservice {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<AuthResponse> signIn(String email, String pass) async {
    return await supabase.auth.signInWithPassword(email: email, password: pass);
  }

  Future<AuthResponse> signUp(String email, String pass) async {
    return await supabase.auth.signUp(email: email, password: pass);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  Future<void> signInWithGoogle() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter://login-callback/',
    );
  }

  Future<void> signInWithFacebook() async {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.facebook,
      redirectTo: 'io.supabase.flutter://login-callback/',
    );
  }

  String? getEmail() {
    final session = supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }

  Future<void> nativeGoogleSignIn() async {
    final webClientId =
        '20597873317-k0t4iuk1l1n4vlvukuin718n3iuo324g.apps.googleusercontent.com';
    final iosClientId =
        '20597873317-f1jlv9g33kft0mbcooo5h7034amb8ctn.apps.googleusercontent.com';

    final googleSignIn = GoogleSignIn(
      clientId: iosClientId,
      serverClientId: webClientId,
    );

    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No access token found.';
    }

    if (idToken == null) {
      throw 'No ID token found.';
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
    final userId = supabase.auth.currentUser?.id;
    final newUserData = supabase.auth?.currentUser?.userMetadata;
    Future<void> insertData() async {
      await supabase.from('user_profiles').upsert({
        'id': userId,
        'name': newUserData?['full_name'],
        'email': newUserData?['email'],
        'profile_picture_url': newUserData?['avatar_url'],
      });
    }

    await insertData();
  }
}
