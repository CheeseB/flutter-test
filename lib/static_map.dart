import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class StaticMapSample extends StatelessWidget {
  final String staticMapUrl;

  StaticMapSample({super.key})
      : staticMapUrl =
            'https://maps.googleapis.com/maps/api/staticmap?center=38.097418,127.072470&zoom=20&size=600x600&maptype=satellite&key=${dotenv.env['GOOGLE_MAPS_API_KEY']}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Static Map Sample'),
      ),
      body: Center(
        child: Image.network(
          staticMapUrl,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child,
              ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            return const Text('Failed to load map image');
          },
        ),
      ),
    );
  }
}
