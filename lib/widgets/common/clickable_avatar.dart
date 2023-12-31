import 'package:flutter/material.dart';

class ClickableAvatar extends StatelessWidget {
  const ClickableAvatar({Key? key, required this.image, this.onTap, this.child}) : super(key: key);

  final ImageProvider<Object>? image;
  final void Function()? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        image: image != null ?DecorationImage(
          fit: BoxFit.cover,
          image: image!,
        ) : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(100),
        onTap: onTap,
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
          ),
          child: child,
        ),
      ),
    );
  }
}
