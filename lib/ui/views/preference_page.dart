import 'package:flutter/material.dart';
import 'package:flutter_app/themes/elab-themes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PreferencePage extends StatelessWidget {
  const PreferencePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
        flexibleSpace: Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: ThemeKeys.values.length,
        itemBuilder: (context, index) {
          // Enums expose their values as a list - perfect for ListView
          // Store the theme for the current ListView item
          final itemAppTheme = ThemeKeys.values[index];
          return Card(
            // Style the cards with the to-be-selected theme colors
            color: ElabThemes.getThemeFromKey(itemAppTheme).primaryColor,
            child: ListTile(
              title: Text(
                itemAppTheme.toString(),
                // To show light text with the dark variants...
                style: ElabThemes.getThemeFromKey(itemAppTheme).textTheme.body1,
              ),
              onTap: () {
                // This will make the Bloc output a new ThemeState,
                // which will rebuild the UI because of the BlocBuilder in main.dart
                BlocProvider.of<ThemeBloc>(context)
                    .dispatch(ThemeChanged(theme: itemAppTheme));
              },
            ),
          );
        },
      ),
    );
  }
}