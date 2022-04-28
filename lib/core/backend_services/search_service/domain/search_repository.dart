abstract class SearchRepository {
  ///[GET]: Get a list of all image IDs
  getImagesId(Map<String, dynamic> query);

  ///[GET]: Get a list of all image IDs with their image url
  getImagesUrl(Map<String, dynamic> query);

  ///[GET]: Get a list of all image IDs with their image url and segmentation
  getImagesSegmentation(Map<String, dynamic> query);

  ///[GET]: Get a list of all image IDs with their image url and caption
  getImagesCaption(Map<String, dynamic> query);
}
