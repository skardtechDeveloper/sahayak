import 'package:flutter/material.dart';

class VoiceWaveAnimation extends StatefulWidget {
  const VoiceWaveAnimation({super.key});

  @override
  State<VoiceWaveAnimation> createState() => _VoiceWaveAnimationState();
}

class _VoiceWaveAnimationState extends State<VoiceWaveAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBar(_animation.value * 0.8, 0),
            _buildBar(_animation.value, 100),
            _buildBar(_animation.value * 0.6, 200),
            _buildBar(_animation.value * 0.9, 300),
            _buildBar(_animation.value * 0.7, 400),
          ],
        );
      },
    );
  }

  Widget _buildBar(double height, int delay) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        width: 4,
        height: 20 * height,
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }
}
