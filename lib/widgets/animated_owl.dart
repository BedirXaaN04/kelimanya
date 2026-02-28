import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedOwl extends StatefulWidget {
  final bool isAngry;
  final bool isHappy;
  final bool baseEyeClosed;

  const AnimatedOwl({
    super.key,
    this.isAngry = false,
    this.isHappy = false,
    this.baseEyeClosed = false,
  });

  @override
  State<AnimatedOwl> createState() => _AnimatedOwlState();
}

class _AnimatedOwlState extends State<AnimatedOwl> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _wingsController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
       vsync: this,
       duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _wingsController = AnimationController(
       vsync: this,
       duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedOwl oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isHappy && !oldWidget.isHappy) {
      _wingsController.repeat(reverse: true);
    } else if (!widget.isHappy && oldWidget.isHappy) {
      _wingsController.stop();
      _wingsController.animateTo(0);
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _wingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final purple = const Color(0xff8c7ae6);
    final bellyColor = const Color(0xfff5f6fa);
    final yellow = const Color(0xfffcd53f);
    final stroke = 4.0; 

    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: 160,
        height: 160,
        child: AnimatedBuilder(
          animation: Listenable.merge([_floatController, _wingsController]),
          builder: (context, child) {
            double floatY = sin(_floatController.value * pi) * 6.0;
            
            double flapAngle = 0;
            if (widget.isHappy || widget.isAngry) {
               flapAngle = sin((_wingsController.isAnimating ? _wingsController.value : _floatController.value * 5) * pi * 2) * 0.4;
            }

            double offsetX = 0;
            if (widget.isAngry) {
               offsetX = sin(DateTime.now().millisecondsSinceEpoch / 20.0) * 4.0;
            }

            return Transform.translate(
               offset: Offset(offsetX, floatY),
               child: Stack(
                 alignment: Alignment.center,
                 clipBehavior: Clip.none,
                 children: [
                   // Ayaklar
                   Positioned(
                     bottom: 15,
                     left: 50,
                     child: _buildFoot(yellow, stroke),
                   ),
                   Positioned(
                     bottom: 15,
                     right: 50,
                     child: _buildFoot(yellow, stroke),
                   ),

                   // Kanatlar
                   AnimatedPositioned(
                     duration: const Duration(milliseconds: 300),
                     curve: Curves.easeInOut,
                     left: widget.baseEyeClosed ? 35 : 15,
                     top: widget.baseEyeClosed ? 35 : 65,
                     child: Transform(
                       alignment: Alignment.centerRight,
                       transform: Matrix4.rotationZ(
                         widget.baseEyeClosed ? 1.4 : (0.2 + flapAngle)
                       ),
                       child: _buildWing(purple, stroke),
                     )
                   ),
                   AnimatedPositioned(
                     duration: const Duration(milliseconds: 300),
                     curve: Curves.easeInOut,
                     right: widget.baseEyeClosed ? 35 : 15,
                     top: widget.baseEyeClosed ? 35 : 65,
                     child: Transform(
                       alignment: Alignment.centerLeft,
                       transform: Matrix4.rotationZ(
                         widget.baseEyeClosed ? -1.4 : (-0.2 - flapAngle)
                       ),
                       child: _buildWing(purple, stroke),
                     )
                   ),

                   // Gövde
                   Container(
                     width: 110,
                     height: 120,
                     decoration: BoxDecoration(
                       color: purple,
                       borderRadius: BorderRadius.circular(55),
                       border: Border.all(color: Colors.black, width: stroke),
                       boxShadow: const [
                         BoxShadow(color: Colors.black, offset: Offset(4, 4))
                       ]
                     ),
                     child: Stack(
                       alignment: Alignment.center,
                       clipBehavior: Clip.none,
                       children: [
                         // Kulaklar
                         Positioned(
                           top: -6,
                           left: 2,
                           child: Transform.rotate(
                             angle: -0.3,
                             child: _buildEar(purple, stroke),
                           ),
                         ),
                         Positioned(
                           top: -6,
                           right: 2,
                           child: Transform.rotate(
                             angle: 0.3,
                             child: _buildEar(purple, stroke),
                           ),
                         ),

                         // Göbek
                         Positioned(
                           bottom: 5,
                           child: Container(
                             width: 80,
                             height: 65,
                             decoration: BoxDecoration(
                               color: bellyColor,
                               borderRadius: BorderRadius.circular(40),
                               border: Border.all(color: Colors.black, width: stroke),
                             ),
                           ),
                         ),

                         // Gözler
                         Positioned(
                           top: 25,
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               _buildEye(widget.baseEyeClosed, widget.isHappy, widget.isAngry, stroke, true),
                               const SizedBox(width: 4),
                               _buildEye(widget.baseEyeClosed, widget.isHappy, widget.isAngry, stroke, false),
                             ],
                           ),
                         ),

                         // Gaga
                         Positioned(
                           top: 55,
                           child: _buildBeak(yellow, stroke),
                         ),
                       ],
                     ),
                   ),
                 ],
               ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFoot(Color color, double stroke) {
    return Container(
      width: 20,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black, width: stroke),
      ),
    );
  }

  Widget _buildWing(Color color, double stroke) {
    return Container(
      width: 35,
      height: 60,
      decoration: BoxDecoration(
         color: color,
         borderRadius: BorderRadius.circular(25),
         border: Border.all(color: Colors.black, width: stroke),
      ),
    );
  }

  Widget _buildEar(Color color, double stroke) {
    return Container(
      width: 25,
      height: 25,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(5),
          bottomLeft: Radius.circular(5),
          bottomRight: Radius.circular(20),
        ),
        border: Border.all(color: Colors.black, width: stroke),
      ),
    );
  }

  Widget _buildBeak(Color color, double stroke) {
    return Container(
      width: 14,
      height: 22,
      decoration: BoxDecoration(
         color: color,
         borderRadius: const BorderRadius.only(
           bottomLeft: Radius.circular(15),
           bottomRight: Radius.circular(15),
           topLeft: Radius.circular(5),
           topRight: Radius.circular(5),
         ),
         border: Border.all(color: Colors.black, width: stroke),
      ),
    );
  }

  Widget _buildEye(bool closed, bool happy, bool angry, double stroke, bool isLeft) {
    return AnimatedContainer(
       duration: const Duration(milliseconds: 200),
       width: 42,
       height: closed ? 16 : (happy ? 18 : 42),
       decoration: BoxDecoration(
         color: closed ? const Color(0xff8c7ae6) : Colors.white,
         borderRadius: BorderRadius.circular(21),
         border: Border.all(color: Colors.black, width: stroke),
       ),
       child: closed 
         ? Center(child: Container(width: 25, height: 4, decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(2))))
         : Stack(
             alignment: Alignment.center,
             children: [
               AnimatedContainer(
                 duration: const Duration(milliseconds: 200),
                 width: angry ? 16 : (happy ? 12 : 20),
                 height: angry ? 16 : (happy ? 12 : 20),
                 decoration: BoxDecoration(
                   color: angry ? Colors.red : Colors.black,
                   shape: BoxShape.circle,
                 ),
                 child: (angry || happy) 
                   ? null 
                   : Align(
                       alignment: Alignment.topRight,
                       child: Container(
                         margin: const EdgeInsets.only(top: 4, right: 4),
                         width: 6,
                         height: 6,
                         decoration: const BoxDecoration(
                           color: Colors.white,
                           shape: BoxShape.circle,
                         ),
                       ),
                     ),
               ),
               if (angry)
                 Positioned(
                   top: 2,
                   child: Transform.rotate(
                     angle: isLeft ? 0.3 : -0.3,
                     child: Container(
                       width: 25,
                       height: 5,
                       color: Colors.black,
                     ),
                   )
                 )
             ],
           ),
    );
  }
}
