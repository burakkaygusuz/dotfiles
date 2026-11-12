#!/bin/bash
# Reads Claude Code session JSON on stdin, prints one colored row, branch right-aligned:
#   model │ effort │ ↑ in ↓ out │ $cost │ context bar │ 5h/7d rate limits  ⎇ branch
input=$(cat)
dir=$(jq -r '.workspace.current_dir // .cwd // empty' <<<"$input")
branch=$(git -C "$dir" branch --show-current 2>/dev/null)
# detached HEAD has no branch name: show the short sha instead
[ -n "$branch" ] || branch=$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)

jq -r --argjson cols "${COLUMNS:-0}" --arg branch "$branch" '
  def k: if . >= 1000000 then "\(. / 1000000 * 10 | round / 10)M"
         elif . >= 1000 then "\(. / 1000 * 10 | round / 10)k"
         else "\(.)" end;
  def paint: if .color then "\u001b[\(.color)m\(.text)\u001b[0m" else .text end;
  def level(warn; crit): if . >= crit then 31 elif . >= warn then 33 else 32 end;
  def pct: "\(round)%";
  def money: . * 100 | round | "\(. / 100 | floor).\((. % 100) + 100 | tostring | .[1:])";
  def limit($name; $key): (.rate_limits[$key].used_percentage | select(. != null)) as $p
    | {text: "\($name) \($p | pct)", color: ($p | level(70; 90))};
  def bar: (. / 10 | floor | [., 10] | min) as $n | ("▓" * $n) + ("░" * (10 - $n));

  (.context_window.used_percentage // 0) as $ctx
  | (.cost.total_cost_usd // 0) as $cost
  | [
      ((.model.display_name // .model.id) | select(.) | {text: ., color: 36}),
      (.effort.level | select(.) | {text: "effort \(.)", color: 90}),
      {text: "↑ \((.context_window.total_input_tokens // 0) | k) ↓ \((.context_window.total_output_tokens // 0) | k)", color: null},
      {text: "$\($cost | money)", color: ($cost | level(5; 20))},
      {text: "context \($ctx | bar) \($ctx | pct)", color: ($ctx | level(70; 90))},
      limit("5h"; "five_hour"),
      limit("7d"; "seven_day")
    ] as $segs
  | ($segs | map(.text) | join(" │ ") | length) as $width
  | ($segs | map(paint) | join(" │ ")) as $left
  | if $branch == "" then $left else
      ("⎇ " + $branch) as $tag
      | ([$cols - $width - ($tag | length) - 2, 2] | max) as $pad
      | $left + (" " * $pad) + "\u001b[35m\($tag)\u001b[0m"
    end' <<<"$input"
