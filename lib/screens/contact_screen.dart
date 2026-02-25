import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/site_config.dart';
import '../widgets/navbar.dart';
import '../widgets/footer.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      final subject = Uri.encodeComponent('Message de ${_nameController.text}');
      final body = Uri.encodeComponent(
        '${_messageController.text}\n\n---\nEnvoyé par: ${_nameController.text}\nEmail: ${_emailController.text}',
      );
      launchUrl(Uri.parse('mailto:${SiteConfig.email}?subject=$subject&body=$body'));
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Navbar(),

            // Hero Header
            _buildHeader(isDesktop),

            // Contact Section
            _buildContactSection(isDesktop),

            // Map placeholder
            _buildMapSection(isDesktop),

            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 28,
        vertical: isDesktop ? 80 : 60,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            SiteConfig.oliveLight.withOpacity(0.7),
            SiteConfig.backgroundColor,
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'CONTACT',
            style: GoogleFonts.sourceSans3(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: SiteConfig.primaryColor,
              letterSpacing: 4,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            SiteConfig.contactTitle,
            style: GoogleFonts.cormorantGaramond(
              fontSize: isDesktop ? 52 : 32,
              fontWeight: FontWeight.w500,
              color: SiteConfig.textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Text(
              SiteConfig.contactSubtitle,
              style: GoogleFonts.sourceSans3(
                fontSize: isDesktop ? 17 : 16,
                color: SiteConfig.textSecondary,
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(bool isDesktop) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120 : 28,
        vertical: isDesktop ? 80 : 48,
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildContactInfo(isDesktop)),
                const SizedBox(width: 80),
                Expanded(child: _buildContactForm(isDesktop)),
              ],
            )
          : Column(
              children: [
                _buildContactInfo(isDesktop),
                const SizedBox(height: 48),
                _buildContactForm(isDesktop),
              ],
            ),
    );
  }

  Widget _buildContactInfo(bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nos coordonnées',
          style: GoogleFonts.cormorantGaramond(
            fontSize: isDesktop ? 36 : 28,
            fontWeight: FontWeight.w500,
            color: SiteConfig.textColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'N\'hésitez pas à nous contacter par le moyen de votre choix.',
          style: GoogleFonts.sourceSans3(
            fontSize: 16,
            color: SiteConfig.textSecondary,
          ),
        ),
        const SizedBox(height: 40),
        _ContactItem(
          icon: Icons.location_on_outlined,
          title: 'Adresse',
          value: SiteConfig.address,
          onTap: () => launchUrl(Uri.parse(SiteConfig.googleMapsUrl)),
        ),
        const SizedBox(height: 24),
        _ContactItem(
          icon: Icons.phone_outlined,
          title: 'Téléphone',
          value: SiteConfig.phone,
          onTap: () => launchUrl(Uri.parse('tel:${SiteConfig.phone}')),
        ),
        const SizedBox(height: 24),
        _ContactItem(
          icon: Icons.email_outlined,
          title: 'Email',
          value: SiteConfig.email,
          onTap: () => launchUrl(Uri.parse('mailto:${SiteConfig.email}')),
        ),
        const SizedBox(height: 40),
        // Social links
        if (SiteConfig.instagram != null) ...[
          Text(
            'Suivez-nous',
            style: GoogleFonts.sourceSans3(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: SiteConfig.textColor,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          _SocialLink(
            icon: Icons.camera_alt_outlined,
            label: 'Instagram',
            url: SiteConfig.instagram!,
          ),
        ],
      ],
    );
  }

  Widget _buildContactForm(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 48 : 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: SiteConfig.primaryColor.withOpacity(0.08),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Envoyez-nous un message',
              style: GoogleFonts.cormorantGaramond(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: SiteConfig.textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Nous vous répondrons dans les plus brefs délais.',
              style: GoogleFonts.sourceSans3(
                fontSize: 15,
                color: SiteConfig.textLight,
              ),
            ),
            const SizedBox(height: 32),
            _StyledTextField(
              controller: _nameController,
              label: 'Votre nom',
              icon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre nom';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _StyledTextField(
              controller: _emailController,
              label: 'Votre email',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre email';
                }
                if (!value.contains('@')) {
                  return 'Email invalide';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _StyledTextField(
              controller: _messageController,
              label: 'Votre message',
              icon: Icons.message_outlined,
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer votre message';
                }
                return null;
              },
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: _SubmitButton(
                onPressed: _submitForm,
                isSubmitting: _isSubmitting,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapSection(bool isDesktop) {
    return Container(
      width: double.infinity,
      height: isDesktop ? 400 : 300,
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: 48,
      ),
      decoration: BoxDecoration(
        color: SiteConfig.oliveLight,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Stack(
        children: [
          // Decorative pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _MapPatternPainter(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: SiteConfig.primaryColor.withOpacity(0.15),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.location_on,
                    size: 40,
                    color: SiteConfig.primaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    SiteConfig.address,
                    style: GoogleFonts.sourceSans3(
                      fontSize: 16,
                      color: SiteConfig.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () => launchUrl(Uri.parse(SiteConfig.googleMapsUrl)),
                  icon: Icon(
                    Icons.open_in_new,
                    size: 18,
                    color: SiteConfig.primaryColor,
                  ),
                  label: Text(
                    'Ouvrir dans Google Maps',
                    style: GoogleFonts.sourceSans3(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: SiteConfig.primaryColor,
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

class _ContactItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  const _ContactItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  @override
  State<_ContactItem> createState() => _ContactItemState();
}

class _ContactItemState extends State<_ContactItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: _isHovered
                    ? SiteConfig.primaryColor
                    : SiteConfig.oliveLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                widget.icon,
                size: 24,
                color: _isHovered ? Colors.white : SiteConfig.primaryColor,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.sourceSans3(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: SiteConfig.textLight,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.value,
                    style: GoogleFonts.sourceSans3(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: SiteConfig.textColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialLink extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;

  const _SocialLink({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? SiteConfig.primaryColor : Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(
              color: _isHovered
                  ? SiteConfig.primaryColor
                  : SiteConfig.primaryColor.withOpacity(0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 20,
                color: _isHovered ? Colors.white : SiteConfig.primaryColor,
              ),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: GoogleFonts.sourceSans3(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isHovered ? Colors.white : SiteConfig.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StyledTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _StyledTextField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.sourceSans3(
        fontSize: 16,
        color: SiteConfig.textColor,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.sourceSans3(
          color: SiteConfig.textLight,
        ),
        prefixIcon: maxLines == 1
            ? Icon(icon, color: SiteConfig.textLight, size: 22)
            : null,
        filled: true,
        fillColor: SiteConfig.backgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: SiteConfig.textLight.withOpacity(0.15),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: SiteConfig.primaryColor,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: SiteConfig.accentColor,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: maxLines > 1 ? 20 : 0,
        ),
      ),
    );
  }
}

class _SubmitButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isSubmitting;

  const _SubmitButton({
    required this.onPressed,
    required this.isSubmitting,
  });

  @override
  State<_SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<_SubmitButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.isSubmitting ? null : widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isHovered
                  ? [SiteConfig.secondaryColor, SiteConfig.accentColor]
                  : [SiteConfig.primaryColor, SiteConfig.primaryColor.withOpacity(0.9)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (_isHovered ? SiteConfig.secondaryColor : SiteConfig.primaryColor)
                    .withOpacity(0.3),
                blurRadius: _isHovered ? 20 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: widget.isSubmitting
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Envoyer le message',
                        style: GoogleFonts.sourceSans3(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _MapPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = SiteConfig.primaryColor.withOpacity(0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Grid pattern
    const spacing = 30.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
