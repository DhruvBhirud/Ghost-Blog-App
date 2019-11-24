import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ghost_content_api/flutter_ghost_content_api.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:html/dom.dart' as dom;

class Post extends StatelessWidget {

  static const String route = '/post';

  final PostPage post;

  Post({Key key, @required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Widget _backButton(Color color) {
      return IconButton(
        color: color,
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }

    Widget _shareButton(Color color) {
      return IconButton(
        color: color,
        icon: Icon(Icons.share),
        onPressed: () {
          Share.share(post.title + " " + post.url);
        },
      );
    }

    Widget _buildFeatureImageHeader() {
      return Stack(
        children: <Widget>[
          Container(
            height: 250.0,
            decoration: BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: NetworkImage(post.featureImage),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Container(
            height: 250.0,
            decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.0),
                  Colors.black.withOpacity(0.8),
                ],
                stops: [
                  0.6,
                  1.0,
                ],
              ),
            ),
            child: Text(
              post.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1.0, 1.0),
                      blurRadius: 1.0,
                    ),
                  ]
              ),
            ),
            alignment: Alignment.bottomLeft,
            padding: EdgeInsets.only(left: 16.0, bottom: 16.0,),
          ),

          Positioned(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _backButton(Colors.white),
                _shareButton(Colors.white),
              ],
            ),
          ),
        ],
      );
    }

    Widget _buildHeader() {
      return Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _backButton(Colors.black),
              _shareButton(Colors.black),
            ],
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0,),
            child: Text(
              post.title,
              style: Theme.of(context).textTheme.title,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: ListView(
        children: <Widget>[
          post.featureImage != null ? _buildFeatureImageHeader() : _buildHeader(),

          Html(
            data: post.html,
            padding: EdgeInsets.all(16.0),
            backgroundColor: Colors.white70,
            defaultTextStyle: TextStyle(
                height: 1.25,
                fontFamily: 'inherit'
            ),
            linkStyle: const TextStyle(
              color: Colors.teal,
            ),
            useRichText: false,
            customRender: (node, children) {
              var render;
              if(node is dom.Element) {
                switch(node.localName) {
                  case 'figure':
                    render = new Text('');
                }
              }
              return render;
            },
            onLinkTap: (url) async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw '无法打开 $url';
              }
            },
          ),

          Divider(),

          Padding(
            padding: EdgeInsets.all(16.0),
            child: ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(
                  post.primaryAuthor.profileImage,
                ),
                backgroundColor: Colors.transparent,
              ),
              title: Text(post.primaryAuthor.name),
              subtitle: Text(post.primaryAuthor.bio),
            ),
          ),

          Divider(),

          Padding(
            padding: EdgeInsets.all(16.0,),
            child: Center(
              child: FlatButton(
                child: Text("查看源站"),
                onPressed: () async {
                  final String url = post.url;
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw '无法打开 $url';
                  }
                },
                padding: EdgeInsets.all(16.0,),
              ),
            ),
          ),

          Divider(),

          Padding(
            padding: EdgeInsets.all(16.0,),
            child: Center(
              child: FlatButton(
                child: Text("返回"),
                onPressed: () {
                  Navigator.pop(context);
                },
                padding: EdgeInsets.all(16.0,),
              ),
            ),
          ),
        ],
      )
    );
  }
}