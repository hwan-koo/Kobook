class StoryConfigModel {
  String story;
  String age;
  String thema;
  String faceUrl;
  String name;
  String paintingStyle;
  String cloth;
  List<String> imaginePlus;

  StoryConfigModel(
      {required this.story,
      required this.thema,
      required this.imaginePlus,
      required this.age,
      required this.cloth,
      required this.faceUrl,
      required this.name,
      required this.paintingStyle});
}
