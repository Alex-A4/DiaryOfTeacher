
//Model class which contains list of images url
class ListOfImages {
  List<String> urls;

  //Default constructor
  ListOfImages() : urls = [];

  //Build list of images from json
  ListOfImages.fromJson(Map<dynamic, dynamic> data){
    urls = data['imagesUrls'];
  }

  //Convert list of images to json map
  Map<String, dynamic> toJson() {
    return {
      'imagesUrls' : urls,
    };
  }
}
