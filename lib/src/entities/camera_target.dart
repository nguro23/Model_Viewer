/// Class to represent the target position for a camera in 3D space.
class CameraTarget {
  double x, y, z; // Coordinates for the camera target position.

  /// Constructor to initialize the target position parameters.

  /// [x] The x attribute receives a double value that indicates the position of the camera at the x position in meters.
  /// [y] The y attribute receives a double value that indicates the position of the camera at the y position in meters.
  /// [z] The z attribute receives a double value that indicates the position of the camera at the z position in meters.
  CameraTarget(this.x, this.y, this.z);

  /// Overrides the toString method to provide a string representation of the target position.
  @override
  String toString() => "${x}m ${y}m ${z}m";
}
