#!/usr/bin/env bash
set -euo pipefail

TYPES=(feat fix docs style refactor perf test build ci chore revert)

FEAT_EMOJIS=(
  "🍪" "🍔" "🍨" "🍕" "🥧" "🍰" "🍦" "🧁" "🍩" "🍡" "🍭" "🦄" "🍄" "🍯" "🍫" "🍬" "🥦" "🌶️"
  "🍆" "🥑" "🐵" "🐷" "🐯" "🦁" "🐻" "🐼" "🐱" "🦊" "🦃" "🐔" "🐣" "🐥" "🦋" "🌼" "🌸" "🌷"
  "🌻" "🐢" "🌞" "🐸" "🤖" "🧑‍💻" "👨‍💻" "👩‍💻" "👩" "🚀" "💡" "🦾" "✨" "🪄" "⚡" "🧬" "🫶"
  "👍" "👍🏾" "🧢" "🧿" "🗿" "📈" "🫟" "🎈" "🎸" "🆕" "🔨" "🏅"
)

FIX_EMOJIS=("🐛" "🐝" "🕷️" "🐞" "🐜")

SKIP_BRANCH_CHECK=0
CACHE_DIR="${HOME}/.cache/commit-helper"
LAST_MESSAGE_FILE=""

usage() {
  cat <<'EOF'
Usage: commit-helper.sh [options]

Options:
  --no-branch, --bypass-branch  Bypass branch creation check on main/master.
  -h, --help                    Show this help message.
EOF
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --no-branch|--bypass-branch)
        SKIP_BRANCH_CHECK=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        echo "Option inconnue: $1"
        usage
        exit 1
        ;;
    esac
  done
}

init_repo_cache() {
  local repo_root repo_name repo_slug repo_hash

  repo_root="$(git rev-parse --show-toplevel)"
  repo_name="$(basename "$repo_root")"
  repo_slug="$(echo "$repo_name" | tr -cs '[:alnum:]-_' '-')"
  repo_hash="$(printf '%s' "$repo_root" | sha256sum | awk '{print $1}')"

  mkdir -p "$CACHE_DIR"
  LAST_MESSAGE_FILE="${CACHE_DIR}/${repo_slug}-${repo_hash}.last-message"
}

load_last_commit_message() {
  if [[ -f "$LAST_MESSAGE_FILE" ]]; then
    cat "$LAST_MESSAGE_FILE"
  fi
}

save_last_commit_message() {
  local message="$1"
  printf '%s\n' "$message" > "$LAST_MESSAGE_FILE"
}

pick_random() {
  local -n arr_ref="$1"
  local idx=$((RANDOM % ${#arr_ref[@]}))
  echo "${arr_ref[$idx]}"
}

emoji_for_type() {
  local type="$1"

  case "$type" in
    feat) pick_random FEAT_EMOJIS ;;
    fix) pick_random FIX_EMOJIS ;;
    docs) echo "📝" ;;
    style) echo "🎨" ;;
    refactor) echo "♻️" ;;
    perf) echo "⚡" ;;
    test) echo "✅" ;;
    build) echo "📦" ;;
    ci) echo "👷" ;;
    chore) echo "🚀" ;;
    revert) echo "⏪" ;;
    *) echo "🚧" ;;
  esac
}

confirm() {
  local prompt="$1"
  local answer

  while true; do
    read -r -p "$prompt [y/N]: " answer
    case "$answer" in
      y|Y|yes|YES) return 0 ;;
      n|N|no|NO|"") return 1 ;;
      *) echo "Réponse invalide. Merci de répondre par y ou n." ;;
    esac
  done
}

select_type() {
  local choice

  echo "Choisis le type de commit :" >&2
  for i in "${!TYPES[@]}"; do
    printf "  %2d) %s\n" "$((i + 1))" "${TYPES[$i]}" >&2
  done

  while true; do
    read -r -p "Numéro du type: " choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= ${#TYPES[@]} )); then
      echo "${TYPES[$((choice - 1))]}"
      return 0
    fi
    echo "Type invalide. Entre un numéro de la liste." >&2
  done
}

read_scope() {
  local scope

  while true; do
    read -r -p "Scope (optionnel, ex: player). Laisse vide si aucun: " scope
    if [[ -z "$scope" ]]; then
      echo ""
      return 0
    fi

    if [[ "$scope" =~ ^[a-z0-9-]+$ ]]; then
      echo "$scope"
      return 0
    fi

    echo "Scope invalide. Utilise seulement [a-z0-9-]." >&2
  done
}

read_description() {
  local description

  while true; do
    read -r -p "Description (obligatoire, impératif, minuscule, sans point final): " description

    if [[ -z "$description" ]]; then
      echo "La description est obligatoire." >&2
      continue
    fi

    if [[ "$description" =~ \.$ ]]; then
      echo "La description ne doit pas se terminer par un point." >&2
      continue
    fi

    if [[ "$description" =~ ^[A-Z] ]]; then
      echo "La description doit commencer en minuscule." >&2
      continue
    fi

    echo "$description"
    return 0
  done
}

ensure_branch() {
  local current_branch
  current_branch="$(git branch --show-current)"

  if [[ "$current_branch" == "main" || "$current_branch" == "master" ]]; then
    echo "Tu es sur la branche $current_branch."
    echo "La skill impose une branche dédiée avant commit."

    local suggested branch
    suggested="feat/ma-description"
    read -r -p "Nom de la nouvelle branche (ex: feat/ma-description): " branch

    while [[ -z "$branch" ]]; do
      read -r -p "Le nom de branche ne peut pas être vide. Réessaie: " branch
    done

    if confirm "Créer et basculer vers $branch ?"; then
      git checkout -b "$branch"
      echo "Branche créée: $branch"
    else
      echo "Commit annulé: branche dédiée requise sur main/master."
      exit 1
    fi
  fi
}

main() {
  parse_args "$@"

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Erreur: ce script doit être lancé dans un dépôt Git."
    exit 1
  fi

  init_repo_cache

  if [[ "$SKIP_BRANCH_CHECK" -eq 1 ]]; then
    echo "Bypass actif: vérification/création de branche ignorée."
  else
    ensure_branch
  fi

  local type emoji scope description commit_message previous_message

  previous_message="$(load_last_commit_message || true)"
  if [[ -n "$previous_message" ]]; then
    echo "Message précédent détecté:"
    echo "$previous_message"
    echo
    if confirm "Réutiliser ce message de commit ?"; then
      commit_message="$previous_message"
    fi
  fi

  if [[ -z "${commit_message:-}" ]]; then
    type="$(select_type)"
    emoji="$(emoji_for_type "$type")"
    scope="$(read_scope)"
    description="$(read_description)"

    if [[ -n "$scope" ]]; then
      commit_message="$emoji $type($scope): $description"
    else
      commit_message="$emoji $type: $description"
    fi
  fi

  echo
  echo "Message généré:"
  echo "$commit_message"
  echo

  echo "Etat Git avant ajout:"
  git status --short

  echo
  echo "Ajout des fichiers avec: git add ."
  git add .

  echo
  echo "Etat Git après ajout:"
  git status --short

  if ! confirm "Exécuter git commit -m \"$commit_message\" ?"; then
    echo "Commit annulé."
    exit 0
  fi

  git commit -m "$commit_message"
  save_last_commit_message "$commit_message"

  if ! confirm "Exécuter git push ?"; then
    echo "Push annulé. Commit conservé localement."
    exit 0
  fi

  local current_branch
  current_branch="$(git branch --show-current)"

  if git rev-parse --abbrev-ref --symbolic-full-name "@{u}" >/dev/null 2>&1; then
    git push
  else
    git push -u origin "$current_branch"
  fi

  echo "Push terminé."
}

main "$@"
