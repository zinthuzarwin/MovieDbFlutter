import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_flutter/movie.dart';

void main() {
  runApp(MaterialApp(home: MovieHomePage()));
}

class MovieHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MovieHomePageState();
  }
}

class MovieHomePageState extends State<MovieHomePage> {
  var url =
      "https://api.themoviedb.org/3/movie/top_rated?api_key=cf98f99f6ea41f7f7a2f4739bec880a8";

  movieDb MovieDb;

  @override
  void initState() {
    super.initState();

    fetchData();
  }

  fetchData() async {
    var data = await http.get(url);

    var jsonData = jsonDecode(data.body);

    MovieDb = movieDb.fromJson(jsonData);

    print(MovieDb.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
        backgroundColor: Colors.blueAccent,
      ),
      body: MovieDb == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: MovieDb.results
                  .map((res) => Padding(
                        padding: EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        new MovieDetails(results: res)));
                          },
                          child: Hero(
                            tag: res.posterPath,
                            child: Card(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    height: 120.0,
                                    child: Image.network(
                                        "https://image.tmdb.org/t/p/w200${res.posterPath}"),
                                  ),
                                  Text(
                                    res.originalTitle,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}

class MovieDetails extends StatelessWidget {
  final Results results;

  MovieDetails({this.results});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        child: Column(children: [
          Stack(
            children: [
              Container(
                height: 400.0,
                width: 400.0,
                child: Image.network(
                    "https://image.tmdb.org/t/p/w200${this.results.posterPath}",
                    fit: BoxFit.fill),
              ),
              AppBar(
                backgroundColor: Colors.transparent,
                leading: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios)),
                elevation: 0,
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(height: 10.0),
                  Text(
                    this.results.originalTitle,
                    style: TextStyle(
                        color: Colors.black87,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.2,
                        wordSpacing: 0.6),
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    this.results.overview,
                    style: TextStyle(
                        color: Colors.black45,
                        fontSize: 16,
                        letterSpacing: 0.2,
                        wordSpacing: 0.3),
                  ),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        this.results.releaseDate == null
                            ? 'Unknown'
                            : this.results.releaseDate,
                        style: TextStyle(color: Colors.grey),
                      ),
                      Text("Rating: "+
                        this.results.voteAverage.toString(),
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  )
                ],
              ))
        ]),
      )),
    );
  }
}
