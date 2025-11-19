# ⌨️ Neovim Keymaps Cheatsheet

Voici la liste complète des raccourcis clavier configurés pour ton environnement React/Node.
**Leader Key** : `<Space>`

---

## 🚀 Navigation & Général
| Raccourci | Action | Description |
|-----------|--------|-------------|
| `<leader>e` | **Explorer** | Ouvrir/Fermer Neo-tree (Fichiers) |
| `<C-h>` | Navigation | Aller à la fenêtre de **gauche** |
| `<C-j>` | Navigation | Aller à la fenêtre du **bas** |
| `<C-k>` | Navigation | Aller à la fenêtre du **haut** |
| `<C-l>` | Navigation | Aller à la fenêtre de **droite** |
| `<leader>W` / `<C-s>` | Sauvegarde | Sauvegarder le fichier courant |
| `<leader>x` | Buffer | Fermer le buffer courant |
| `<leader>tn` / `<Right>` | Tab | Onglet suivant |
| `<leader>tp` / `<Left>` | Tab | Onglet précédent |
| `<leader>tb` | Tab | Déplacer la fenêtre actuelle dans un nouvel onglet |
| `<S-t>` | Terminal | Ouvrir un terminal externe sur le fichier courant |

## 🔍 Recherche (Telescope)
| Raccourci | Action | Description |
|-----------|--------|-------------|
| `<leader>pf` | **Find Files** | Chercher un fichier (par nom) |
| `<leader>gr` | **Grep** | Chercher du texte dans tout le projet |
| `<leader>ps` | Grep (Input) | Chercher du texte (demande de saisie) |
| `<leader>gw` | Grep Word | Chercher le **mot sous le curseur** dans le projet |
| `<leader>sw` | Search Word | Idem que gw |
| `<leader>su` | **Find Usages** | Chercher les usages du fichier courant (par son nom) |
| `<leader>o` | Buffers | Lister les buffers ouverts |
| `<leader>gh` | Git | Chercher des fichiers Git |
| `<leader>ss` | Git Status | Voir le statut Git |
| `<space>fb` | File Browser | Explorateur de fichiers avancé |
| `<leader>en` | Config | Chercher dans les fichiers de config Neovim |
| `<leader>help` | Aide | Afficher l'aide des raccourcis |

### 🔭 Raccourcis DANS Telescope (une fois ouvert)
| Raccourci | Action | Description |
|-----------|--------|-------------|
| `Entrée` | Ouvrir | Ouvre la sélection dans la fenêtre actuelle |
| `Ctrl + x` | **Split Horizontal** | Ouvre la sélection en bas |
| `Ctrl + v` | **Split Vertical** | Ouvre la sélection à droite |
| `Ctrl + t` | Nouvel Onglet | Ouvre la sélection dans un nouvel onglet |
| `Esc` / `q` | Fermer | Ferme la fenêtre Telescope |

## 🧠 Code Intelligence (LSP)
| Raccourci | Action | Description |
|-----------|--------|-------------|
| `gd` | **Definition** | Aller à la définition (ouvre un split) |
| `K` | Hover | Afficher la documentation / type sous le curseur |
| `<leader>rn` | **Rename** | Renommer la variable/fonction partout |
| `<leader>vca` | Code Action | Actions rapides (fix imports, etc.) |
| `<leader>vrr` | References | Lister les références |
| `<leader>vd` | Diagnostics | Voir les erreurs de la ligne |
| `[d` / `]d` | Diagnostics | Erreur précédente / suivante |
| `<leader>f` | **Format** | Formater le fichier (Prettier) |

## 👀 Preview (Sans ouvrir)
| Raccourci | Action | Description |
|-----------|--------|-------------|
| `gpd` | Preview Def | Voir la définition dans une popup |
| `gpi` | Preview Impl | Voir l'implémentation dans une popup |
| `gpr` | Preview Ref | Voir les références dans une popup |
| `gP` | Close | Fermer les fenêtres de preview |

## 💾 Gestion de Sessions
| Raccourci | Action | Description |
|-----------|--------|-------------|
| `<leader>Sl` | **List** | Lister et charger une session |
| `<leader>Sn` | New | Créer/Sauvegarder une session nommée |
| `<leader>Sd` | Delete | Supprimer une session |
| `<leader>Sc` | Close | Fermer la session actuelle |

## 🐛 Debugging
| Raccourci | Action | Description |
|-----------|--------|-------------|
| `<leader>db` | Breakpoint | Ajouter/Enlever un point d'arrêt |
| `<leader>dc` | Continue | Lancer le debug / Continuer |

## ⚡ Édition & JS Helpers
| Raccourci | Mode | Description |
|-----------|------|-------------|
| `J` | Visuel | Déplacer les lignes sélectionnées vers le **bas** |
| `K` | Visuel | Déplacer les lignes sélectionnées vers le **haut** |
| `<leader>p` | Visuel | Coller sans perdre le contenu du presse-papier |
| `<leader>cl` | Normal | Insérer `console.log()` |
| `<leader>cw` | Normal | `console.log()` de la variable sous le curseur |
