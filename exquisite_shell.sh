#!/usr/bin/env bash

#==============================================================================
# Exquisite Shell: 
# An "exquisite corpse" generator using random lines from text files,
# with subtle comedic transformations thrown in via sed/awk.
#==============================================================================

# --- Configuration (Defaults) ---

TEXT_DIR="./literary_passages"  # Directory containing your text files
LINES_PER_SNIPPET=3             # Number of lines per generated snippet

# --- Functions ---

# Display help message
display_help() {
  echo "Usage: ${0} [-h] [-n NUMBER]"
  echo
  echo "Options:"
  echo "  -h, --help          Display this help message."
  echo "  -n, --number        Set the number of lines per snippet (default: ${LINES_PER_SNIPPET})."
  echo
}

# Process command-line options
process_options() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        display_help
        exit 0
        ;;
      -n|--number)
        if [[ -n "$2" ]] && [[ "$2" =~ ^[0-9]+$ ]]; then
          LINES_PER_SNIPPET="$2"
          shift 2
        else
          echo "Error: Invalid number of lines specified." >&2
          display_help
          exit 1
        fi
        ;;
      *)
        echo "Error: Unknown option '$1'." >&2
        display_help
        exit 1
        ;;
    esac
  done
}

# Insert a whimsical word into a line
insert_whimsical_word() {
  local line="$1"
  local words=("snicker" "guffaw" "chuckle" "titter" "cackle")
  local word="${words[$RANDOM % ${#words[@]}]}"

  # Insert the word after a random word (if possible)
  echo "$line" | awk -v word="$word" '{
    if (NF > 1) {
      pos = int(rand() * NF) + 1;
      $pos = $pos " " word;
    }
    print
  }'
}

# Randomly capitalize words or phrases
random_capitalize() {
  local line="$1"
  # Randomly decide to either capitalize a single word or a short phrase
  if (( RANDOM % 2 == 0 )); then
    # Capitalize a random word
    echo "$line" | awk '{
      if (NF > 0) {
        pos = int(rand() * NF) + 1;
        $pos = toupper($pos);
        print
      } else {
        print
      }
    }'
  else
    # Capitalize a random phrase (up to 3 words)
    echo "$line" | awk -v seed=$RANDOM '{
      srand(seed);  # Initialize random number generator
      if (NF > 2) {
        start = int(rand() * (NF - 2)) + 1;
        for (i = start; i < start + 3; i++) {
          $i = toupper($i);
        }
        print
      } else if (NF > 0){
        pos = int(rand() * NF) + 1;
        $pos = toupper($pos);
        print
      }
      else {
        print
      }
    }'
  fi
}

# Generate an "exquisite corpse" snippet
generate_exquisite_snippet() {
  local lines=()

  for ((i=1; i<=LINES_PER_SNIPPET; i++)); do
    # Pick a random file
    local rand_file=${FILES[$RANDOM % ${#FILES[@]}]}

    # Pick a random line number
    local total_lines=$(wc -l < "$rand_file")
    if (( total_lines == 0 )); then
      continue  # Skip empty files
    fi
    local line_num=$(( (RANDOM % total_lines) + 1 ))

    # Extract that line
    local chosen_line=$(sed -n "${line_num}p" "$rand_file")

    # Apply transformations
    local transformed_line
    transformed_line=$(insert_whimsical_word "$chosen_line")
    transformed_line=$(random_capitalize "$transformed_line")
    # Add more transformations here if desired...

    lines+=("$transformed_line")
  done

  # Output the snippet
  printf "\n--- Exquisite Shell Corpse (mini-story) ---\n\n"
  for line in "${lines[@]}"; do
    echo "$line"
  done
  echo "--- End of snippet ---"
  echo
}

# --- Main Script ---

# Process command-line options
process_options "$@"

# Ensure the text directory exists
if [ ! -d "$TEXT_DIR" ]; then
  echo "Error: Directory '$TEXT_DIR' does not exist. Please create it and add text files." >&2
  exit 1
fi

# Collect all text files in the directory
FILES=("$TEXT_DIR"/*)
if [ ${#FILES[@]} -eq 0 ]; then
  echo "Error: No text files found in '$TEXT_DIR'." >&2
  exit 1
fi

# Run the generator
generate_exquisite_snippet

exit 0
