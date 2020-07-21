import 'package:flutter/material.dart';
import 'package:insta/providers/stories_provider.dart';
import 'package:insta/widgets/story.dart';
import 'package:provider/provider.dart';

class StoriesList extends StatelessWidget {
  Widget _storiesList(StoriesProvider storiesData) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: storiesData.stories.length + 1,
      itemBuilder: (_, index) =>
          Story(index == 0 ? null : storiesData.stories[index - 1]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storiesData = Provider.of<StoriesProvider>(context, listen: false);
    final _height = MediaQuery.of(context).size.longestSide;

    return Container(
      height: _height * 0.104,
      child: storiesData.stories.isNotEmpty
          ? _storiesList(storiesData)
          : FutureBuilder(
              future: storiesData.fetchStories(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                if (snapshot.error != null)
                  return Center(
                    child: Text("Error fetching stories!"),
                  );
                return _storiesList(storiesData);
              },
            ),
    );
  }
}
