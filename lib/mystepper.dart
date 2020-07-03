import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum MyStepState {
  issuing,
  indexed,
  editing,
  complete,
  disabled,
  error,
}
enum MyStepperType {
  vertical,
  horizontal,
}

const TextStyle _kCustomStepStyle = TextStyle(
  fontSize: 12.0,
  color: Colors.white,
);
const Color _kErrorLight = Colors.red;
final Color _kErrorDark = Colors.red.shade400;
const Color _kCircleActiveLight = Colors.white;
const Color _kCircleActiveDark = Colors.black87;
const Color _kDisabledLight = Colors.black38;
const Color _kDisabledDark = Colors.white30;
const double _kCustomStepSize = 24.0;
const double _kTriangleHeight = _kCustomStepSize * 0.866025;

@immutable
class MyStep {
  const MyStep({
    @required this.title,
    this.subtitle,
    @required this.content,
    this.state = MyStepState.indexed,
    this.isActive = false,
    this.icon,
  })  : assert(title != null),
        assert(content != null),
        assert(state != null);
  final Widget title;
  final Widget subtitle;
  final Widget content;
  final MyStepState state;
  final Icon icon;
  final bool isActive;
}

class MyStepper extends StatefulWidget {
  MyStepper({
    Key key,
    @required this.steps,
    this.physics,
    this.type = MyStepperType.vertical,
    this.currentCustomStep = 0,
    this.onCustomStepTapped,
    this.onCustomStepContinue,
    this.onCustomStepCancel,
    this.controlsBuilder,
  })  : assert(steps != null),
        assert(type != null),
        assert(currentCustomStep != null),
        assert(0 <= currentCustomStep && currentCustomStep < steps.length),
        super(key: key);

  final List<MyStep> steps;
  final ScrollPhysics physics;
  final MyStepperType type;
  final int currentCustomStep;
  final ValueChanged<int> onCustomStepTapped;
  final VoidCallback onCustomStepContinue;
  final VoidCallback onCustomStepCancel;
  final ControlsWidgetBuilder controlsBuilder;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<MyStepper>
    with TickerProviderStateMixin {
  List<GlobalKey> _keys;
  final Map<int, MyStepState> _oldStates = <int, MyStepState>{};

  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(
      widget.steps.length,
      (int i) => GlobalKey(),
    );

    for (int i = 0; i < widget.steps.length; i += 1)
      _oldStates[i] = widget.steps[i].state;
  }

  @override
  void didUpdateWidget(MyStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.steps.length == oldWidget.steps.length);

    for (int i = 0; i < oldWidget.steps.length; i += 1)
      _oldStates[i] = oldWidget.steps[i].state;
  }

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  bool _isCurrent(int index) {
    return widget.currentCustomStep == index;
  }

  bool _isDark() {
    return Theme.of(context).brightness == Brightness.dark;
  }

  Widget _buildLine(bool visible) {
    return Container(
      width: visible ? 1.0 : 0.0,
      height: 12.0,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildCircleChild(int index, bool oldState) {
    final MyStepState state =
        oldState ? _oldStates[index] : widget.steps[index].state;
    final bool isDarkActive = _isDark() && widget.steps[index].isActive;
    assert(state != null);
    switch (state) {
      case MyStepState.indexed:
        return Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Color(0xff00acc1),
            ),
          ),
          child: Center(
            child: Text(
              (index + 1).toString(),
              style: TextStyle(
                color: Color(0xff00acc1),
                fontSize: 12,
              ),
            ),
          ),
        );
      case MyStepState.disabled:
        return Text(
          '${index + 1}',
          style: isDarkActive
              ? _kCustomStepStyle.copyWith(color: Colors.black87)
              : _kCustomStepStyle,
        );
      case MyStepState.issuing:
        return Icon(
          Icons.check_circle,
          color: isDarkActive ? _kCircleActiveDark : Color(0xfff44336),
          size: 18,
        );
      case MyStepState.editing:
        return Icon(
          Icons.edit,
          color: isDarkActive ? _kCircleActiveDark : _kCircleActiveLight,
          size: 18.0,
        );
      case MyStepState.complete:
        return Icon(
          Icons.check_circle,
          color: isDarkActive ? _kCircleActiveDark : Color(0xff00acc1),
          size: 18,
        );
      case MyStepState.error:
        return const Text('!', style: _kCustomStepStyle);
    }
    return null;
  }

  Widget _buildCircle(int index, bool oldState) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _buildCircleChild(
          index, oldState && widget.steps[index].state == MyStepState.error),
    );
  }

  Widget _buildTriangle(int index, bool oldState) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      width: _kCustomStepSize,
      height: _kCustomStepSize,
      child: Center(
        child: SizedBox(
          width: _kCustomStepSize,
          height:
              _kTriangleHeight, // Height of 24dp-long-sided equilateral triangle.
          child: CustomPaint(
            painter: _TrianglePainter(
              color: _isDark() ? _kErrorDark : _kErrorLight,
            ),
            child: Align(
              alignment: const Alignment(
                  0.0, 0.8), // 0.8 looks better than the geometrical 0.33.
              child: _buildCircleChild(index,
                  oldState && widget.steps[index].state != MyStepState.error),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(int index) {
    if (widget.steps[index].state != _oldStates[index]) {
      return AnimatedCrossFade(
        firstChild: _buildCircle(index, true),
        secondChild: _buildTriangle(index, true),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState: widget.steps[index].state == MyStepState.error
            ? CrossFadeState.showSecond
            : CrossFadeState.showFirst,
        duration: kThemeAnimationDuration,
      );
    } else {
      if (widget.steps[index].state != MyStepState.error)
        return _buildCircle(index, false);
      else
        return _buildTriangle(index, false);
    }
  }

  Widget _buildVerticalControls() {
    if (widget.controlsBuilder != null)
      return widget.controlsBuilder(context,
          onStepContinue: widget.onCustomStepContinue,
          onStepCancel: widget.onCustomStepCancel);

    Color cancelColor;

    switch (Theme.of(context).brightness) {
      case Brightness.light:
        cancelColor = Colors.black54;
        break;
      case Brightness.dark:
        cancelColor = Colors.white70;
        break;
    }

    final ThemeData themeData = Theme.of(context);
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: ConstrainedBox(
        constraints: BoxConstraints.tightFor(height: 48.0),
        child: Row(
          children: <Widget>[
            FlatButton(
              onPressed: widget.onCustomStepContinue,
              color: _isDark()
                  ? themeData.backgroundColor
                  : themeData.primaryColor,
              textColor: Colors.white,
              textTheme: ButtonTextTheme.normal,
              child: Text(localizations.continueButtonLabel),
            ),
            Container(
              margin: const EdgeInsetsDirectional.only(start: 8.0),
              child: FlatButton(
                onPressed: widget.onCustomStepCancel,
                textColor: cancelColor,
                textTheme: ButtonTextTheme.normal,
                child: Text(localizations.cancelButtonLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _titleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    assert(widget.steps[index].state != null);
    switch (widget.steps[index].state) {
      case MyStepState.indexed:
      case MyStepState.editing:
      case MyStepState.issuing:
      case MyStepState.complete:
        return textTheme.bodyText1;
      case MyStepState.disabled:
        return textTheme.bodyText1
            .copyWith(color: _isDark() ? _kDisabledDark : _kDisabledLight);
      case MyStepState.error:
        return textTheme.bodyText1
            .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);
    }
    return null;
  }

  TextStyle _subtitleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    assert(widget.steps[index].state != null);
    switch (widget.steps[index].state) {
      case MyStepState.indexed:
      case MyStepState.editing:
      case MyStepState.issuing:
      case MyStepState.complete:
        return textTheme.caption;
      case MyStepState.disabled:
        return textTheme.caption
            .copyWith(color: _isDark() ? _kDisabledDark : _kDisabledLight);
      case MyStepState.error:
        return textTheme.caption
            .copyWith(color: _isDark() ? _kErrorDark : _kErrorLight);
    }
    return null;
  }

  Widget _buildHeaderText(int index) {
    final List<Widget> children = <Widget>[
      AnimatedDefaultTextStyle(
        style: _titleStyle(index),
        duration: kThemeAnimationDuration,
        curve: Curves.fastOutSlowIn,
        child: widget.steps[index].title,
      ),
    ];

    if (widget.steps[index].subtitle != null)
      children.add(
        Container(
          margin: const EdgeInsets.only(top: 2.0),
          child: AnimatedDefaultTextStyle(
            style: _subtitleStyle(index),
            duration: kThemeAnimationDuration,
            curve: Curves.fastOutSlowIn,
            child: widget.steps[index].subtitle,
          ),
        ),
      );

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: children);
  }

  Widget _buildVerticalHeader(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              // Line parts are always added in order for the ink splash to
              // flood the tips of the connector lines.
              _buildLine(!_isFirst(index)),
              _buildIcon(index),
              _buildLine(!_isLast(index)),
            ],
          ),
          Container(
            margin: const EdgeInsetsDirectional.only(start: 12.0),
            child: _buildHeaderText(index),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalBody(int index) {
    return Stack(
      children: <Widget>[
        PositionedDirectional(
          start: 8.5, //28
          top: 0.0,
          bottom: 0.0,
          child: SizedBox(
            width: 17.0,
            child: Center(
              child: SizedBox(
                width: _isLast(index) ? 0.0 : 1.0,
                child: Container(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: Container(height: 0.0),
          secondChild: Container(
            margin: const EdgeInsetsDirectional.only(
              start: 60.0, //60
              end: 24.0,
              bottom: 24.0,
            ),
            child: Column(
              children: <Widget>[
                widget.steps[index].content,
                _buildVerticalControls(),
              ],
            ),
          ),
          firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
          secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
          sizeCurve: Curves.fastOutSlowIn,
          crossFadeState: _isCurrent(index)
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: kThemeAnimationDuration,
        ),
      ],
    );
  }

  Widget _buildVertical() {
    final List<Widget> children = <Widget>[];

    for (int i = 0; i < widget.steps.length; i += 1) {
      children.add(
        Column(
          key: _keys[i],
          children: <Widget>[
            InkWell(
                onTap: widget.steps[i].state != MyStepState.disabled
                    ? () {
                        // In the vertical case we need to scroll to the newly tapped
                        // step.
                        Scrollable.ensureVisible(
                          _keys[i].currentContext,
                          curve: Curves.fastOutSlowIn,
                          duration: kThemeAnimationDuration,
                        );

                        if (widget.onCustomStepTapped != null)
                          widget.onCustomStepTapped(i);
                      }
                    : null,
                child: _buildVerticalHeader(i)),
            _buildVerticalBody(i)
          ],
        ),
      );
    }

    return ListView(
      shrinkWrap: true,
      physics: widget.physics,
      children: children,
    );
  }

  Widget _buildHorizontal() {
    final List<Widget> children = <Widget>[];

    for (int i = 0; i < widget.steps.length; i += 1) {
      children.add(
        InkResponse(
          onTap: widget.steps[i].state != MyStepState.disabled
              ? () {
                  if (widget.onCustomStepTapped != null)
                    widget.onCustomStepTapped(i);
                }
              : null,
          child: Row(
            children: <Widget>[
              Container(
                height: 72.0,
                child: Center(
                  child: _buildIcon(i),
                ),
              ),
              Container(
                margin: const EdgeInsetsDirectional.only(start: 12.0),
                child: _buildHeaderText(i),
              ),
            ],
          ),
        ),
      );

      if (!_isLast(i)) {
        children.add(
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              height: 1.0,
              color: Colors.grey.shade400,
            ),
          ),
        );
      }
    }

    return Column(
      children: <Widget>[
        Material(
          elevation: 2.0,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: children,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: <Widget>[
              AnimatedSize(
                curve: Curves.fastOutSlowIn,
                duration: kThemeAnimationDuration,
                vsync: this,
                child: widget.steps[widget.currentCustomStep].content,
              ),
              _buildVerticalControls(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterial(context));
    assert(debugCheckHasMaterialLocalizations(context));
    // assert(() {
    //   if (context.ancestorWidgetOfExactType(CustomStepper) != null)
    //     throw FlutterError(
    //         'CustomSteppers must not be nested. The material specification advises '
    //         'that one should avoid embedding steppers within steppers. '
    //         'https://material.io/archive/guidelines/components/steppers.html#steppers-usage\n');
    //   return true;
    // }());
    assert(widget.type != null);
    switch (widget.type) {
      case MyStepperType.vertical:
        return _buildVertical();
      case MyStepperType.horizontal:
        return _buildHorizontal();
    }
    return null;
  }
}

// Paints a triangle whose base is the bottom of the bounding rectangle and its
// top vertex the middle of its top.
class _TrianglePainter extends CustomPainter {
  _TrianglePainter({this.color});

  final Color color;

  @override
  bool hitTest(Offset point) => true; // Hitting the rectangle is fine enough.

  @override
  bool shouldRepaint(_TrianglePainter oldPainter) {
    return oldPainter.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double base = size.width;
    final double halfBase = size.width / 2.0;
    final double height = size.height;
    final List<Offset> points = <Offset>[
      Offset(0.0, height),
      Offset(base, height),
      Offset(halfBase, 0.0),
    ];

    canvas.drawPath(
      Path()..addPolygon(points, true),
      Paint()..color = color,
    );
  }
}
