import 'package:flutter/material.dart';

class CardHeader extends StatelessWidget {
  final String title;

  const CardHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start:6,end:6),
      child: Container(
        width: double.infinity,
        decoration: new BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(10.0),
            topRight: const Radius.circular(10.0),
          )
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(title, 
            style: TextStyle(
              color: Colors.white,
              fontSize: 20, 
            ),
            textAlign: TextAlign.center,
          )
        ),
      ),
    );
  }
}