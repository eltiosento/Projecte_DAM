import 'package:app_torneig/utils/tamanys_pantalles.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class ButtonsAppBar extends StatefulWidget {
  const ButtonsAppBar(this.title, {super.key, this.onTap});
  final String title;
  final VoidCallback? onTap;

  @override
  ButtonsAppBarState createState() => ButtonsAppBarState();
}

class ButtonsAppBarState extends State<ButtonsAppBar> {
  late bool _isHovering;

  @override
  void initState() {
    super.initState();
    _isHovering = false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (value) {
        setState(() {
          _isHovering = value;
        });
      },
      onTap: widget.onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutoSizeText(
            widget.title,
            style: TextStyle(
              color: _isHovering ? Colors.orange : Colors.white,
              fontFamily: 'Montserrat',
              fontSize: 15,
            ),
            maxLines: 1,
            minFontSize: 1,
            overflow: TextOverflow.ellipsis,
            textScaleFactor:
                isMobile(context) ? 0.8 : (isTablet(context) ? 1.0 : 1.2),
          ),
        ],
      ),
    );
  }
}
