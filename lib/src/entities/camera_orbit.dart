/// Class to represent the orbit parameters for a camera around a 3D model.
class CameraOrbit {
  double theta; // The horizontal angle of the camera orbit.
  double phi; // The vertical angle of the camera orbit.
  double radius; // The distance of the camera from the model.

  /// Constructor to initialize the orbit parameters.
  CameraOrbit(this.theta, this.phi, this.radius);

  /// Overrides the toString method to provide a string representation of the orbit parameters.
  @override
  String toString() => "${theta}deg ${phi}deg ${radius}m";
}
