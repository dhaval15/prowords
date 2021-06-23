import 'package:flutter/material.dart';
import '../styles/styles.dart';
import 'loading_indicator.dart';

class FancyDialog extends StatelessWidget {
  final bool back;
  final String label;
  final Color? labelColor;
  final Widget? body;
  final List<Widget> actions;

  const FancyDialog({
    required this.back,
    required this.label,
    this.actions = const [],
    this.labelColor,
    this.body,
  });

  static loading(BuildContext context,
          {required String label, bool back = false}) =>
      showDialog(
        context: context,
        builder: (context) => LoadingDialog(
          label: label,
          back: back,
        ),
        barrierDismissible: back,
      );

  static Future<bool> confirmation(
    BuildContext context, {
    required String label,
    IconData yes = Icons.done,
    IconData no = Icons.close,
    bool warning = true,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        label: label,
        warning: warning,
        yes: yes,
        no: no,
      ),
    );
    return result ?? false;
  }

  static Future<String?> field(
    BuildContext context, {
    required String label,
    IconData yes = Icons.done,
    IconData no = Icons.close,
    String value = '',
    String? Function(String? text)? validator,
  }) async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => FieldDialog(
        label: label,
        validator: validator,
        yes: yes,
        no: no,
        value: value,
      ),
    );
    return result;
  }

  static info(
    BuildContext context, {
    required String label,
    IconData action = Icons.done,
  }) =>
      showDialog(
        context: context,
        builder: (context) => InfoDialog(
          label: label,
          action: action,
        ),
        barrierDismissible: true,
      );

  @override
  Widget build(BuildContext context) {
    final scheme = Scheme.of(context);
    return WillPopScope(
      onWillPop: () => Future.value(back),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          decoration: BoxDecoration(
            color: scheme.background,
            boxShadow: [
              BoxShadow(
                color: scheme.dark.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: 12,
              ),
            ],
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width * 0.6,
            ),
            child: Material(
              color: Colors.transparent,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 16),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: labelColor,
                    ),
                  ),
                  if (body != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: body!,
                    ),
                  if (actions.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: actions,
                      ),
                    ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class InfoDialog extends StatelessWidget {
  final String label;
  final IconData action;

  const InfoDialog({
    required this.label,
    this.action = Icons.done,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Scheme.of(context);
    return FancyDialog(
      back: true,
      label: 'INFO',
      labelColor: Color(0xFF3F69AA),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(label),
      ),
      actions: [
        FloatingActionButton(
          backgroundColor: scheme.onBackground.withOpacity(0.1),
          foregroundColor: scheme.onBackground,
          elevation: 0,
          mini: true,
          child: Icon(action),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class ConfirmationDialog extends StatelessWidget {
  final String label;
  final IconData yes;
  final IconData no;
  final bool warning;

  const ConfirmationDialog({
    required this.label,
    this.yes = Icons.done,
    this.no = Icons.close,
    this.warning = false,
  });
  @override
  Widget build(BuildContext context) {
    final scheme = Scheme.of(context);
    return FancyDialog(
      back: true,
      label: 'WARNING',
      labelColor: warning ? Color(0xFFCD212A) : scheme.onBackground,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Text(label),
      ),
      actions: [
        FloatingActionButton(
          backgroundColor: scheme.onBackground.withOpacity(0.1),
          foregroundColor: scheme.onBackground,
          elevation: 0,
          mini: true,
          child: Icon(no),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        FloatingActionButton(
          backgroundColor: warning ? Color(0xFFCD212A) : Color(0xFF1E9638),
          foregroundColor: scheme.light,
          elevation: 0,
          mini: true,
          child: Icon(yes),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}

class LoadingDialog extends StatelessWidget {
  final bool back;
  final String label;

  const LoadingDialog({
    required this.back,
    required this.label,
  });
  @override
  Widget build(BuildContext context) {
    return FancyDialog(
      back: back,
      label: label,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BouncingDotsIndiactor(),
      ),
    );
  }
}

class FieldDialog extends StatefulWidget {
  final String label;
  final IconData yes;
  final IconData no;
  final String value;
  final String? Function(String? text)? validator;

  const FieldDialog({
    required this.label,
    this.yes = Icons.done,
    this.no = Icons.close,
    this.validator,
    this.value = '',
  });

  @override
  _FieldDialogState createState() => _FieldDialogState();
}

class _FieldDialogState extends State<FieldDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _text;

  @override
  void initState() {
    super.initState();
    _text = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Scheme.of(context);
    return FancyDialog(
      back: true,
      label: widget.label,
      labelColor: scheme.onBackground,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Form(
          key: _formKey,
          child: TextFormField(
            controller: TextEditingController(text: _text),
            validator: widget.validator,
            onSaved: (text) {
              _text = text!;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                    color: scheme.onBackground.withOpacity(0.2), width: 1),
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
        ),
      ),
      actions: [
        FloatingActionButton(
          backgroundColor: scheme.onBackground.withOpacity(0.1),
          foregroundColor: scheme.onBackground,
          elevation: 0,
          mini: true,
          child: Icon(widget.no),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        FloatingActionButton(
          backgroundColor: Color(0xFF1E9638),
          foregroundColor: scheme.light,
          elevation: 0,
          mini: true,
          child: Icon(widget.yes),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(context).pop(_text);
            }
          },
        ),
      ],
    );
  }
}
