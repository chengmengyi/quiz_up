import 'package:flutter/material.dart';

class OverlayUtils{
  static final OverlayUtils _instance = OverlayUtils();

  static OverlayUtils get instance => _instance;

  OverlayEntry? _overlayEntry;

  showOver({
    required BuildContext context,
    required Widget widget,
  }){
    _overlayEntry=OverlayEntry(builder: (_)=>widget);
    Overlay.of(context).insert(_overlayEntry!);
  }

  hideOver(){
    _overlayEntry?.remove();
    _overlayEntry=null;
  }
}