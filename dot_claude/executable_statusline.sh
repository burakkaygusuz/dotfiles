#!/bin/bash
# Reads Claude Code session JSON on stdin, prints one colored row, branch right-aligned:
#   model │ effort │ ↑ in ↓ out │ $cost │ context bar │ 5h/7d rate limits  ⎇ branch
input=$(cat)
dir=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
branch=$(git -C "$dir" branch --show-current 2>/dev/null)

left=$(jq -r '
  def k: if . >= 1000000 then "\(. / 1000000 * 10 | round / 10)M"
         elif . >= 1000 then "\(. / 1000 * 10 | round / 10)k"
         else "\(.)" end;
  def paint(code): "\u001b[\(code)m\(.)\u001b[0m";
  def level(warn; crit): if . >= crit then 31 elif . >= warn then 33 else 32 end;
  def pct: "\(round)%";
  def limit($name; $key): (.rate_limits[$key].used_percentage // empty) as $p
    | "\($name) \($p | pct)" | paint($p | level(70; 90));
  def bar: (. / 10 | floor | [., 10] | min) as $n | ("▓" * $n) + ("░" * (10 - $n));

  (.context_window.used_percentage // 0) as $ctx
  | (.cost.total_cost_usd // 0) as $cost
  | ( [ (.model.display_name | paint(36)),
        (if .effort.level then "effort \(.effort.level)" | paint(90) else empty end)
      ] | join(" │ ") ) as $head
  | ( [ "↑ \((.context_window.total_input_tokens // 0) | k) ↓ \((.context_window.total_output_tokens // 0) | k)",
        ("$\($cost * 100 | round / 100)" | paint($cost | level(5; 20))),
        ("context \($ctx | bar) \($ctx | pct)" | paint($ctx | level(70; 90))),
        limit("5h"; "five_hour"),
        limit("7d"; "seven_day")
      ] | join(" │ ") ) as $stats
  | "\($head) │ \($stats)"' <<<"$input")

# right-align the branch to the terminal edge (COLUMNS), 2-col margin against wrapping
if [ -n "$branch" ]; then
  export LC_ALL=en_US.UTF-8
  shopt -s extglob
  plain=${left//$'\033'\[*([0-9;])m/}
  tag="⎇ $branch"
  pad=$(( ${COLUMNS:-0} - ${#plain} - ${#tag} - 2 ))
  [ "$pad" -lt 2 ] && pad=2
  printf '%s%*s\033[35m%s\033[0m\n' "$left" "$pad" "" "$tag"
else
  echo "$left"
fi
