
//Model class which contains list of images url
class ListOfImages {
  List<String> urls;

  //Default constructor
  ListOfImages() : urls = [];

  //Build list of images from json
  ListOfImages.fromJson(List<dynamic> data){
    urls = [];
    data.forEach((element) {
      if (element is String)
        urls.add(element);
    });
  }

  //Convert list of images to json map
  List<dynamic> toJson() {
    return urls;
  }
}
