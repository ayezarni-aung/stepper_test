import 'package:flutter/material.dart';

const Duration _kExpand = Duration(milliseconds: 300);

class SeeLess extends StatefulWidget {
  final String collapsedHint;

  final String expandedHint;

  final EdgeInsets arrowPadding;

  final Color arrowColor;

  final double arrowSize;

  final IconData icon;

  final TextStyle hintTextStyle;

  final Duration animationDuration;

  final Widget child;

  final bool hideArrowOnExpanded;

  const SeeLess({
    Key key,
    this.collapsedHint,
    this.expandedHint,
    this.arrowPadding,
    this.arrowColor,
    this.arrowSize = 30,
    this.icon,
    this.hintTextStyle,
    this.animationDuration = _kExpand,
    @required this.child,
    this.hideArrowOnExpanded = false,
  })  : assert(hideArrowOnExpanded != null),
        super(key: key);

  @override
  _ExpandChildState createState() => _ExpandChildState();
}

class _ExpandChildState extends State<SeeLess>
    with SingleTickerProviderStateMixin {
  static final _easeInCurve = CurveTween(curve: Curves.easeInOutCubic);

  static final _halfTurn = Tween<double>(begin: 0.0, end: 0.5);

  AnimationController _controller;

  Animation<double> _heightFactor;

  Animation<double> _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: widget.animationDuration,
    );

    _heightFactor = _controller.drive(_easeInCurve);
    _iconTurns = _controller.drive(_halfTurn.chain(_easeInCurve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  Widget _buildChild(BuildContext context, Widget child) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: _heightFactor.value,
                child: child,
              ),
            ),
            InkWell(
              onTap: _handleTap,
              child: SeeMore(
                collapsedHint: widget.collapsedHint,
                expandedHint: widget.expandedHint,
                animation: _iconTurns,
                padding: widget.arrowPadding,
                onTap: _handleTap,
                arrowColor: widget.arrowColor,
                arrowSize: widget.arrowSize,
                icon: widget.icon,
                hintTextStyle: widget.hintTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChild,
      child: widget.child,
    );
  }
}

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
