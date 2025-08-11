#!/bin/bash

echo "🧪 Test de la configuration ESLint et Prettier"
echo "=============================================="

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Fonctions d'affichage
success() {
    echo -e "${GREEN}✅ $1${NC}"
}

error() {
    echo -e "${RED}❌ $1${NC}"
}

info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

echo ""
info "Étape 1: Vérification des fichiers de configuration"

# Vérifier .eslintrc.json
if [ -f ".eslintrc.json" ]; then
    success "Fichier .eslintrc.json trouvé"
else
    error "Fichier .eslintrc.json manquant"
fi

# Vérifier .prettierrc
if [ -f ".prettierrc" ]; then
    success "Fichier .prettierrc trouvé"
else
    error "Fichier .prettierrc manquant"
fi

# Vérifier le fichier de test
if [ -f "test_eslint_prettier.js" ]; then
    success "Fichier de test test_eslint_prettier.js trouvé"
else
    error "Fichier de test test_eslint_prettier.js manquant"
fi

echo ""
info "Étape 2: Instructions pour tester dans Neovim"
echo ""
echo "1. Ouvrez Neovim dans ce répertoire:"
echo "   nvim"
echo ""
echo "2. Synchronisez les plugins:"
echo "   :PackerSync"
echo ""
echo "3. Installez les outils Mason:"
echo "   :MasonInstall eslint_d prettier"
echo ""
echo "4. Ouvrez le fichier de test:"
echo "   :e test_eslint_prettier.js"
echo ""
echo "5. Testez les fonctionnalités:"
echo "   - Vous devriez voir des erreurs ESLint soulignées"
echo "   - Appuyez sur <leader>l pour lancer le linting"
echo "   - Appuyez sur <leader>f pour formater le fichier"
echo ""
echo "6. Vérifiez les commandes utiles:"
echo "   :Mason                  - Ouvrir Mason"
echo "   :FormatDisable         - Désactiver le formatage auto"
echo "   :FormatEnable          - Réactiver le formatage auto"
echo ""

warning "Note: Assurez-vous d'avoir Node.js installé pour que ESLint et Prettier fonctionnent"

echo ""
info "Résultat attendu après formatage (<leader>f):"
echo "Le fichier test_eslint_prettier.js devrait être reformaté avec:"
echo "- Guillemets simples au lieu de doubles"
echo "- Points-virgules ajoutés"
echo "- Espacement correct autour des accolades"
echo "- Indentation correcte" 