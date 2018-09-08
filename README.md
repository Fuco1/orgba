# org better api

Better API for org.  It's that simple.  Org Mode has really confusing
and fragmented API where many simple things are impossibly difficuly.
This is the result of its organic growth.

This package provides some high-level abstractions for common problems
people want to solve.

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-generate-toc again -->
**Table of Contents**

- [org better api](#org-better-api)
- [Naming conventions](#naming-conventions)
- [Non-interactive APIs](#non-interactive-apis)
    - [properties](#properties)
        - [orgba-get-property `(name &optional dont-inherit)`](#orgba-get-property-name-optional-dont-inherit)
        - [orgba-get-property-create `(name value &optional dont-inherit)`](#orgba-get-property-create-name-value-optional-dont-inherit)
        - [orgba-set-property `(name value)`](#orgba-set-property-name-value)
    - [drawers](#drawers)
        - [orgba-get-drawer `(name &optional use-children)`](#orgba-get-drawer-name-optional-use-children)
        - [orgba-get-drawer-create `(name &optional use-children)`](#orgba-get-drawer-create-name-optional-use-children)
    - [tables](#tables)
        - [orgba-table-insert `(&rest columns)`](#orgba-table-insert-rest-columns)
        - [orgba-append-row `(row-data)`](#orgba-append-row-row-data)
        - [orgba-lisp-to-table `(table-data)`](#orgba-lisp-to-table-table-data)
    - [headings](#headings)
        - [orgba-next-heading](#orgba-next-heading)
        - [orgba-next-parent-sibling](#orgba-next-parent-sibling)
        - [orgba-top-parent](#orgba-top-parent)
        - [orgba-heading-at `(&optional point)`](#orgba-heading-at-optional-point)
        - [orgba-heading-title-at `(&optional point)`](#orgba-heading-title-at-optional-point)
        - [orgba-map-headings `(fun)`](#orgba-map-headings-fun)
    - [blocks](#blocks)
        - [orgba-in-any-block-p `(&optional point)`](#orgba-in-any-block-p-optional-point)
    - [search](#search)
    - [time and dates](#time-and-dates)
        - [orgba-time-as-timestamp `(&optional time active)`](#orgba-time-as-timestamp-optional-time-active)
    - [agenda](#agenda)
        - [orgba-agenda-is-task-p](#orgba-agenda-is-task-p)
    - [misc](#misc)
        - [orgba-restricted-p](#orgba-restricted-p)
- [Interactive commands](#interactive-commands)
    - [headings](#headings)
        - [orgba-narrow-to-top-heading](#orgba-narrow-to-top-heading)
    - [tables](#tables)
        - [orgba-table-select-cell](#orgba-table-select-cell)

<!-- markdown-toc end -->

# Naming conventions

- Functions which query for a specific element or property etc. are
  generally named `orgba-<thing>-at` and accept `point` as optional
  argument to do the query at that point.  Otherwise default to
  current `(point)`.
- Functions which query for a specific element in the scope of the
  current header are generally named `orgba-get-<thing>`.
- Use `heading` consistently instead of `entry`, `task`, `headline`, `heading`...

# Non-interactive APIs

## properties

### orgba-get-property `(name &optional dont-inherit)`

Get property `name` of current heading.

If `dont-inherit` is non-nil, do not use property inheritance.

### orgba-get-property-create `(name value &optional dont-inherit)`

Get property `name` of current heading or create it.

If no property with `name` exists, set it to `value`.  Return `value`.

If `dont-inherit` is non-nil, do not use property inheritance.

### orgba-set-property `(name value)`

Set property `name` of current heading to `value`.

Return `value`.

## drawers

### orgba-get-drawer `(name &optional use-children)`

Return position of drawer with `name` in current trees's content.

If no such drawer exists return nil.

The content of the tree is the area from the headline to the next
headline on any level.  This function does not search the child
subtrees unless `use-children` is non-nil.

### orgba-get-drawer-create `(name &optional use-children)`

Return position of drawer with `name` in current trees's content.

If no such drawer exists create it in the current tree.

The content of the tree is the area from the headline to the next
headline on any level.  This function does not search the child
subtrees unless `use-children` is non-nil.

## tables

### orgba-table-insert `(&rest columns)`

Insert a new empty table with `columns`.

### orgba-append-row `(row-data)`

### orgba-lisp-to-table `(table-data)`

## headings

### orgba-next-heading

Go to next heading or end of file if at the last heading.

Return point.

### orgba-next-parent-sibling

Go to the first sibling of parent heading or end of file.

Return point.

### orgba-top-parent

Go to the top parent of current heading.

Return point.

### orgba-heading-at `(&optional point)`

Return the heading element at `point`.

### orgba-heading-title-at `(&optional point)`

Return the heading title at `point`.

### orgba-map-headings `(fun)`

Map `fun` over all the headlines in the buffer (as elements)

## blocks

### orgba-in-any-block-p `(&optional point)`

Non-nil when point is in any org block.

## search

## time and dates

### orgba-time-as-timestamp `(&optional time active)`

Format `time` (defaults to now) as org timestamp.

If `active` is non-nil, format as active timestamp.

## agenda

### orgba-agenda-is-task-p

Return non-nil if line at point is a task.

## misc

### orgba-restricted-p

Return non-nil if org is restricted to a subtree.

# Interactive commands

## headings

### orgba-narrow-to-top-heading

Narrow to the top-most tree containing point.

## tables

### orgba-table-select-cell

Select the cell in org table the point is in.
