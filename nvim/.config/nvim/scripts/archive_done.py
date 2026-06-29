#!/usr/bin/env python3
"""Archive completed tasks in a markdown note.

Moves every done checkbox (``- [x]``) — and everything living under a heading
named "Done" — into a ``## Concluídas`` section appended at the end of the file,
mirroring the document's heading hierarchy so each item keeps the area/subsection
it came from. Open tasks (``- [ ]``) and prose stay in place; headings that become
empty are dropped.

Reads markdown on stdin, writes the transformed markdown to stdout. Idempotent:
re-running merges newly-completed items into the existing ``## Concluídas`` section
instead of nesting a second one.

Wired to the ``:Archive`` user command (see lua/josean/plugins/lsp/lspconfig.lua).
"""
import re
import sys
from collections import OrderedDict


def is_heading(line):
    return re.match(r"^#{1,6}\s", line) is not None


def heading_level(line):
    m = re.match(r"^(#{1,6})\s+(.*)$", line)
    return (len(m.group(1)), m.group(2).rstrip()) if m else (None, None)


def collect(region, delta, force_done):
    """Partition a block of lines.

    Returns ``(kept_lines, done_blocks)`` where ``done_blocks`` is a list of
    ``(path, [lines])``. ``path`` is the heading trail as ``(level, text)`` pairs
    (levels shifted by ``delta``). A column-0 list item plus its indented children
    form one block. ``force_done`` treats every block as done (used when re-parsing
    an existing Concluídas section).
    """
    n = len(region)
    stack = {}  # heading level -> text
    done_idx = set()
    done_blocks = []
    i = 0
    while i < n:
        line = region[i]
        if is_heading(line):
            lvl, txt = heading_level(line)
            stack[lvl] = txt
            for k in [k for k in stack if k > lvl]:
                del stack[k]
            i += 1
            continue
        if line.strip() == "" or line[0] in " \t":
            i += 1
            continue
        # column-0 block start: gather indented children / continuation lines
        j = i + 1
        while j < n and region[j].strip() != "" and region[j][0] in " \t":
            j += 1
        block = region[i:j]
        path = [(lv + delta, stack[lv]) for lv in sorted(stack) if lv + delta >= 2]
        under_done = any(t.strip().lower() == "done" for t in stack.values())
        first = block[0].lstrip()
        is_done = first.startswith("- [x]") or first.startswith("* [x]")
        if force_done or under_done or is_done:
            done_idx.update(range(i, j))
            done_blocks.append((path, block))
        i = j
    kept = [region[k] for k in range(n) if k not in done_idx]
    return kept, done_blocks


def prune_empty_headings(lines):
    """Drop headings whose section (down to the next same-or-higher heading) has no
    non-heading content. Iterates so parents of emptied subsections also go."""
    while True:
        m = len(lines)
        headings = [(i, heading_level(lines[i])[0]) for i in range(m) if is_heading(lines[i])]
        hset = {i for i, _ in headings}
        remove = set()
        for idx, level in headings:
            end = m
            for idx2, level2 in headings:
                if idx2 > idx and level2 <= level:
                    end = idx2
                    break
            has_content = any(
                k not in hset and lines[k].strip() != "" for k in range(idx + 1, end)
            )
            if not has_content:
                remove.add(idx)
        if not remove:
            break
        lines = [x for k, x in enumerate(lines) if k not in remove]
    return lines


def build_mirror(done_blocks):
    """Render the ``## Concluídas`` section, grouping blocks by heading path."""
    groups = OrderedDict()
    for path, block in done_blocks:
        groups.setdefault(tuple(path), []).append(block)

    out = ["## Concluídas", ""]
    prev = ()
    for path, blocks in groups.items():
        common = 0
        while common < len(prev) and common < len(path) and prev[common] == path[common]:
            common += 1
        for level, txt in path[common:]:
            if out and out[-1].strip() != "":
                out.append("")
            out.append("#" * (level + 1) + " " + txt)
            out.append("")
        prev = path
        for block in blocks:
            out.extend(block)
    return out


def collapse_blanks(lines):
    res = []
    for line in lines:
        if line.strip() == "" and res and res[-1].strip() == "":
            continue
        res.append(line)
    while res and res[0].strip() == "":
        res.pop(0)
    while res and res[-1].strip() == "":
        res.pop()
    return res


def archive(text):
    lines = text.split("\n")
    if lines and lines[-1] == "":
        lines = lines[:-1]

    # Re-parse an existing Concluídas section so the run is idempotent: recover its
    # items with their original area paths (mirror heading level - 1) and rebuild.
    cstart = next((i for i, l in enumerate(lines) if re.match(r"^##\s+Conclu", l)), None)
    conc_blocks = []
    if cstart is not None:
        cend = len(lines)
        for j in range(cstart + 1, len(lines)):
            if re.match(r"^##\s", lines[j]):
                cend = j
                break
        _, conc_blocks = collect(lines[cstart + 1:cend], -1, True)
        main_lines = lines[:cstart] + lines[cend:]
    else:
        main_lines = lines

    kept, main_blocks = collect(main_lines, 0, False)
    done_blocks = main_blocks + conc_blocks
    if not done_blocks:
        return text  # nothing to archive — pass through untouched

    kept = prune_empty_headings(kept)
    result = collapse_blanks(kept + [""] + build_mirror(done_blocks))
    return "\n".join(result) + "\n"


if __name__ == "__main__":
    sys.stdout.write(archive(sys.stdin.read()))
