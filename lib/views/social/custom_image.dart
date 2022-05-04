import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget cachedNetworkImage(String mediaURL) {
  return CachedNetworkImage(
    imageUrl: mediaURL,
    fit: BoxFit.cover,
    placeholder: (context, url) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: CircularProgressIndicator(),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

Widget imageEmpty() {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Icon(
      Icons.add_a_photo,
      size: 100.0,
      color: Color.fromARGB(255, 187, 187, 187),
    ),
  );
}
