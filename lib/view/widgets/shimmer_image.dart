import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShimmerImage extends StatefulWidget {
  final String imageUrl;
  final double width;
  final double height;

  const ShimmerImage({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  _ShimmerImageState createState() => _ShimmerImageState();
}

class _ShimmerImageState extends State<ShimmerImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isLoading = true;
  bool _isImageLoaded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> loadImage() async {
    final image = NetworkImage(widget.imageUrl);
    await precacheImage(image, context);
    _isLoading = false;
    _isImageLoaded = true;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          widget.imageUrl,
          width: widget.width,
          height: widget.height,
          fit: BoxFit.cover,
        ),
        if (_isLoading && !_isImageLoaded) _buildShimmerEffect(),
      ],
    );
  }

  Widget _buildShimmerEffect() {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            final gradientTranslation =
                (widget.width + widget.height) * _animationController.value;

            return Stack(
              children: [
                Positioned(
                  left: -gradientTranslation,
                  top: 0,
                  bottom: 0,
                  width: widget.width + widget.height,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-1.0, 0.0),
                      end: const Offset(1.0, 0.0),
                    ).animate(_animationController),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.grey[300]!,
                            Colors.grey[100]!,
                            Colors.grey[300]!,
                          ],
                          stops: const [0.35, 0.5, 0.65],
                          begin: const Alignment(-1.0, -1.0),
                          end: const Alignment(1.0, 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}