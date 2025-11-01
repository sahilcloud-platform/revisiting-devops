#!/usr/bin/env zsh
# Enhanced GitHub profile switcher for macOS + directory detection

# --- Define profiles ---
PROFILES=("personal" "work" "consulting")

typeset -A GH_NAME GH_EMAIL GH_KEY GH_DIR
GH_NAME[personal]="Sahil Gupta"
GH_EMAIL[personal]="personal@email.com"
GH_KEY[personal]="$HOME/.ssh/id_personal"
GH_DIR[personal]="$HOME/devops/project/personal"

GH_NAME[work]="Sahil Gupta"
GH_EMAIL[work]="work@@email.com"
GH_KEY[work]="$HOME/.ssh/id_work"
GH_DIR[work]="$HOME/devops/project/work"

GH_NAME[consulting]="Sahil Gupta"
GH_EMAIL[consulting]="consulting@email.com"
GH_KEY[consulting]="$HOME/.ssh/id_consulting"
GH_DIR[consulting]="$HOME/devops/project/consulting"

CONFIG_FILE="$HOME/.gh-profile-current"

# --- Helper functions ---
print_profiles() {
  echo "Available GitHub profiles:"
  local i=1
  for p in "${PROFILES[@]}"; do
    echo "  $i) $p (${GH_EMAIL[$p]})"
    ((i++))
  done
}

activate_profile() {
  local prof="$1"
  export GH_ACTIVE_PROFILE="$prof"
  export GIT_AUTHOR_NAME="${GH_NAME[$prof]}"
  export GIT_COMMITTER_NAME="${GH_NAME[$prof]}"
  export GIT_AUTHOR_EMAIL="${GH_EMAIL[$prof]}"
  export GIT_COMMITTER_EMAIL="${GH_EMAIL[$prof]}"
  export GIT_SSH_COMMAND="ssh -i ${GH_KEY[$prof]} -o IdentitiesOnly=yes"
  echo "$prof" > "$CONFIG_FILE"

  # Refresh the prompt in current tab
  if [[ "$PS1" == *GH_ACTIVE_PROFILE* ]] || [[ -n "$PROMPT" ]]; then
    source ~/.zshrc >/dev/null 2>&1
  fi
  echo "✅ Activated GitHub profile: $prof (${GH_EMAIL[$prof]})"
}

detect_profile_for_path() {
  local dir="$PWD"
  for prof in "${PROFILES[@]}"; do
    if [[ "$dir" == ${GH_DIR[$prof]}* ]]; then
      echo "$prof"
      return
    fi
  done
}

current_profile() {
  if [[ -f "$CONFIG_FILE" ]]; then
    local prof="$(cat "$CONFIG_FILE")"
    echo "Current active profile: $prof (${GH_EMAIL[$prof]})"
  else
    echo "No active profile set."
  fi
}

# --- CLI entrypoints ---
case "$1" in
  current)
    current_profile
    ;;
  switch)
    shift
    if [[ -n "$1" && " ${PROFILES[*]} " == *" $1 "* ]]; then
      activate_profile "$1"
    else
      echo "Usage: ghprofile switch <${(j:|:)PROFILES}>"
    fi
    ;;
  detect)
    prof=$(detect_profile_for_path)
    if [[ -n "$prof" ]]; then
      activate_profile "$prof"
    else
      echo "No matching profile for current directory."
    fi
    ;;
  *)
    echo
    print_profiles
    printf "Select profile (1-%d): " "${#PROFILES[@]}"
    read -r choice
    if [[ "$choice" =~ ^[0-9]+$ ]] && (( choice>=1 && choice<=${#PROFILES[@]} )); then
      idx=$((choice))
      prof="${PROFILES[$idx]}"
      activate_profile "$prof"
    else
      echo "❌ Invalid selection."
    fi
    ;;
esac
