import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:venture/login.dart';
import 'package:venture/main.dart';
import 'package:venture/saved_places_manager.dart';

class Authgate extends StatelessWidget {
  const Authgate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final session = snapshot.hasData ? snapshot.data!.session : null;

        if (session != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final savedPlacesManager = Provider.of<SavedPlacesManager>(
              context,
              listen: false,
            );
            savedPlacesManager.loadSavedPlaces();
          });
          return Home();
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final savedPlacesManager = Provider.of<SavedPlacesManager>(
              context,
              listen: false,
            );
            savedPlacesManager.clearSavedPlaces();
          });
          return Loginpg();
        }
      },
    );
  }
}
