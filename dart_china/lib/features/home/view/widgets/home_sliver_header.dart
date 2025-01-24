part of 'widgets.dart';

class HomeSliverHeader extends SliverPersistentHeaderDelegate {
  HomeSliverHeader({
    required this.onMenuPressed,
    required this.onSearchPressed,
    required this.onAddPressed,
    this.badge = false,
  });

  final bool badge;
  final VoidCallback onMenuPressed;
  final VoidCallback onSearchPressed;
  final VoidCallback? onAddPressed;
  final double _expandedHeight = 130;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double welcomeHeight = _expandedHeight - kToolbarHeight;
    final offset = welcomeHeight - shrinkOffset;

    double percent = offset / welcomeHeight;
    if (percent < 0) {
      percent = 0;
    }
    return SizedBox(
      height: _expandedHeight,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Opacity(
              opacity: percent,
              child: SizedBox(
                height: 70,
                width: double.infinity,
                child: WelcomeBlock(
                  onSearchPressed: onSearchPressed,
                ),
              ),
            ),
          ),
          SizedBox(
            height: kToolbarHeight,
            child: _buildAppBar(context, percent == 0),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, [bool titleVisiable = false]) {
    Widget menuButton = IconButton(
      icon: badge
          ? badges.Badge(
              child: Icon(Icons.menu),
              position: badges.BadgePosition.topEnd(top: 0, end: -2))
          : Icon(Icons.menu),
      splashRadius: kSplashRadius,
      onPressed: () {
        onMenuPressed.call();
      },
    );

    return AppBar(
      centerTitle: true,
      backgroundColor:
          titleVisiable ? ColorPalette.homeBackgroundColor : Colors.transparent,
      elevation: 0,
      leading: menuButton,
      title: titleVisiable
          ? Text(
              'Dart China',
              style: TextStyle(
                color: Colors.grey.shade100,
                fontWeight: FontWeight.w500,
              ),
            )
          : null,
      actions: [
        onAddPressed == null
            ? SizedBox.shrink()
            : IconButton(
                iconSize: 26,
                splashRadius: kSplashRadius,
                icon: Icon(Icons.add),
                onPressed: onAddPressed,
              )
      ],
    );
  }

  @override
  double get maxExtent => _expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
