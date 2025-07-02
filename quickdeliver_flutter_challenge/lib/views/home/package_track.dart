import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PackageTrack extends StatelessWidget {
  const PackageTrack({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Stack(
        children: [
          Column(
            children: [
              TextButton(onPressed: () {
                context.pop();
                }, child: Text('data'),)
            ],
          ),
        ],
      ),
    );
  }
}