# Paniero Vitrine Template

Template de site vitrine Flutter Web pour clients Paniero. Se connecte à Supabase pour afficher les articles de blog du vendeur.

## Structure du projet

```
/paniero-vitrine-template
├── pubspec.yaml
├── web/
│   └── index.html
├── lib/
│   ├── main.dart
│   ├── config/
│   │   └── site_config.dart      # Configuration client
│   ├── models/
│   │   └── blog_post.dart
│   ├── services/
│   │   └── supabase_service.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── about_screen.dart
│   │   ├── blog_screen.dart
│   │   ├── blog_post_screen.dart
│   │   └── contact_screen.dart
│   └── widgets/
│       ├── navbar.dart
│       ├── footer.dart
│       ├── hero_section.dart
│       └── blog_card.dart
├── assets/
│   └── images/
│       ├── logo.png              # Logo du client
│       └── hero.jpg              # Image hero
└── README.md
```

## Configuration pour un nouveau client

### 1. Cloner ce template

```bash
git clone <repo-url> mon-client-vitrine
cd mon-client-vitrine
```

### 2. Modifier `lib/config/site_config.dart`

Configurer les éléments suivants :

```dart
// Identifiant vendeur Paniero
static const String vendorId = 'VOTRE_VENDOR_ID';
static const String vendorSlug = 'votre-slug';

// Infos business
static const String businessName = 'Nom du Business';
static const String tagline = 'Votre slogan';
static const String description = 'Description de votre activité...';

// Coordonnées
static const String phone = '06 XX XX XX XX';
static const String email = 'contact@example.com';
static const String address = 'Votre adresse';
static const String googleMapsUrl = 'https://maps.google.com/?q=...';

// Réseaux sociaux (null si non utilisé)
static const String? instagram = 'https://instagram.com/...';
static const String? facebook = 'https://facebook.com/...';

// Lien boutique Paniero
static const String storeUrl = 'https://app.paniero.fr/store/votre-slug';

// Couleurs personnalisées
static const Color primaryColor = Color(0xFF...);
static const Color secondaryColor = Color(0xFF...);

// Supabase
static const String supabaseUrl = 'https://xxx.supabase.co';
static const String supabaseAnonKey = 'eyJ...';
```

### 3. Ajouter les assets

Placer les images dans `assets/images/` :
- `logo.png` - Logo du client
- `hero.jpg` - Image principale (hero section)

### 4. Personnaliser `web/index.html`

Modifier les balises meta pour le SEO :
- `<title>`
- `<meta name="description">`
- Open Graph tags

## Commandes

### Développement

```bash
flutter pub get
flutter run -d chrome
```

### Build production

```bash
flutter build web --release
```

Le build sera disponible dans `/build/web`

## Déploiement sur Netlify

### Option 1 : Drag & Drop

1. `flutter build web --release`
2. Ouvrir [Netlify Drop](https://app.netlify.com/drop)
3. Glisser-déposer le dossier `/build/web`
4. Configurer le domaine personnalisé

### Option 2 : Git Deploy

1. Pusher le code sur GitHub/GitLab
2. Connecter le repo à Netlify
3. Build command: `flutter build web --release`
4. Publish directory: `build/web`

### Configuration Netlify

Créer un fichier `netlify.toml` à la racine :

```toml
[build]
  publish = "build/web"
  command = "flutter build web --release"

[[redirects]]
  from = "/*"
  to = "/index.html"
  status = 200
```

## Pages disponibles

| Route | Description |
|-------|-------------|
| `/` | Page d'accueil avec hero et présentation |
| `/notre-histoire` | Page "À propos" |
| `/blog` | Liste des articles de blog |
| `/blog/:slug` | Détail d'un article |
| `/contact` | Formulaire de contact |

## Base de données Supabase

Le template utilise la table `blog_posts` partagée Paniero :

```sql
CREATE TABLE blog_posts (
  id SERIAL PRIMARY KEY,
  vendor_id UUID NOT NULL,
  title TEXT NOT NULL,
  slug TEXT NOT NULL,
  content TEXT NOT NULL,
  excerpt TEXT,
  featured_image TEXT,
  category TEXT,
  status TEXT DEFAULT 'draft',
  published_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

## Design responsive

Le template est 100% responsive avec des breakpoints :
- Desktop : > 800px
- Mobile : <= 800px

## Personnalisation avancée

### Ajouter une nouvelle page

1. Créer le fichier dans `lib/screens/`
2. Ajouter la route dans `lib/main.dart`
3. Ajouter le lien dans `lib/widgets/navbar.dart`

### Modifier le thème

Toutes les couleurs sont centralisées dans `SiteConfig`. Pour modifier :
- `primaryColor` : Couleur principale (boutons, liens actifs)
- `secondaryColor` : Couleur d'accent
- `backgroundColor` : Fond de page
- `textColor` : Texte principal

## Support

Pour toute question, contacter l'équipe Paniero.
