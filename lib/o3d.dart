/// Library for the O3D package.
/// This library exports various components needed for the O3D model viewer.

library o3d;

// Export the JavaScript channel definitions.
export './src/app/channels/javascript_channel.dart';

// Export the enumeration definitions used in the O3D model viewer.
export './src/app/enums.dart';

// Export the main O3D class which integrates the O3D model viewer.
export './src/app/o3d.dart';

// Export the CameraOrbit entity which represents the camera orbit parameters.
export './src/entities/camera_orbit.dart';

// Export the CameraTarget entity which represents the camera target position.
export './src/entities/camera_target.dart';
