import 'package:flutter/material.dart';

class AnimatedPlayButton extends StatefulWidget {
  
  final double? width;
  final String image;

  const AnimatedPlayButton({
    super.key,
    this.width,
    required this.image,
  });
  @override
  _AnimatedPlayButtonState createState() => _AnimatedPlayButtonState();
}

class _AnimatedPlayButtonState extends State<AnimatedPlayButton>

  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    // Initialize the scale animation
    _scaleAnimation = Tween<double>(
      begin: 0.9, // start Size
      end: 1.3 // end size
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Image.asset(
        widget.image,
        width: widget.width,
      ),
    );
  }
}
