;;; orgba.el --- org buffer api -*- lexical-binding: t -*-

;; Copyright (C) 2018 Matúš Goljer

;; Author: Matúš Goljer <matus.goljer@gmail.com>
;; Maintainer: Matúš Goljer <matus.goljer@gmail.com>
;; Version: 0.0.1
;; Created:  8th September 2018
;; Package-requires: ((dash "2.14.0"))
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Better API for org mode

;;; Code:

(require 'org)

(defun orgba-get-property (name &optional dont-inherit)
  "Get property NAME of current heading.

If DONT-INHERIT is non-nil, do not use property inheritance."
  (org-entry-get (point) name (not dont-inherit)))

(defun orgba-get-property-create (name value &optional dont-inherit)
  "Get property NAME of current heading or create it.

If no property with NAME exists, set it to VALUE.  Return VALUE.

If DONT-INHERIT is non-nil, do not use property inheritance."
  (or (orgba-get-property name dont-inherit)
      (orgba-set-property name value)))

(defun orgba-set-property (name value)
  "Set property NAME of current heading to VALUE.

Return VALUE."
  (org-entry-put (point) name value)
  value)

(defun orgba-get-drawer (name &optional use-children)
  "Return position of drawer with NAME in current trees's content.

If no such drawer exists return nil.

The content of the tree is the area from the headline to the next
headline on any level.  This function does not search the child
subtrees unless USE-CHILDREN is non-nil."
  (save-excursion
    (org-back-to-heading)
    (forward-line)
    (let ((limit (or
                  (when use-children (save-excursion (org-end-of-subtree t)))
                  (save-excursion (re-search-forward org-heading-regexp nil t))
                  (point-max))))
      (catch 'done
        (while (re-search-forward org-drawer-regexp limit t)
          (when (equal (match-string 1) name)
            (forward-line)
            (throw 'done (point))))))))

(defun orgba-get-drawer-create (name &optional use-children)
  "Return position of drawer with NAME in current trees's content.

If no such drawer exists create it in the current tree.

The content of the tree is the area from the headline to the next
headline on any level.  This function does not search the child
subtrees unless USE-CHILDREN is non-nil."
  (save-excursion
    (-if-let (drawer-pos (orgba-get-drawer name use-children))
        drawer-pos
      (org-insert-property-drawer)
      (org-back-to-heading)
      (re-search-forward org-drawer-regexp nil t 2)
      (org-insert-drawer nil name)
      (point))))

(defun orgba-table-insert (&rest columns)
  "Insert a new empty table with COLUMNS."
  (insert (format "| %s |\n|-"
                  (mapconcat 'identity columns " | ")))
  (org-table-align))

(defun orgba-next-heading ()
  "Go to next heading or end of file if at the last heading.

Return point."
  (or (outline-next-heading) (goto-char (point-max)))
  (point))

(defun orgba-next-parent-sibling ()
  "Go to the first sibling of parent heading or end of file.

Return point."
  (condition-case err
      (progn
        (outline-up-heading 1)
        (outline-get-next-sibling))
    (error
     (goto-char (point-max)))))

(defun orgba-top-parent ()
  "Go to the top parent of current heading."
  (interactive)
  (while (org-up-heading-safe)))

(defun orgba-heading-at (&optional point)
  "Return the heading element at POINT."
  (save-excursion
    (goto-char (or point (point)))
    (org-back-to-heading)
    (cadr (org-element-at-point))))

(defun orgba-heading-title-at (&optional point)
  "Return the heading element at POINT."
  (plist-get (orgba-heading-at point) :title))

(defun orgba-map-headings (fun)
  "Map FUN over all the headings in the buffer (as elements)"
  (org-element-map (org-element-parse-buffer 'headline) 'headline fun))

(defun orgba-in-any-block-p ()
  "Non-nil when point is in any org block."
  (save-match-data
    (let ((case-fold-search t)
          (lim-up (save-excursion (outline-previous-heading)))
          (lim-down (save-excursion (outline-next-heading))))
      (org-between-regexps-p "^[ \t]*#\\+begin_" "^[ \t]*#\\+end_" lim-up lim-down))))

(defun orgba-time-as-timestamp (&optional time active)
  "Format TIME (defaults to now) as org timestamp.

If ACTIVE is non-nil, format as active timestamp."
  (with-temp-buffer
    (org-insert-time-stamp
     (or time (org-current-time org-clock-rounding-minutes))
                           'with-hm (not active))
    (buffer-string)))

(defun orgba-agenda-is-task-p ()
  "Return non-nil if line at point is a task."
  (org-get-at-bol 'org-marker))

(defun orgba-restricted-p ()
  "Return non-nil if org is restricted to a subtree."
  (marker-buffer org-agenda-restrict-begin))

(defun orgba-narrow-to-top-heading ()
  "Narrow to the top-most tree containing point."
  (interactive)
  (save-excursion
    (ignore-errors (while (outline-up-heading 1)))
    (org-narrow-to-subtree)))

(defun orgba-table-select-cell ()
  "Select the cell in org table the point is in."
  (interactive)
  (when (org-table-p)
    (let ((b (save-excursion
               (re-search-forward "|")
               (backward-char 1)
               (skip-chars-backward " ")
               (point)))
          (e (save-excursion
               (re-search-backward "|")
               (forward-char 1)
               (skip-chars-forward " ")
               (point))))
      (push-mark b t t)
      (goto-char e))))

(provide 'orgba)
;;; orgba.el ends here
