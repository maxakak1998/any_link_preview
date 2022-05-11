import 'dart:convert';
import 'package:flutter/material.dart';

class LinkViewHorizontal extends StatefulWidget {
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

  LinkViewHorizontal({
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
  State<LinkViewHorizontal> createState() => _LinkViewHorizontalState();
}

class _LinkViewHorizontalState extends State<LinkViewHorizontal> {
  bool _isError = false;

  double computeTitleFontSize(double width) {
    var size = width * 0.13;
    if (size > 15) {
      size = 15;
    }
    return size;
  }

  int computeTitleLines(layoutHeight) {
    return layoutHeight >= 100 ? 2 : 1;
  }

  int computeBodyLines(layoutHeight) {
    var lines = 1;
    if (layoutHeight > 40) {
      lines += (layoutHeight - 40.0) ~/ 15.0 as int;
    }
    return lines;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var layoutWidth = constraints.biggest.width;
        var layoutHeight = constraints.biggest.height;

        var _titleFontSize = widget.titleTextStyle ??
            TextStyle(
              fontSize: computeTitleFontSize(layoutWidth),
              color: Colors.black,
              fontWeight: FontWeight.bold,
            );
        var _bodyFontSize = widget.bodyTextStyle ??
            TextStyle(
              fontSize: computeTitleFontSize(layoutWidth) - 1,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            );

        ImageProvider? _img = widget.imageUri != '' ? NetworkImage(widget.imageUri) : null;
        if (widget.imageUri.startsWith('data:image')) {
          _img = MemoryImage(
            base64Decode(widget.imageUri.substring(widget.imageUri.indexOf('base64') + 7)),
          );
        }

        return InkWell(
          onTap: () => widget.onTap(),
          child: Row(
            children: <Widget>[
              widget.showMultiMedia!
                  ? Expanded(
                      flex: 2,
                      child: _img == null
                          ? Container(color: widget.bgColor ?? Colors.grey)
                          : Container(
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                image: _isError
                                    ? null
                                    : DecorationImage(
                                        image: _img,
                                        fit: BoxFit.cover,
                                        onError: (e, s) {
                                          if (!_isError) {
                                            setState(() {
                                              print(
                                                  'Preview link image error is $e');
                                            });
                                            _isError = true;
                                          }
                                        },
                                      ),
                                borderRadius: widget.radius == 0
                                    ? BorderRadius.zero
                                    : BorderRadius.only(
                                        topLeft: Radius.circular(widget.radius!),
                                        bottomLeft: Radius.circular(widget.radius!),
                                      ),
                              ),
                              child: _isError ? widget.errorWidget : const SizedBox(),
                            ),
                    )
                  : SizedBox(width: 5),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildTitleContainer(
                          _titleFontSize, computeTitleLines(layoutHeight)),
                      _buildBodyContainer(
                          _bodyFontSize, computeBodyLines(layoutHeight))
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTitleContainer(TextStyle _titleTS, _maxLines) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 3, 1),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment(-1.0, -1.0),
            child: Text(
              widget.title,
              style: _titleTS,
              overflow: TextOverflow.ellipsis,
              maxLines: _maxLines,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContainer(TextStyle _bodyTS, _maxLines) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment(-1.0, -1.0),
                child: Text(
                  widget.description,
                  textAlign: TextAlign.left,
                  style: _bodyTS,
                  overflow: widget.bodyTextOverflow ?? TextOverflow.ellipsis,
                  maxLines: widget.bodyMaxLines ?? _maxLines,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
