#!/bin/bash
#
# PowerStatus10k segment.
# This segment displays the next meeting and how many follows by khal.


# Segment Interface

# Implement the interface function to get the current state.
function getState_khal {
  # Use the end time to filter all-day events.
  start_times="$(khal list --notstarted -f '{start-time}' --day-format '' now tomorrow)"
  end_times="$(khal list --notstarted -f '{end-necessary}' --day-format '' now tomorrow)"
  schedule="$(khal list --notstarted -f '{start-time} - {title} {repeat-symbol}' --day-format '' now tomorrow)"

  readarray -t start_time_list <<< "$start_times"
  readarray -t end_time_list <<< "$end_times"
  readarray -t schedule_list <<< "$schedule"

  event_count=0
  state=""

  for ((i=0; i<=${#end_time_list[@]}; i++)); do
    start="${start_time_list[i]}"
    end="${end_time_list[i]}"
    event="${schedule_list[i]}"

    # All-day events have an empty ending time.
    if [[ -n "$start" ]] && [[ -n "$end" ]]; then
      # Only add the next event.
      if [[ -z "$state" ]]; then
        state=$(abbreviate "$event" "khal")

      # Count events after the next one.
      else
        event_count=$((event_count + 1))
      fi
    fi
  done

  # Add number of left meetings if some are left.
  [[ $event_count -gt 0 ]] && state="(+$event_count) $state"

  state="${KHAL_ICON} $state"
  STATE="${state}"
}
