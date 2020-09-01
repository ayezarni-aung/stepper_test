import 'package:flutter/material.dart';

class SeeMore extends StatelessWidget {
  final String collapsedHint;

  final String expandedHint;

  final Animation<double> animation;

  final EdgeInsets padding;

  final void Function() onTap;

  final Color arrowColor;

  final double arrowSize;

  final IconData icon;

  final TextStyle hintTextStyle;

  const SeeMore({
    Key key,
    this.collapsedHint,
    this.expandedHint,
    @required this.animation,
    this.padding,
    this.onTap,
    this.arrowColor,
    this.arrowSize,
    this.icon,
    this.hintTextStyle,
  })  : assert(animation != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final tooltipMessage = animation.value < 0.25
        ? collapsedHint ??
            MaterialLocalizations.of(context).collapsedIconTapHint
        : expandedHint ?? MaterialLocalizations.of(context).expandedIconTapHint;

    return Tooltip(
      message: tooltipMessage,
      child: InkResponse(
        highlightShape: BoxShape.rectangle,
        child: Padding(
          padding: padding ?? EdgeInsets.all(4),
          child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
            const SizedBox(width: 2.0),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Theme.of(context).textTheme.caption.color,
                  ),
              child: Text(
                tooltipMessage,
                style: hintTextStyle,
              ),
            ),
            const SizedBox(width: 2.0),
          ]),
        ),
        onTap: onTap,
      ),
    );
  }
}
