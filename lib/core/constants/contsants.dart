import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

String? token;
String? userId;
const String baseUrl = "https://almustarih.com/";
void openGoogleMap(double lat, double lng) async {
  Uri googleMapUrl = Uri.parse(
    "https://www.google.com/maps/search/?api=1&query=$lat,$lng",
  );

  if (!await launchUrl(googleMapUrl)) {
    throw Exception('Could not launch $googleMapUrl');
  } else {
    throw 'Could not open the map.';
  }
}

Future<void> launchPDF({required String pdfUrl}) async {
  Uri url = Uri.parse(pdfUrl);
  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw "Could not launch $pdfUrl";
  }
}

bool isIPad(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final shortestSide = size.shortestSide;
  return shortestSide >= 600;
}

void shareLocation(double lat, double lng) {
  String location = 'Latitude: $lat, Longitude: $lng';
  Share.share(location);
}

Future<void> openWhatsApp(String phoneNumber) async {
  final Uri launchUri = Uri.parse("https://wa.me/$phoneNumber");
  await launchUrl(launchUri);
}
