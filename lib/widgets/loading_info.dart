import 'package:flutter/material.dart';

class LoadingInfo extends StatelessWidget {
  Stream<bool> isLoading;
  LoadingInfo(this.isLoading);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: isLoading,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {

          if(snapshot.hasData && snapshot.data)
            {
              return CircularProgressIndicator();
            }
            else return (Container());
        });
  }
}