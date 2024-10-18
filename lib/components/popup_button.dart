import 'package:flutter/material.dart';

class PopUpButton extends StatefulWidget {
  final String buttonText;
  final Color color;
  final VoidCallback onTap;

  const PopUpButton({
    Key? key,
    required this.buttonText,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  _PopUpButtonState createState() => _PopUpButtonState();
}

class _PopUpButtonState extends State<PopUpButton> {
  double _scale = 1.0;

  // Function to trigger scale change on button press
  void _onTapDown(TapDownDetails details) {
    setState(() {
      _scale = 3; // Scale up
    });
  }

  // Function to reset scale when button is released
  void _onTapUp(TapUpDetails details) {
    setState(() {
      _scale = 1.0; // Scale back to normal
    });
    widget.onTap(); // Execute the callback
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown, // When button is pressed
      onTapUp: _onTapUp, // When button is released
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200), // Animation duration
        transform: Matrix4.identity()..scale(_scale), // Apply scaling
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.color, // Button color
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            widget.buttonText, // Button text
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
