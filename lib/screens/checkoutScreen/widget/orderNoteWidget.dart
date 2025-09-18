import 'package:project/helper/utils/generalImports.dart';


class OrderNoteWidget extends StatefulWidget {
  final TextEditingController edtOrderNote;

  OrderNoteWidget({super.key, required this.edtOrderNote});

  @override
  State<OrderNoteWidget> createState() => _OrderNoteWidgetState();
}

class _OrderNoteWidgetState extends State<OrderNoteWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
      child: ExpansionTile(
        backgroundColor: ColorsRes.subTitleMainTextColor.withValues(alpha:0.2),
        title: CustomTextLabel(
          jsonKey: orderNoteLabel,
        ),
        trailing: Icon(
          _isExpanded ? Icons.remove_circle_outline : Icons.add_circle_outline,
          color: ColorsRes.mainTextColor,
          size: 20,
        ),
        collapsedShape: null,
        dense: true,
        tilePadding: EdgeInsetsDirectional.only(start: 10, end: 15),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        collapsedBackgroundColor:
            ColorsRes.subTitleMainTextColor.withValues(alpha:0.2),
        visualDensity: VisualDensity.compact,
        shape: null,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                editBoxWidget(
                  context,
                  context.read<CheckoutProvider>().edtOrderNote,
                  optionalValidation,
                  getTranslatedValue(context, addNoteLabel),
                  "",
                  TextInputType.text,
                  minLines: 3,
                  maxLines: 6,
                  maxLength: 191,
                  isLastField: true,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      context.read<CheckoutProvider>().edtOrderNote.clear();
                    },
                    child: CustomTextLabel(
                      jsonKey: clearNoteLabel,
                      style: TextStyle(color: ColorsRes.appColorRed),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
