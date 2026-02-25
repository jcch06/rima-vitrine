import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../config/site_config.dart';
import '../models/event.dart';
import '../services/supabase_service.dart';

/// Opens the event registration dialog.
void showEventRegistrationDialog(BuildContext context, Event event) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (_) => EventRegistrationDialog(event: event),
  );
}

class EventRegistrationDialog extends StatefulWidget {
  final Event event;

  const EventRegistrationDialog({super.key, required this.event});

  @override
  State<EventRegistrationDialog> createState() =>
      _EventRegistrationDialogState();
}

class _EventRegistrationDialogState extends State<EventRegistrationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSubmitting = false;
  bool _isSuccess = false;
  String? _errorMessage;

  bool _isCheckingCapacity = true;
  bool _isFull = false;

  @override
  void initState() {
    super.initState();
    _checkCapacity();
  }

  Future<void> _checkCapacity() async {
    if (widget.event.maxCapacity == null) {
      setState(() => _isCheckingCapacity = false);
      return;
    }

    try {
      final count =
          await SupabaseService.getEventRegistrationCount(widget.event.id);
      if (!mounted) return;
      setState(() {
        _isFull = count >= widget.event.maxCapacity!;
        _isCheckingCapacity = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isCheckingCapacity = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      // Double-check capacity before insert
      if (widget.event.maxCapacity != null) {
        final count =
            await SupabaseService.getEventRegistrationCount(widget.event.id);
        if (count >= widget.event.maxCapacity!) {
          if (!mounted) return;
          setState(() {
            _isSubmitting = false;
            _isFull = true;
          });
          return;
        }
      }

      await SupabaseService.registerForEvent(
        eventId: widget.event.id,
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
      );

      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _isSuccess = true;
      });

      // Auto-close after success
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.of(context).pop();
      });
    } catch (e) {
      if (!mounted) return;
      final errorStr = e.toString();
      String message;
      if (errorStr.contains('duplicate') ||
          errorStr.contains('unique') ||
          errorStr.contains('23505')) {
        message = 'Vous êtes déjà inscrit(e) à cet événement.';
      } else {
        message = 'Une erreur est survenue. Veuillez réessayer.';
      }
      setState(() {
        _isSubmitting = false;
        _errorMessage = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 16,
        vertical: 24,
      ),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: SiteConfig.primaryColor.withOpacity(0.12),
              blurRadius: 40,
              offset: const Offset(0, 16),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: _isCheckingCapacity
                ? _buildLoadingState()
                : _isFull
                    ? _buildFullState()
                    : _isSuccess
                        ? _buildSuccessState()
                        : _buildFormState(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 24),
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(SiteConfig.primaryColor),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Vérification des places...',
          style: GoogleFonts.sourceSans3(
            fontSize: 16,
            color: SiteConfig.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildFullState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: Icon(
                Icons.close_rounded,
                color: SiteConfig.textLight,
              ),
            ),
          ],
        ),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: SiteConfig.accentColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.event_busy_rounded,
            size: 36,
            color: SiteConfig.accentColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Événement complet',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: SiteConfig.textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Toutes les places pour "${widget.event.title}" ont été réservées.',
          style: GoogleFonts.sourceSans3(
            fontSize: 16,
            color: SiteConfig.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSuccessState() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: SiteConfig.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 36,
            color: SiteConfig.primaryColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Inscription confirmée !',
          style: GoogleFonts.cormorantGaramond(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: SiteConfig.textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Vous êtes inscrit(e) à "${widget.event.title}".',
          style: GoogleFonts.sourceSans3(
            fontSize: 16,
            color: SiteConfig.textSecondary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormState() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'S\'inscrire',
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: SiteConfig.textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.event.title,
                      style: GoogleFonts.sourceSans3(
                        fontSize: 15,
                        color: SiteConfig.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.close_rounded,
                  color: SiteConfig.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Name field
          _buildTextField(
            controller: _nameController,
            label: 'Votre nom',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Veuillez entrer votre nom';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Email field
          _buildTextField(
            controller: _emailController,
            label: 'Votre email',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Veuillez entrer votre email';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Email invalide';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Phone field
          _buildTextField(
            controller: _phoneController,
            label: 'Téléphone (optionnel)',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),

          // Error message
          if (_errorMessage != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: SiteConfig.accentColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: SiteConfig.accentColor.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 18,
                    color: SiteConfig.accentColor,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _errorMessage!,
                      style: GoogleFonts.sourceSans3(
                        fontSize: 14,
                        color: SiteConfig.accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 28),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: _SubmitButton(
              onPressed: _submit,
              isSubmitting: _isSubmitting,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
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
        prefixIcon: Icon(icon, color: SiteConfig.textLight, size: 22),
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
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
                  : [
                      SiteConfig.primaryColor,
                      SiteConfig.primaryColor.withOpacity(0.9)
                    ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: (_isHovered
                        ? SiteConfig.secondaryColor
                        : SiteConfig.primaryColor)
                    .withOpacity(0.3),
                blurRadius: _isHovered ? 20 : 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: widget.isSubmitting
                ? const SizedBox(
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
                        'Confirmer l\'inscription',
                        style: GoogleFonts.sourceSans3(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.how_to_reg_rounded,
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
