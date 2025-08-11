# Configuration ESLint et Prettier pour Neovim

## Fonctionnalités

✅ **ESLint** - Linting automatique avec configuration locale  
✅ **Prettier** - Formatage automatique avec configuration locale  
✅ **Support multi-langages** - JS, TS, React, Vue, CSS, JSON, etc.  
✅ **Configuration par projet** - Utilise les configs locales (`.eslintrc`, `.prettierrc`)
✅ **Diagnostics améliorés** - Affichage automatique des erreurs au hover

## Installation des outils

Dans Neovim, ouvrez Mason et installez :

```
:Mason
```

Puis installez :
- `eslint_d` (ESLint daemon - plus rapide que eslint standard)
- `prettier` (pour le formatage)
- `stylua` (optionnel, pour Lua)
- `black` (optionnel, pour Python)

Ou directement via commande :
```
:MasonInstall eslint_d prettier
```

## Raccourcis clavier

### Formatage et Linting
| Raccourci | Mode | Action |
|-----------|------|--------|
| `<leader>l` | Normal | Lancer le linting manuellement |
| `<leader>f` | Normal | Formater le fichier |
| `<leader>f` | Visuel | Formater la sélection |

### Diagnostics et Erreurs
| Raccourci | Mode | Action |
|-----------|------|--------|
| `K` | Normal | Afficher les détails de l'erreur (hover) |
| `<leader>e` | Normal | Afficher les diagnostics de la ligne |
| `<leader>q` | Normal | Afficher tous les diagnostics du fichier |
| `]d` | Normal | Aller à l'erreur suivante |
| `[d` | Normal | Aller à l'erreur précédente |

## Comment voir les messages d'erreur

1. **Automatic hover** : Les diagnostics s'affichent automatiquement quand vous restez immobile sur une ligne
2. **Touche K** : Appuyez sur `K` quand votre curseur est sur une erreur
3. **<leader>e** : Affiche les diagnostics de la ligne actuelle
4. **<leader>q** : Ouvre une liste avec toutes les erreurs du fichier
5. **Navigation** : `]d` et `[d` pour naviguer entre les erreurs

## Configuration des projets

### ESLint

Créez un fichier `.eslintrc.json` à la racine de votre projet :

```json
{
  "extends": [
    "eslint:recommended",
    "@typescript-eslint/recommended"
  ],
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint"],
  "rules": {
    "semi": ["error", "always"],
    "quotes": ["error", "single"]
  }
}
```

### Prettier

Créez un fichier `.prettierrc` à la racine de votre projet :

```json
{
  "semi": true,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5",
  "printWidth": 80
}
```

## Commandes utiles

- `:FormatDisable` - Désactiver le formatage automatique pour ce buffer
- `:FormatDisable!` - Désactiver le formatage automatique globalement
- `:FormatEnable` - Réactiver le formatage automatique
- `:MasonInstall eslint_d prettier` - Installer manuellement les outils
- `:Mason` - Ouvrir l'interface Mason
- `:lua vim.diagnostic.setloclist()` - Voir toutes les erreurs en liste

## Installation dans un nouveau projet

1. **Installer ESLint localement :**
   ```bash
   npm install --save-dev eslint @typescript-eslint/eslint-plugin @typescript-eslint/parser
   ```

2. **Installer Prettier localement :**
   ```bash
   npm install --save-dev prettier
   ```

3. **Créer les fichiers de configuration :**
   - `.eslintrc.json` pour ESLint
   - `.prettierrc` pour Prettier
   - `.prettierignore` (optionnel)

4. **Ouvrir le projet dans Neovim** - Les outils seront automatiquement détectés !

## Configuration par type de projet

### React/TypeScript
```json
// .eslintrc.json
{
  "extends": [
    "eslint:recommended",
    "@typescript-eslint/recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended"
  ],
  "parser": "@typescript-eslint/parser",
  "plugins": ["@typescript-eslint", "react", "react-hooks"],
  "settings": {
    "react": {
      "version": "detect"
    }
  }
}
```

### Vue.js
```json
// .eslintrc.json
{
  "extends": [
    "eslint:recommended",
    "@vue/typescript/recommended",
    "plugin:vue/vue3-recommended"
  ],
  "parser": "vue-eslint-parser",
  "parserOptions": {
    "parser": "@typescript-eslint/parser"
  }
}
```

## Dépannage

- **ESLint ne fonctionne pas :** 
  - Vérifiez que `eslint_d` est installé dans Mason
  - Vérifiez que vous avez un fichier `.eslintrc` dans votre projet
  - Vérifiez que ESLint est installé localement : `npm list eslint`

- **Prettier ne formate pas :** 
  - Vérifiez que `prettier` est installé dans Mason
  - Vérifiez que vous avez un fichier `.prettierrc` dans votre projet
  - Vérifiez que Prettier est installé localement : `npm list prettier`

- **Les erreurs ne s'affichent pas :**
  - Attendez quelques secondes (CursorHold)
  - Utilisez `<leader>e` pour forcer l'affichage
  - Vérifiez que le linting fonctionne avec `<leader>l`

- **Conflit entre ESLint et Prettier :** Installez `eslint-config-prettier` dans votre projet 