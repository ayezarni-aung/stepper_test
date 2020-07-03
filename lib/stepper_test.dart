import 'package:flutter/material.dart';

enum StateChild {
  issuing,
  indexed,
  editing,
  complete,
  disabled,
  error,
}
enum StepperType {
  vertical,
  horizontal,
}

class StepChild {
  final Widget title;
  final Widget subtitle;
  final Widget content;
  final StateChild state;
  final Icon icon;
  final bool isActive;
  StepChild({
    this.title,
    this.subtitle,
    this.content,
    this.state,
    this.icon,
    this.isActive,
  });
}

class StepperTest extends StatefulWidget {
  final List<StepChild> steps;

  final ScrollPhysics physics;
  final StepperType type;
  final int currentStep;
  final ValueChanged<int> onCustomStepTapped;
  final ControlsWidgetBuilder controlsBuilder;
  StepperTest({
    this.steps,
    this.physics,
    this.type = StepperType.vertical,
    this.currentStep,
    this.onCustomStepTapped,
    this.controlsBuilder,
  });

  @override
  _StepperTestState createState() => _StepperTestState();
}

class _StepperTestState extends State<StepperTest> {
  List<GlobalKey> _keys;
  @override
  void initState() {
    super.initState();
    _keys = List<GlobalKey>.generate(
      widget.steps.length,
      (int i) => GlobalKey(),
    );
  }

  bool _isCurrent(int index) {
    return widget.currentStep == index;
  }

  bool _isFirst(int index) {
    return index == 0;
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  Widget _buildLine(bool visible) {
    return Container(
      width: visible ? 1.0 : 0.0,
      height: 12.0,
      color: Colors.grey.shade400,
    );
  }

  Widget _buildCircleChild() {
    final StateChild state = StateChild.complete;

    switch (state) {
      case StateChild.indexed:
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
              (1).toString(),
              style: TextStyle(
                color: Color(0xff00acc1),
                fontSize: 12,
              ),
            ),
          ),
        );
      case StateChild.disabled:
        return Text(
          '${1}',
        );
      case StateChild.issuing:
        return Icon(
          Icons.check_circle,
          size: 18,
        );
      case StateChild.editing:
        return Icon(
          Icons.edit,
          size: 18.0,
        );
      case StateChild.complete:
        return Icon(
          Icons.check_circle,
          size: 18,
        );
      case StateChild.error:
        return const Text(
          '!',
        );
    }
    return null;
  }

  Widget _buildCircle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _buildCircleChild(),
    );
  }

  Widget _buildIcon(int index) {
    return AnimatedCrossFade(
      firstChild: _buildCircle(),
      secondChild: _buildCircle(),
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState: widget.steps[index].state == StateChild.error
          ? CrossFadeState.showSecond
          : CrossFadeState.showFirst,
      duration: kThemeAnimationDuration,
    );
  }

  bool firstStateEnabled = true;
  Widget _buildVerticalBodyChild(int index) {
    return Row(
      children: [
        Container(
          color: Colors.grey.shade300,
          height: 30,
          width: _isLast(index) ? 0 : 2,
        ),
        SizedBox(
          width: 80,
        ),
        AnimatedCrossFade(
          crossFadeState: firstStateEnabled
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: Duration(milliseconds: 500),
          firstChild: widget.steps[index].content,
          secondChild: Container(),
        ),
      ],
    );
  }

  bool showitem = false;
  // Widget _buildVertical() {
  //   final List<Widget> children = <Widget>[];

  //   for (int i = 0; i < widget.steps.length; i += 1) {
  //     children.add(
  //       Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         children: <Widget>[
  //           InkWell(
  //               onTap: widget.steps[i].state != StateChild.disabled
  //                   ? () {
  //                       // print("onTap");
  //                       // setState(() {
  //                       //   showitem = !showitem;
  //                       // });
  //                       Scrollable.ensureVisible(
  //                         _keys[i].currentContext,
  //                         curve: Curves.fastOutSlowIn,
  //                         duration: kThemeAnimationDuration,
  //                       );

  //                       if (widget.onCustomStepTapped != null)
  //                         widget.onCustomStepTapped(i);
  //                     }
  //                   : null,
  //               child: _buildVerticalHeader(i)),

  //           AnimatedCrossFade(
  //             firstChild: Padding(
  //               padding: const EdgeInsets.only(left: 16.0),
  //               child: _buildVerticalBodyChild(i),
  //             ),
  //             secondChild: Container(),
  //             crossFadeState: showitem
  //                 ? CrossFadeState.showFirst
  //                 : CrossFadeState.showSecond,
  //             duration: Duration(milliseconds: 500),
  //           ),

  //           // _buildLine(),
  //         ],
  //       ),
  //     );
  //   }

  //   return ListView(
  //     shrinkWrap: true,
  //     physics: widget.physics,
  //     children: children,
  //   );
  // }

  Widget _buildVerticalHeader(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
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

  Widget _buildVertical() {
    final List<Widget> children = <Widget>[];

    for (int i = 0; i < widget.steps.length; i += 1) {
      children.add(
        Column(
          key: _keys[i],
          children: <Widget>[
            InkWell(
                onTap: widget.steps[i].state != StateChild.disabled
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
                // _buildVerticalControls(),
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

  Widget _buildHeaderText(int index) {
    final List<Widget> children = <Widget>[
      AnimatedDefaultTextStyle(
        style: _titleStyle(index),
        duration: Duration(milliseconds: 500),
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

  TextStyle _titleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    assert(widget.steps[index].state != null);
    switch (widget.steps[index].state) {
      case StateChild.indexed:
      case StateChild.editing:
      case StateChild.issuing:
      case StateChild.complete:
        return textTheme.bodyText1;
      case StateChild.disabled:
        return textTheme.bodyText1;
      case StateChild.error:
        return textTheme.bodyText1;
    }
    return null;
  }

  TextStyle _subtitleStyle(int index) {
    final ThemeData themeData = Theme.of(context);
    final TextTheme textTheme = themeData.textTheme;

    assert(widget.steps[index].state != null);
    switch (widget.steps[index].state) {
      case StateChild.indexed:
      case StateChild.editing:
      case StateChild.issuing:
      case StateChild.complete:
        return textTheme.caption;
      case StateChild.disabled:
        return textTheme.caption;
      case StateChild.error:
        return textTheme.caption;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    assert(widget.type != null);
    switch (widget.type) {
      case StepperType.vertical:
        return _buildVertical();
      case StepperType.horizontal:
      // return _buildHorizontal();
    }
    return _buildVertical();
  }
}
