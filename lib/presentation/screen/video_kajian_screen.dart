import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class KajianVideo {
  final String ustadz, channel, judul, deskripsi, videoId, thumbnailUrl;

  const KajianVideo({
    required this.ustadz,
    required this.channel,
    required this.judul,
    required this.deskripsi,
    required this.videoId,
    this.thumbnailUrl = '',
  });
}

class VideoKajianScreen extends StatelessWidget {
  const VideoKajianScreen({super.key});

  static const Color peach = Color(0xFFF28F70);
  static const Color background = Color(0xFFF7F1F8);

  static const List<KajianVideo> daftarVideo = [
    KajianVideo(
      ustadz: 'Ustadz Khalid Basalamah',
      channel: 'Khalid Basalamah Official',
      judul: 'Berbakti kepada Orang Tua',
      deskripsi: 'Orang tua adalah pintu surga kita. Hormati dan berbuat baiklah kepada kedua orang tua. Berbakti kepada orang tua termasuk amalan yang sangat utama. Raihlah rida kedua orang tua dan mintalah doa mereka.',
      videoId: 'o_V5TZleL88',
    ),
    KajianVideo(
      ustadz: 'Ustadz Dr. Firanda Andirja, M.A.',
      channel: 'Firanda Andirja',
      judul: 'Bentuk Syukur',
      deskripsi: 'Kajian tentang makna syukur, cara mensyukuri nikmat Allah, dan menerapkan rasa syukur dalam kehidupan sehari-hari.',
      videoId: 'uEuHeJCzFug',
    ),
    KajianVideo(
      ustadz: 'Ustadz',
      channel: 'Kajian Islam',
      judul: 'Tujuan Hidup Seorang Muslim',
      deskripsi: 'Pembahasan mengenai tujuan hidup seorang muslim dan pentingnya menjadikan Al-Qur’an dan sunnah sebagai pedoman.',
      videoId: 'IZeCrBGPhSw',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: peach,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Video Kajian',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(12),
        itemCount: daftarVideo.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final video = daftarVideo[index];
          return _KajianCard(
            video: video,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailVideoKajianScreen(video: video),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _KajianCard extends StatelessWidget {
  final KajianVideo video;
  final VoidCallback onTap;

  const _KajianCard({required this.video, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final validId =
        video.videoId.isNotEmpty && !video.videoId.startsWith('GANTI_');
    final imageUrl = video.thumbnailUrl.isNotEmpty
        ? video.thumbnailUrl
        : 'https://img.youtube.com/vi/${video.videoId}/hqdefault.jpg';

    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      elevation: 1.5,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
        side: const BorderSide(color: Color(0xFFE7DDE9)),
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (validId || video.thumbnailUrl.isNotEmpty)
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _thumbnailFallback(),
                    )
                  else
                    _thumbnailFallback(),
                  Container(color: Colors.black.withOpacity(0.08)),
                  Center(
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF28F70).withOpacity(0.93),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 35),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.channel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.black45, fontSize: 11)),
                  const SizedBox(height: 5),
                  Text(video.ustadz,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          color: Color(0xFFF07855),
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 3),
                  Text(video.judul,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _thumbnailFallback() => Container(
        color: const Color(0xFFE7E1EC),
        child: const Center(
          child: Icon(Icons.ondemand_video_rounded,
              size: 54, color: Color(0xFF9B8FA3)),
        ),
      );
}

class DetailVideoKajianScreen extends StatefulWidget {
  final KajianVideo video;

  const DetailVideoKajianScreen({super.key, required this.video});

  @override
  State<DetailVideoKajianScreen> createState() =>
      _DetailVideoKajianScreenState();
}

class _DetailVideoKajianScreenState extends State<DetailVideoKajianScreen> {
  YoutubePlayerController? controller;
  bool videoIdValid = false;

  @override
  void initState() {
    super.initState();
    final id = widget.video.videoId.trim();
    videoIdValid = id.isNotEmpty && !id.startsWith('GANTI_');

    if (videoIdValid) {
      controller = YoutubePlayerController.fromVideoId(
        videoId: id,
        autoPlay: false,
        params: const YoutubePlayerParams(
          showControls: true,
          showFullscreenButton: true,
          strictRelatedVideos: true,
        ),
      );
    }
  }

  @override
  void dispose() {
    controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final video = widget.video;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF28F70),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(video.judul,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: videoIdValid && controller != null
                  ? YoutubePlayer(
                      controller: controller!,
                      aspectRatio: 16 / 9,
                    )
                  : Container(
                      color: const Color(0xFFE7E1EC),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'Video belum diatur.\nMasukkan ID YouTube pada daftarVideo.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.channel,
                      style:
                          const TextStyle(color: Colors.black45, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(video.ustadz,
                      style: const TextStyle(
                          color: Color(0xFFF07855),
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Text(video.judul,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  const Text('Deskripsi Kajian',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  Text(video.deskripsi,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 13, height: 1.65)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}