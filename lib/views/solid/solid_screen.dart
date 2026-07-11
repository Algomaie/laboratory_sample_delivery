// import 'package:flutter/material.dart';
// import 'package:flutter_cube/flutter_cube.dart';

// class SolidScreen extends StatefulWidget {
//   final String solidUrl;
//   const SolidScreen({Key? key, required this.solidUrl}) : super(key: key);

//   @override
//   State<SolidScreen> createState() => _SolidScreenState();
// }

// class _SolidScreenState extends State<SolidScreen> {
//   late Object solid;

//   @override
//   void initState() {
//     // Initialize the solid object with lighting enabled
//     // solid = Object(
//     //   fileName: 'http://10.0.2.2:8080${widget.solidUrl}',
//     //   lighting: true,
//     // );
//     solid = Object(
//       fileName: "assets/objects/result.obj",
//       lighting: true,
//     );

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     print('http://127.0.0.1:8080${widget.solidUrl}');
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(
//               height: 100,
//             ),
//             const Text(
//               "Solid",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Expanded(
//               child: Cube(
//                 onSceneCreated: (Scene scene) {
//                   // Add the solid object to the scene
//                   scene.world.add(solid);

//                   // Set the number of faces in the scene
//                   scene.faceCount = 10;

//                   // Set light properties (you need to define color, ambient, diffuse, and specular)
//                   scene.light.setColor(Colors.grey, 1.0, 0.8, 0.6);

//                   // Set camera zoom
//                   scene.camera.zoom = 10;
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
