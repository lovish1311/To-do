// lib/animations/slideout.dart

import 'package:flutter/material.dart';

class SlideOut extends StatefulWidget {
  final Widget child;
  final bool animate;
  final VoidCallback onSlideComplete;
  final Duration duration;

  const SlideOut({
    super.key,
    required this.child,
    required this.animate,
    required this.onSlideComplete,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<SlideOut> createState() => _SlideOutState();
}

class _SlideOutState extends State<SlideOut> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0), // Slide to right (1.5 = off screen)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_hasAnimated) {
        _hasAnimated = true;
        widget.onSlideComplete();
      }
    });
  }

  @override
  void didUpdateWidget(covariant SlideOut oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.animate && !_hasAnimated) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: widget.child,
      ),
    );
  }
}
