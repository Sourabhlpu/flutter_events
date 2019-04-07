import 'package:built_collection/built_collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_events/models/interests/interest.dart';
import 'package:flutter_events/ui/widgets/add_splash.dart';

/*
 * This class creates a horizontal list. Here we are using it for the user interests and
 * the event type
 */
class HorizontalListWithTitle extends StatefulWidget {
  final String title;
  final List<dynamic> list;
  final bool isListExpandable;
  final Function onTap;

  /*
   * @param title
   */
  HorizontalListWithTitle({this.title, this.list, this.isListExpandable,this.onTap});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HorizontalListWithTitleState();
  }
}

class HorizontalListWithTitleState extends State<HorizontalListWithTitle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            widget.title,
            style: TextStyle(fontFamily: 'AvenirLight', fontSize: 12),
          ),
        ),
        _buildHorizontalList()
      ],
    );
  }

  _buildHorizontalList() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Container(
        height: 30,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.isListExpandable
                ? widget.list.length + 1
                : widget.list.length,
            itemBuilder: (BuildContext context, int index) {
              int actualIndex = widget.isListExpandable ? index - 1 : index;
              return (widget.isListExpandable && index == 0)
                  ? _buildAddInterestButton(context)
                  : _buildHorizontalListItem(
                      widget.list[actualIndex].interestName, actualIndex);
            }),
      ),
    );
  }

  Container _buildAddInterestButton(BuildContext context) {
    return Container(
      height: 30,
      width: 30,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
          gradient: LinearGradient(
              colors: [const Color(0xFFDF69DD), const Color(0xFFED5D66)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight)),
      child: Center(
          child: IconButton(
              icon: Icon(Icons.add),
              iconSize: 15,
              color: Colors.white,
              onPressed: () {})),
    );
  }

  _buildHorizontalListItem(String interest, int index) {
    bool isSelected = widget.list[index].isSelected;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: AddSplash(
        onTap: (){
          widget.onTap(index);
        },
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  border: Border.all(
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(colors: [
                    const Color(0xFFDF69DD),
                    const Color(0xFFED5D66)
                  ], begin: Alignment.centerLeft, end: Alignment.centerRight))
              : BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.grey,
                    width: 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(15)),
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              interest,
              style: TextStyle(
                  fontFamily: 'AvenirLight',
                  fontSize: 14,
                  color: isSelected ? Colors.white : Colors.black),
            ),
          )),
        ),
      ),
    );
  }
}
