#!/bin/bash

# Map of ASCII codes to hex values
declare -A hex_map
for i in {0..127}; do
  hex=$(printf '%02x' $i)
  hex_map["$i"]=$hex
done

# Listen for key input
IFS="" read -rsn1 input

# Start the sequence with the input
key_sequence="$input"

# Wait for more input to complete the sequence
while read -rsn1 -t 0.1 next_input; do
  key_sequence+="$next_input"
done

# Process the key sequence
key_sequence_hex=""

for (( i=0; i<${#key_sequence}; i++ )); do
  ascii_code=$(printf '%d' "'${key_sequence:$i:1}")
  if [ -v "hex_map[$ascii_code]" ]; then
    key_sequence_hex+="\\x${hex_map[$ascii_code]}"
  else
    # If the ASCII code is not in the map, use it as-is
    key_sequence_hex+="${key_sequence:$i:1}"
  fi
done

echo "The Alacritty config line is:"
echo "- { key: SomeKey, mods: SomeMods, chars: \"$key_sequence_hex\" }"
