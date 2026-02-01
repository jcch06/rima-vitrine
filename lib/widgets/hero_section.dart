import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/site_config.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Container(
      width: double.infinity,
      height: isDesktop ? 600 : 500,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(SiteConfig.heroImage),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.4),
            BlendMode.darken,
          ),
          onError: (_, __) {},
        ),
        color: SiteConfig.primaryColor.withOpacity(0.8),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                SiteConfig.businessName,
                style: TextStyle(
                  fontSize: isDesktop ? 56 : 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                SiteConfig.tagline,
                style: TextStyle(
                  fontSize: isDesktop ? 24 : 18,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => launchUrl(Uri.parse(SiteConfig.storeUrl)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: SiteConfig.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 18,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Commander maintenant',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
