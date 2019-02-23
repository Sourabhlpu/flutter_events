import 'package:flutter/material.dart';

class LoadingInfo extends StatelessWidget {
  final Stream<bool> isLoading;
  final Widget child;
  final double opacity;
  LoadingInfo({@required this.isLoading, this.child, this.opacity = 0.3});

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = List<Widget>();
    widgets.add(child);

    return StreamBuilder(
        stream: isLoading,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData && snapshot.data) {
            widgets.add(_buildProgressDialog(context));
            return Stack(
              children: widgets,
            );
          } else {
            return child;
          }
        });
  }

  Widget _buildProgressDialog(BuildContext context) {
    Widget modal = Opacity(
      opacity: opacity,
      child: Stack(
        children: <Widget>[
          ModalBarrier(
            dismissible: false,
            color: Colors.grey,
          ),
          Center(child: CircularProgressIndicator())
        ],
      ),
    );

    return modal;
  }
}
