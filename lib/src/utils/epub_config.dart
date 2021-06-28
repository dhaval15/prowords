import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EpubConfig {
  final double padding;
  final String indent;
  final Color fontColor;
  final Color linkColor;
  final Color backgroundColor;
  final double fontSize;
  final String fontFace;
  final TextAlign textAlign;
  final double lineHeight;
  final double paragraphSpacing;
  final FontWeight fontWeight;

  static const defaultDark = EpubConfig(
    padding: 8,
    indent: '    ',
    fontColor: Color(0xFFEEEEEE),
    linkColor: Colors.indigo,
    backgroundColor: Color(0xFF222222),
    fontSize: 16,
    fontFace: 'NONE',
    textAlign: TextAlign.justify,
    lineHeight: 1.2,
    paragraphSpacing: 4,
    fontWeight: FontWeight.normal,
  );

  static const defaultLight = EpubConfig(
    padding: 8,
    indent: '    ',
    backgroundColor: Color(0xFFEEEEEE),
    linkColor: Colors.indigo,
    fontColor: Color(0xFF222222),
    fontSize: 16,
    fontFace: 'NONE',
    textAlign: TextAlign.justify,
    lineHeight: 1.2,
    paragraphSpacing: 4,
    fontWeight: FontWeight.normal,
  );

  const EpubConfig({
    required this.padding,
    required this.indent,
    required this.fontColor,
    required this.linkColor,
    required this.backgroundColor,
    required this.fontSize,
    required this.fontFace,
    required this.textAlign,
    required this.lineHeight,
    required this.paragraphSpacing,
    required this.fontWeight,
  });

  factory EpubConfig.fromJson(Map<String, dynamic> json) => EpubConfig(
        padding: json['padding'],
        indent: json['indent'],
        fontColor: Color(json['fontColor']),
        linkColor: Color(json['linkColor']),
        backgroundColor: Color(json['backgroundColor']),
        fontSize: json['fontSize'],
        fontFace: json['fontFace'],
        textAlign: TextAlign.values[json['textAlign']],
        lineHeight: json['lineHeight'],
        paragraphSpacing: json['paragraphSpacing'],
        fontWeight: FontWeight.values[json['fontWeight'] - 1],
      );

  EpubConfig copyWith({
    double? padding,
    String? indent,
    Color? fontColor,
    Color? linkColor,
    Color? backgroundColor,
    double? fontSize,
    String? fontFace,
    TextAlign? textAlign,
    double? lineHeight,
    double? paragraphSpacing,
    FontWeight? fontWeight,
  }) =>
      EpubConfig(
        padding: padding ?? this.padding,
        indent: indent ?? this.indent,
        fontColor: fontColor ?? this.fontColor,
        linkColor: linkColor ?? this.linkColor,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        fontSize: fontSize ?? this.fontSize,
        fontFace: fontFace ?? this.fontFace,
        textAlign: textAlign ?? this.textAlign,
        lineHeight: lineHeight ?? this.lineHeight,
        paragraphSpacing: paragraphSpacing ?? this.paragraphSpacing,
        fontWeight: fontWeight ?? this.fontWeight,
      );

  Map<String, dynamic> toJson() => {
        'padding': padding,
        'indent': indent,
        'fontColor': fontColor.value,
        'linkColor': linkColor.value,
        'backgroundColor': backgroundColor.value,
        'fontSize': fontSize,
        'fontFace': fontFace,
        'textAlign': textAlign.index,
        'lineHeight': lineHeight,
        'paragraphSpacing': paragraphSpacing,
        'fontWeight': fontWeight.index + 1,
      };

  TextStyle get textStyle => fontFace == 'NONE'
      ? TextStyle(
          color: fontColor,
          fontSize: fontSize,
          height: lineHeight,
          fontWeight: fontWeight,
        )
      : GoogleFonts.asMap()[fontFace]!.call().copyWith(
            color: fontColor,
            fontSize: fontSize,
            height: lineHeight,
            fontWeight: fontWeight,
          );
}
