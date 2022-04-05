import 'package:flutter/material.dart';
import 'package:music_player/Helpers/config.dart';
import 'package:music_player/Statics/Statics.dart';

class GradientContainer extends StatefulWidget {
  final Widget child;
  final bool opacity;
  const GradientContainer({@required this.child, this.opacity});
  @override
  _GradientContainerState createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? ((widget.opacity == true)
                  ? currentTheme.getTransBackGradient()
                  : currentTheme.getBackGradient())
              : [
                  const Color(0xfff5f9ff),
                  Colors.white,
                ],
        ),
      ),
      child: widget.child,
    );
  }
}

class BottomGradientContainer extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;
  final EdgeInsetsGeometry padding;
  final BorderRadiusGeometry borderRadius;
  const BottomGradientContainer(
      {@required this.child, this.margin, this.padding, this.borderRadius});
  @override
  _BottomGradientContainerState createState() =>
      _BottomGradientContainerState();
}

class _BottomGradientContainerState extends State<BottomGradientContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin ?? const EdgeInsets.fromLTRB(25, 0, 25, 25),
      padding: widget.padding ?? const EdgeInsets.fromLTRB(10, 15, 10, 15),
      decoration: BoxDecoration(
        borderRadius: widget.borderRadius ??
            const BorderRadius.all(Radius.circular(15.0)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey[900],
            Colors.black,
            Colors.black,
          ],
        ),
      ),
      child: widget.child,
    );
  }
}

class GradientCard extends StatefulWidget {
  final Widget child;
  final bool miniplayer;
  final double radius;
  final double elevation;
  const GradientCard(
      {@required this.child, this.miniplayer, this.radius, this.elevation});
  @override
  _GradientCardState createState() => _GradientCardState();
}

class _GradientCardState extends State<GradientCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //elevation: 10,
      //shadowColor: Palette.primaryColor,
      /*shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(widget.radius ?? 10.0),
      ),
      clipBehavior: Clip.antiAlias,*/

      //margin: EdgeInsets.zero,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: currentTheme.getCardGradient(
                miniplayer: widget.miniplayer ?? false),
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
