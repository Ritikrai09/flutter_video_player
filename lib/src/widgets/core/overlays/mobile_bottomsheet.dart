part of 'package:pod_player_2/src/pod_player.dart';

class _MobileBottomSheet extends StatelessWidget {
  final String tag;

  const _MobileBottomSheet({
    required this.tag,
  
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PodGetXVideoController>(
      tag: tag,
      builder: (podCtr) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (podCtr.vimeoOrVideoUrls.isNotEmpty)
            _bottomSheetTiles(
              title: podCtr.podPlayerLabels.quality,
              icon: Icons.video_settings_rounded,
              subText: '${podCtr.vimeoPlayingVideoQuality}p',
              onTap: () {
                Navigator.of(context).pop();
                Timer(const Duration(milliseconds: 100), () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (context) => SafeArea(
                      child: _VideoQualitySelectorMob(
                        tag: tag,
                        onTap: null,
                      ),
                    ),
                  );
                });
                // await Future.delayed(
                //   const Duration(milliseconds: 100),
                // );
              },
            ),
          _bottomSheetTiles(
            title: podCtr.podPlayerLabels.loopVideo,
            icon: Icons.loop_rounded,
            subText: podCtr.isLooping
                ? podCtr.podPlayerLabels.optionEnabled
                : podCtr.podPlayerLabels.optionDisabled,
            onTap: () {
              Navigator.of(context).pop();
              podCtr.toggleLooping();
            },
          ),
          _bottomSheetTiles(
            title: podCtr.podPlayerLabels.playbackSpeed,
            icon: Icons.slow_motion_video_rounded,
            subText: podCtr.currentPaybackSpeed,
            onTap: () {
              Navigator.of(context).pop();
              Timer(const Duration(milliseconds: 100), () {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => SafeArea(
                    child: _VideoPlaybackSelectorMob(
                      tag: tag,
                      onTap: null,
                    ),
                  ),
                );
              });
            },
          ),
        ],
      ),
    );
  }

  ListTile _bottomSheetTiles({
    required String title,
    required IconData icon,
    String? subText,
    void Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      onTap: onTap,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Text(
              title,
            ),
            if (subText != null) const SizedBox(width: 6),
            if (subText != null)
              const SizedBox(
                height: 4,
                width: 4,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            if (subText != null) const SizedBox(width: 6),
            if (subText != null)
              Text(
                subText,
                style: const TextStyle(color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }
}

class _VideoQualitySelectorMob extends StatelessWidget {
  final void Function()? onTap;
  final String tag;

  const _VideoQualitySelectorMob({
    required this.onTap,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final podCtr = Get.find<PodGetXVideoController>(tag: tag);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: podCtr.vimeoOrVideoUrls
            .map(
              (e) => ListTile(
                title: Text('${e.quality}p'),
                onTap: () {
                  onTap != null ? onTap!() : Navigator.of(context).pop();

                  podCtr.changeVideoQuality(e.quality);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _VideoPlaybackSelectorMob extends StatelessWidget {
  final void Function()? onTap;
  final String tag;

  const _VideoPlaybackSelectorMob({
    required this.onTap,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final podCtr = Get.find<PodGetXVideoController>(tag: tag);
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: podCtr.videoPlaybackSpeeds
            .map(
              (e) => ListTile(
                title: Text(e),
                onTap: () {
                  onTap != null ? onTap!() : Navigator.of(context).pop();
                  podCtr.setVideoPlayBack(e);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class _MobileOverlayBottomControlles extends StatelessWidget {
  final String tag;
  final bool showDuration;
  final bool showFullScreen;

  const _MobileOverlayBottomControlles({
    required this.tag,
    this.showDuration=true,
    this.showFullScreen=true,
  });

  @override
  Widget build(BuildContext context) {
    const durationTextStyle = TextStyle(color: Colors.white70);
    const itemColor = Colors.white;

    return GetBuilder<PodGetXVideoController>(
      tag: tag,
      id: 'full-screen',
      builder: (podCtr) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                const SizedBox(width: 12),
                if(podCtr.podPlayerConfig.showDuration == true)
                GetBuilder<PodGetXVideoController>(
                  tag: tag,
                  id: 'video-progress',
                  builder: (podCtr) {
                    return Row(
                      children: [
                        Text(
                          podCtr.calculateVideoDuration(podCtr.videoPosition),
                          style: const TextStyle(color: itemColor),
                        ),
                        const Text(
                          ' / ',
                          style: durationTextStyle,
                        ),
                        Text(
                          podCtr.calculateVideoDuration(podCtr.videoDuration),
                          style: durationTextStyle,
                        ),
                      ],
                    );
                  },
                ),
                if(podCtr.podPlayerConfig.showDuration == true)
                const SizedBox(width : 12),
                if(podCtr.podPlayerConfig.playerIcon != null)
                podCtr.podPlayerConfig.playerIcon ?? const SizedBox(),
                const Spacer(),
                if(podCtr.podPlayerConfig.showMute == true)
                  GetBuilder<PodGetXVideoController>(
                  tag: tag,
                  id: 'volume',
                  builder: (podCtr) => MaterialIconButton(
                    toolTipMesg: podCtr.isMute
                        ? podCtr.podPlayerLabels.unmute ??
                            'Unmute${kIsWeb ? ' (m)' : ''}'
                        : podCtr.podPlayerLabels.mute ??
                            'Mute${kIsWeb ? ' (m)' : ''}',
                    color: itemColor,
                    onPressed: podCtr.toggleMute,
                    child: Icon(
                      podCtr.isMute
                          ? Icons.volume_off_rounded
                          : Icons.volume_up_rounded,
                    ),
                  ),
                ),
                if(podCtr.podPlayerConfig.showFullScreen == true)
                MaterialIconButton(
                  toolTipMesg: podCtr.isFullScreen
                      ? podCtr.podPlayerLabels.exitFullScreen ??
                          'Exit full screen${kIsWeb ? ' (f)' : ''}'
                      : podCtr.podPlayerLabels.fullscreen ??
                          'Fullscreen${kIsWeb ? ' (f)' : ''}',
                  color: itemColor,
                  onPressed: () {
                    if (podCtr.isOverlayVisible) {
                      if (podCtr.isFullScreen) {
                        podCtr.disableFullScreen(context, tag);
                      } else {
                        podCtr.enableFullScreen(tag,showDuration,showFullScreen);
                      }
                    } else {
                      podCtr.toggleVideoOverlay();
                    }
                  },
                  child: Icon(
                    podCtr.isFullScreen
                        ? Icons.fullscreen_exit
                        : Icons.fullscreen,
                  ),
                ),
              ],
            ),
          ),
          GetBuilder<PodGetXVideoController>(
            tag: tag,
            id: 'overlay',
            builder: (podCtr) {
              if (podCtr.isFullScreen) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                  child: Visibility(
                    visible: podCtr.isOverlayVisible,
                    child: PodProgressBar(
                      tag: tag,
                      alignment: Alignment.topCenter,
                      podProgressBarConfig: podCtr.podProgressBarConfig,
                    ),
                  ),
                );
              }
              return PodProgressBar(
                tag: tag,
                alignment: Alignment.bottomCenter,
                podProgressBarConfig: podCtr.podProgressBarConfig,
              );
            },
          ),
        ],
      ),
    );
  }
}
