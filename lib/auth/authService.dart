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
}
