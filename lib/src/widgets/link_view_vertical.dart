import 'dart:convert';
import 'package:flutter/material.dart';

class LinkViewVertical extends StatefulWidget {
  final String url;
  final String title;
  final String description;
  final String imageUri;
  final Function() onTap;
  final TextStyle? titleTextStyle;
  final TextStyle? bodyTextStyle;
  final bool? showMultiMedia;
  final TextOverflow? bodyTextOverflow;
  final int? bodyMaxLines;
  final double? radius;
  final Color? bgColor;
  final Widget errorWidget;

  LinkViewVertical({
    Key? key,
    required this.url,
    required this.title,
    required this.description,
    required this.imageUri,
    required this.onTap,
    this.titleTextStyle,
    this.bodyTextStyle,
    this.showMultiMedia,
    this.bodyTextOverflow,
    this.bodyMaxLines,
    this.bgColor,
    this.radius,
    this.errorWidget = const SizedBox(),
  }) : super(key: key);

  @override
  State<LinkViewVertical> createState() => _LinkViewVerticalState();
}

class _LinkViewVerticalState extends State<LinkViewVertical> {
   bool _isError = false;

  double computeTitleFontSize(double height) {
    var size = height * 0.13;
    if (size > 15) {
      size = 15;
    }
    return size;
  }

  int computeTitleLines(layoutHeight, layoutWidth) {
    return layoutHeight - layoutWidth < 50 ? 1 : 2;
  }

  int? computeBodyLines(layoutHeight) {
    return layoutHeight ~/ 60 == 0 ? 1 : layoutHeight ~/ 60;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      var layoutWidth = constraints.biggest.width;
      var layoutHeight = constraints.biggest.height;

      var _titleTS = widget.titleTextStyle ??
          TextStyle(
            fontSize: computeTitleFontSize(layoutHeight),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          );
      var _bodyTS = widget.bodyTextStyle ??
          TextStyle(
            fontSize: computeTitleFontSize(layoutHeight) - 1,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          );

      ImageProvider? _img =
          widget.imageUri != '' ? NetworkImage(widget.imageUri) : null;
      if (widget.imageUri.startsWith('data:image')) {
        _img = MemoryImage(
          base64Decode(
              widget.imageUri.substring(widget.imageUri.indexOf('base64') + 7)),
        );
      }

      return InkWell(
          onTap: () => widget.onTap(),
          child: Column(
            children: <Widget>[
              widget.showMultiMedia!
                  ? Expanded(
                      flex: 2,
                      child: _img == null
                          ? Container(color: widget.bgColor ?? Colors.grey)
                          : Container(
                              padding: EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                borderRadius: widget.radius == 0
                                    ? BorderRadius.zero
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                image: _isError
                                    ? null
                                    : DecorationImage(
                                        image: _img,
                                        onError: (e, s) {
                                          if(!_isError) {
                                            setState(() {
                                            print(
                                                'Preview link image error is $e');
                                          });
                                          _isError=true;
                                          }
                                        },
                                        fit: BoxFit.fitWidth,
                                      ),
                              ),
                              child: _isError
                                  ? widget.errorWidget
                                  : const SizedBox(),
                            ),
                    )
                  : SizedBox(height: 5),
              _buildTitleContainer(
                  _titleTS, computeTitleLines(layoutHeight, layoutWidth)),
              _buildBodyContainer(_bodyTS, computeBodyLines(layoutHeight)),
            ],
          ));
    });
  }

  Widget _buildTitleContainer(TextStyle _titleTS, _maxLines) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 5, 1),
      child: Container(
        alignment: Alignment(-1.0, -1.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.title,
              style: _titleTS,
              overflow: TextOverflow.ellipsis,
              maxLines: _maxLines,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBodyContainer(TextStyle _bodyTS, _maxLines) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 5, 5),
        child: Container(
          alignment: Alignment(-1.0, -1.0),
          child: Text(
            widget.description,
            style: _bodyTS,
            overflow: widget.bodyTextOverflow ?? TextOverflow.ellipsis,
            maxLines: widget.bodyMaxLines ?? _maxLines,
          ),
        ),
      ),
    );
  }
}
