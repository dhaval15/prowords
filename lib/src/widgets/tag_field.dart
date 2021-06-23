import 'package:flutter/material.dart';

class TagsView extends StatelessWidget {
  final List<String> tags;
  final Color forground;

  const TagsView({
    required this.tags,
    required this.forground,
  });

  @override
  Widget build(BuildContext context) {
    final tagBg = forground.withOpacity(0.15);
    final dotBg = forground.withOpacity(0.5);
    return Wrap(
      children: tags
          .map((tag) => Container(
                padding: EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: dotBg,
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(tag),
                  ],
                ),
                decoration: BoxDecoration(
                  color: tagBg,
                  borderRadius: BorderRadius.circular(32),
                ),
              ))
          .toList(),
      runSpacing: 4,
      spacing: 4,
    );
  }
}

class TagField extends StatefulWidget {
  final Set<String> tags;
  final Set<String> selectedTags;
  final void Function(Set<String> tags) onChanged;

  const TagField({
    required this.tags,
    this.selectedTags = const {},
    required this.onChanged,
  });

  @override
  _TagFieldState createState() => _TagFieldState();
}

class _TagFieldState extends State<TagField> {
  late Set<String> _tags;

  @override
  void initState() {
    super.initState();
    _tags = Set.from(widget.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 6,
      spacing: 6,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: _buildChips().toList(),
    );
  }

  Iterable<Widget> _buildChips() sync* {
    ColorScheme scheme = Theme.of(context).colorScheme;
    final textColor = scheme.onSurface;
    for (final tag in _tags) {
      yield ActionChip(
        elevation: 0,
        pressElevation: 1,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        label: Text(tag),
        labelStyle: TextStyle(
          color: textColor,
        ),
        onPressed: () {
          setState(() {
            _tags.remove(tag);
          });
          widget.onChanged(_tags);
        },
      );
    }
    yield ActionChip(
      onPressed: () async {
        final tag = await AddTagDialog.show(context, _tags);
        if (tag != null) {
          setState(() {
            _tags.add(tag);
          });
          widget.onChanged(_tags);
        }
      },
      padding: const EdgeInsets.all(0),
      labelPadding: const EdgeInsets.symmetric(horizontal: 6),
      label: const Icon(
        Icons.add,
        size: 18,
      ),
    );
  }
}

class AddTagDialog extends StatefulWidget {
  final Set<String> tags;

  static Future<String?> show(BuildContext context, Set<String> tags) async {
    final result = await showDialog(
      context: context,
      builder: (context) => AddTagDialog(
        tags: tags,
      ),
    );
    return result;
  }

  const AddTagDialog({required this.tags});

  @override
  _AddTagDialogState createState() => _AddTagDialogState();
}

class _AddTagDialogState extends State<AddTagDialog> {
  final _formKey = GlobalKey<FormState>();
  String _tag = '';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add Tag',
              style: theme.textTheme.headline6,
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: TextEditingController(text: _tag),
                validator: (text) {
                  if (text!.trim().length < 3)
                    return 'Must be longer than 2 characters';
                  final value = text.trim().toLowerCase();
                  return widget.tags
                          .where((tag) => tag.toLowerCase() == value)
                          .isEmpty
                      ? null
                      : '$text already exist';
                },
                onSaved: (text) {
                  _tag = text!;
                },
                decoration: InputDecoration(labelText: 'Name'),
              ),
            ),
            const SizedBox(height: 20),
            MaterialButton(
              child: Text('ADD'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  Navigator.of(context).pop(_tag);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
