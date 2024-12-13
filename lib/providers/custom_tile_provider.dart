import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../constants/map.dart';

class CustomTileProvider extends TileProvider {
  @override
  Future<Tile> getTile(int x, int y, int? zoom) async {
    final url = '$mapTileUrl&x=$x&y=$y&z=$zoom';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Tile(mapTileWidth, mapTileHeight, response.bodyBytes);
    }
    return TileProvider.noTile;
  }
}
