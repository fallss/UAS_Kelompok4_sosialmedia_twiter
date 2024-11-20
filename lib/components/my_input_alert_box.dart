import 'package:flutter/material.dart';


class MyInputAlertBox extends StatelessWidget {

  final TextEditingController textController;
  final String hinText;
  final void Function()? onPressed;
  final String onPressedText;


  const MyInputAlertBox({
    super.key,
    required this.textController,
    required this.hinText,
    required this.onPressed,
    required this.onPressedText,
     });

  @override
  Widget build(BuildContext context) {

    // Alert Dialog
    return  AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),

      backgroundColor: Theme.of(context).colorScheme.surface,

      content: TextField(
        controller: textController,

        maxLength: 500,
        maxLines: 9,

        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder:  OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(12),
          ),

          hintText: hinText,
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),

          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,

          counterStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    actions: [
      TextButton(
        onPressed:() {
          Navigator.pop(context);

          textController.clear();
        } ,
        child:const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
             Navigator.pop(context);

             onPressed!();

             textController.clear();
          },
          child: Text(onPressedText),
          )
    ],

    );
  }
}