import 'package:flutter/material.dart';

class FocusPage extends StatelessWidget {
  const FocusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noise'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Container(
        color: Colors.grey[300],
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('Welcome to the Focus Page!'),
              const SizedBox(height: 20.0), // Add some spacing
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 columns
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: 10, // 2 columns * 5 rows = 10 items
                  itemBuilder: (context, index) {
                    return Stack(
                      children: <Widget>[
                        const Icon(
                          Icons.album,
                          size: 200.0, // Adjust size as needed
                        ),
                        Positioned(
                          top: 10.0,
                          left: 10.0,
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            color: Colors.black.withOpacity(0.5),
                            child: Text(
                              'Unlock after ${index + 1} week${index == 0 ? '' : 's'}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class FocusPage extends StatelessWidget {
//   const FocusPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Noise'),
//         backgroundColor: Colors.blueGrey,
//       ),
//       body: Container(
//         color: Colors.grey[300],
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text('Welcome to the Focus Page!'),
//               SizedBox(height: 20.0), // Add some spacing
//               Expanded(
//                 child: GridView.builder(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2, // 2 columns
//                     mainAxisSpacing: 10.0,
//                     crossAxisSpacing: 10.0,
//                   ),
//                   itemCount: 10, // 2 columns * 5 rows = 10 items
//                   itemBuilder: (context, index) {
//                     return GridTile(
//                       child: Icon(
//                         Icons.album,
//                         size: 200.0, // Adjust size as needed
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
