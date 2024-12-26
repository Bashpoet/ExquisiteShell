#!/usr/bin/env bash

#==============================================================================
# Exquisite Shell: 
# An "exquisite corpse" generator using random lines from text files,
# with subtle comedic transformations thrown in via sed/awk.
#==============================================================================

# Directory containing your text files from various authors
TEXT_DIR="./literary_passages"

# Number of lines to pick for each snippet
LINES_PER_SNIPPET=3

# Ensure the directory exists
if [ ! -d "$TEXT_DIR" ]; then
  echo "Directory $TEXT_DIR does not exist. Please create it and add text files."
  exit 1
fi

# Collect all the text files in the directory
FILES=("$TEXT_DIR"/*)
if [ ${#FILES[@]} -eq 0 ]; then
  echo "No text files found in $TEXT_DIR"
  exit 1
fi

# Generate an "exquisite" snippet
generate_exquisite_snippet() {
  # We’ll randomly select LINES_PER_SNIPPET lines total.
  # Each line might come from a random file or from random offsets in the same file—your choice.
  # Let’s pick each line from a random file for variety:

  local lines=()

  for ((i=1; i<=LINES_PER_SNIPPET; i++)); do
    # Pick a random file
    local rand_file=${FILES[$RANDOM % ${#FILES[@]}]}

    # Count total lines in the file
    local total_lines
    total_lines=$(wc -l < "$rand_file")
    if [ "$total_lines" -eq 0 ]; then
      # In case of an empty file or file with no lines
      continue
    fi

    # Pick a random line number (1 to total_lines)
    local line_num=$(( (RANDOM % total_lines) + 1 ))

    # Extract that line
    local chosen_line
    chosen_line=$(sed -n "${line_num}p" "$rand_file")

    # Let's do a mild transformation or comedic insertion. For instance, 
    # we insert the word "snicker" randomly in the line using sed or 
    # we remove a random word using awk.
    
    # 1) Insert the word "snicker" after the third word (if there's enough words)
    # 2) If that fails, use a default snippet
    local transformed_line
    transformed_line=$(echo "$chosen_line" | awk '{
      if (NF >= 3) {
        $4 = "snicker " $4
        print
      } else {
        print $0
      }
    }')

    # 3) Let’s randomly uppercase a portion or do some more weirdness:
    # We'll uppercase the first 5 characters if available
    transformed_line=$(echo "$transformed_line" | sed -E 's/^(.{5})/\U\1/')

    # Accumulate this line in our array
    lines+=("$transformed_line")
  done

  # Now we join these lines in a whimsical manner:
  # Insert a random marker or punctuation between them.
  printf "\n--- Exquisite Shell Corpse (mini-story) ---\n\n"

  for line in "${lines[@]}"; do
    echo "$line"
  done
  
  echo
  echo "--- End of snippet ---"
  echo
}

# Run the generator
generate_exquisite_snippet

exit 0
