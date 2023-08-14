/// Abstract image class for Live Activity.
abstract class LiveActivityImage {}

/// Image class for an asset image for Live Activity.
///
/// Holds [path] of an Image that can be added to App Group.
class LiveActivityImageFromAsset extends LiveActivityImage {
  final String path;

  LiveActivityImageFromAsset(this.path);
}
/// Image class for a network image for Live Activity.
///
/// Holds [url] of an Image that can be added to App Group.
class LiveActivityImageFromNetwork extends LiveActivityImage {
  final String url;

  LiveActivityImageFromNetwork(this.url);
}
