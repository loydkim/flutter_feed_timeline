import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ------------ Youtube ------------

//Expanded(child: Container()),
//youtubePromotion()

const String youtubeChannelLink = 'https://www.youtube.com/channel/UCLNCErWFQ6LZoaV_JKOq_lQ';

Widget youtubePromotion() {
  return Column(
    children: <Widget>[
      _youtubeTitle(),
      _youtubeLinkTitle(),
      _youtubeLinkAddress(),
      _youtubeImage()
    ],
  );
}

Widget _youtubeTitle() {
  return Padding(
    padding: const EdgeInsets.only(left: 18.0, top: 4),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Loyd Lab (Youtube)',
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

Widget _youtubeLinkTitle() {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0, top: 4),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'Youtube link: ',
        style: TextStyle(fontSize: 16),
      ),
    ),
  );
}

Widget _youtubeLinkAddress() {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0, top: 4),
    child: Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          launchURL();
        },
        child: Text(
          youtubeChannelLink,
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue[700],
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    ),
  );
}

Widget _youtubeImage() {
  return Container(
      height: 160,
      child: Image.asset('images/youtube_screenshot.png')
  );
}

launchURL() async {
  const url = youtubeChannelLink;
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}