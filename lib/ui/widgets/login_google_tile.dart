import 'package:flutter/material.dart';
import 'package:pispapp/ui/widgets/title_text.dart';

class LoginWithGoogleTile extends StatelessWidget {
  const LoginWithGoogleTile({Key key, this.trailingWidget, this.onTap})
      : super(key: key);

  final Widget trailingWidget;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(),
      title: const TitleText(
        'Sign in with Google',
        fontSize: 14,
      ),
      trailing: trailingWidget,
      onTap: onTap,
    );
  }
}
