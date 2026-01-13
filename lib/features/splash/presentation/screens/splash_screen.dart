// import 'package:flutter/material.dart';

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         children: [
//           // Background gradient (matching auth screens)
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     const Color(0xFF2C5F7C).withValues(alpha: 0.5),
//                     Colors.black,
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Dark overlay (matching auth screens)
//           Positioned.fill(
//             child: Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topCenter,
//                   end: Alignment.bottomCenter,
//                   colors: [
//                     Colors.black.withValues(alpha: 0.72),
//                     Colors.black.withValues(alpha: 0.82),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // Logo in center - LARGER SIZE
//           Center(
//             child: Image.asset(
//               'assets/images/logo.png',
//               width:
//                   MediaQuery.of(context).size.width *
//                   0.90, // 85% of screen width
//               height: 250, // Increased height
//               fit: BoxFit.contain,
//               errorBuilder: (context, error, stackTrace) {
//                 // Fallback if image not found
//                 return const Text(
//                   'WhirlWash',
//                   style: TextStyle(
//                     fontSize: 64,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF4ECDC4),
//                     letterSpacing: 2,
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// ----------------------------------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:whirl_wash/core/constants/app_colors.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background gradient (matching auth screens)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.5),
                    AppColors.background,
                  ],
                ),
              ),
            ),
          ),

          // Dark overlay (matching auth screens)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(gradient: AppColors.overlayGradient),
            ),
          ),

          // Logo in center
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.of(context).size.width * 0.90,
                  height: 250,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'WhirlWash',
                      style: TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                        letterSpacing: 2,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Loading indicator (commented out)
                // const SizedBox(
                //   width: 40,
                //   height: 40,
                //   child: CircularProgressIndicator(
                //     valueColor: AlwaysStoppedAnimation<Color>(
                //       AppColors.secondary,
                //     ),
                //     strokeWidth: 3,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
