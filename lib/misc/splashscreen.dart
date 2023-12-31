import 'package:flutter/material.dart';
import '../pages/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<AnimationController> _dotControllers;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..forward();

    _initDotAnimations();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  void _initDotAnimations() {
    _dotControllers = List.generate(3, (index) =>
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
    );

    _dotAnimations = _dotControllers.map((controller) =>
        Tween<double>(begin: 0, end: 50).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut))
    ).toList();

    for (var i = 0; i < _dotControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 300 * i), () {
        _dotControllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _dotControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Center(
            child: Text(
              'EcommerceAPP',
              style: TextStyle(fontSize: 27.0, color: Color.fromRGBO(255, 221, 124, 1), fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) => _buildAnimatedDot(index)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedDot(int index) {
    return AnimatedBuilder(
      animation: _dotControllers[index],
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 15,
          height: 15,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          transform: Matrix4.translationValues(0, -_dotAnimations[index].value, 0),
        );
      },
    );
  }
}
