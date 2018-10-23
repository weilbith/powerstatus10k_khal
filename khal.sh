#!/bin/bash
#
# PowerStatus10k segment.
# This segment displays the next meeting and how many follows by khal.


# Segment Interface

# Implement the interface function to get the current state.
function getState_khal {
  state="${KHAL_ICON}"

  # Get all left meetings today.
  schedule="$(khal list --notstarted -f '{start-time} - {title}' --day-format '' today today)"
  readarray -t list <<< "$schedule"

  # Check if there are more than one meeting to mention about.
  if [[ ${#list[@]} -gt 1 ]] ; then
    state="${state} (+$((${#list[@]} - 1)))"
  fi

  # Show the start time and title of the next meeting if one is left today.
  if [[ ${#list[@]} -gt 0 ]] ; then
    state="${state} ${list[0]}"
  fi

  STATE="${state}"
}
