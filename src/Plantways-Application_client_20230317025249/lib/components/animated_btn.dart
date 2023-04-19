import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class AnimatedBtn extends StatelessWidget {
  const AnimatedBtn({
    Key? key,
    required RiveAnimationController btnAnimationController,
    required this.press,
  })  : _btnAnimationController = btnAnimationController,
        super(key: key);

  final RiveAnimationController _btnAnimationController;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: 70,
        width: 236,
        child: Stack(
          children: [
            RiveAnimation.asset(
              "assets/RiveAssets/button-green.riv",
              controllers: [_btnAnimationController],
            ),
            Positioned.fill(
              top: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.arrow_right),
                  const SizedBox(width: 22),
                  Text(
                    "Connect Smart Planter",
                    // style: Theme.of(context).textTheme.button,
                    style: Theme.of(context).textTheme.labelLarge,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AnimatedBtn2 extends StatelessWidget {
  const AnimatedBtn2({
    Key? key,
    required RiveAnimationController btnAnimationController2,
    required this.press,
  })  : _btnAnimationController2 = btnAnimationController2,
        super(key: key);

  final RiveAnimationController _btnAnimationController2;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: 70,
        width: 236,
        child: Stack(
          children: [
            RiveAnimation.asset(
              "assets/RiveAssets/button-green.riv",
              controllers: [_btnAnimationController2],
            ),
            Positioned.fill(
              top: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.arrow_right),
                  const SizedBox(width: 22),
                  Text(
                    "New to Smart Planter",
                    style: Theme.of(context).textTheme.labelLarge,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class AnimatedBtn3 extends StatelessWidget {
  const AnimatedBtn3({
    Key? key,
    required RiveAnimationController btnAnimationController2,
    required this.press,
  })  : _btnAnimationController3 = btnAnimationController2,
        super(key: key);

  final RiveAnimationController _btnAnimationController3;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
        height: 70,
        width: 70,
        child: Stack(
          children: [
            RiveAnimation.asset(
              "assets/RiveAssets/add-plant-button.riv",
              controllers: [_btnAnimationController3],
            ),
            Positioned.fill(
              top: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(CupertinoIcons.arrow_right),
                  const SizedBox(width: 10),
                  Text(
                    "Add Smart Planter",
                    style: Theme.of(context).textTheme.labelLarge,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
