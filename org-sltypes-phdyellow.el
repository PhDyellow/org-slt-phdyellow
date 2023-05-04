;;; org-slt-phdyellow.el --- A predefined ontology for org-super-links  -*- lexical-binding: t; -*-

;; Copyright (C) 2023

;; Author:  <phil@prime-ai-nixos>
;; Keywords: convenience, hypermedia, outlines

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Leverages org-super-links and org-sltypes. org-slt-phdyellow provides a bunch of defined org-sltypes in a keymap.

;; To use it, just create a keybinding for the keymap org-slt-phdyellow-map

;; (keymap-set org-mode-map "C-c C-i" org-slt-phdyellow)

;; The uppercase version of each link uses org-super-links-insert-link, which uses a stored link. The lowercase version of each link type uses org-super-links-link, which opens a ui to select the target. All keys in the map are prefixed with 'C-' for consistency with org keybinding. The 'C-M-' variant of each link creates a "back-back-link" which behaves like you had moved to the target node then created the link, although this may not work for inline links. 'C-M-S' variant.

;; There are a lot of variations. Inline or in drawer, insert from stored link or open target selection ui, forward-link or backward link?

;; Transient might be the way to go. Have toggles for inline, use stored link, or "inverse link"
;; Then need 8 functions per link type.

;;; Code:

(require 'org-sltypes)
(require 'transient)
(require 'cl-lib)

(transient-define-prefix org-slt-phdyellow ()
  "Transient for create org-super-links with types.
This function defines a set of types from org-slt-phdyellow.

Users may add additional link types with `transient-insert-suffix' and related."

  [:description "Create link with backlink"
		[:description "Switches"
			      :pad-keys t
			      :class transient-row
			      ("a" "Invert backlink: Create a forward link to this node from other node" "backlink");;something that sets toggles)
			      ("s" "Use stored link, created by org-super-links-store-link" "stored");; toggle
			      ("d" "Make forward link inline. Not compatible with Invert Backlink" "inline");;toggle
			      ]
		;; [:description "Link types"
		;; 	      :pad-keys t
		;; 	      :class 'transient-columns
		;; 	      ("f" "link-type="  :choices 'org-slt-phdyellow-link-types)
		;; 	      ]
		;; [:description "Create Link"
		;; 	      ("RET" "Create" org-slt-phdyellow-create-link)]
		[:description "Link Types"
			      ("u" "Author of" org-slt-phdyellow-authored)
			      ("i" "Published" org-slt-phdyellow-published)
			      ("o" "Contains" org-slt-phdyellow-contains)
			      ("j" "Sparks" org-slt-phdyellow-sparks)
			      ("l" "Leads to" org-slt-phdyellow-leads-to)
			      ("k" "Employs" org-slt-phdyellow-employs)
			      ("m" "Colleague" org-slt-phdyellow-colleague)
			      ("n" "Supports" org-slt-phdyellow-supports)
			      ("v" "Contradicts" org-slt-phdyellow-contradicts)
			      ("c" "Agrees with" org-slt-phdyellow-agrees)
			      ("x" "Actions" org-slt-phdyellow-actions)
			      ("r" "Pursues" org-slt-phdyellow-pursues)
			      ]
		]
  (interactive)
  (if (eq major-mode 'org-mode)
      (transient-setup 'org-slt-phdyellow)
    (message "Not in an org-mode buffer")))


(transient-define-suffix org-slt-phdyellow-authored (args)
  "Author / Authored_by link"
  (interactive (list (transient-args 'org-slt-phdyellow)))
  (org-sltypes-link (transient-arg-value "backlink" args)
		    (transient-arg-value "inline" args)
		    (transient-arg-value "stored" args)
		    "AUTHORED_BY"
		    "AUTHOR_OF"
                    'org-sltypes-time-stamp-inactive
                    'org-sltypes-time-stamp-inactive
                    nil
                    nil))

(transient-define-suffix org-slt-phdyellow-published (args)
  "Published / Published_by link"
  (interactive (list (transient-args 'org-slt-phdyellow)))
  (org-sltypes-link (transient-arg-value "backlink" args)
		    (transient-arg-value "inline" args)
		    (transient-arg-value "stored" args)
		    "PUBLISHED_BY"
		    "PUBLISHER_OF"
                    'org-sltypes-time-stamp-inactive
                    'org-sltypes-time-stamp-inactive
                    nil
                    nil))

(transient-define-suffix org-slt-phdyellow-contains (args)
  "Contains other thing"
  (interactive (list (transient-args 'org-slt-phdyellow)))
  (org-sltypes-link (transient-arg-value "backlink" args)
		    (transient-arg-value "inline" args)
		    (transient-arg-value "stored" args)
		    "CONTAINED_BY"
		    "CONTAINS"
                    'org-sltypes-time-stamp-inactive
                    'org-sltypes-time-stamp-inactive
                    nil
                    nil))

(transient-define-suffix org-slt-phdyellow-sparks (args)
  "Sparks other thing, a general connection between the two"
  (interactive (list (transient-args 'org-slt-phdyellow)))
  (org-sltypes-link (transient-arg-value "backlink" args)
		    (transient-arg-value "inline" args)
		    (transient-arg-value "stored" args)
		    "SPARKS"
		    "SPARKS"
                    'org-sltypes-time-stamp-inactive
                    'org-sltypes-time-stamp-inactive
                    nil
                    nil))

(transient-define-suffix org-slt-phdyellow-contradicts (args)
  "Contradicts other thing. Symmetric."
  (interactive (list (transient-args 'org-slt-phdyellow)))
  (org-sltypes-link (transient-arg-value "backlink" args)
		    (transient-arg-value "inline" args)
		    (transient-arg-value "stored" args)
		    "CONTRADICTS"
		    "CONTRADICTS"
                    'org-sltypes-time-stamp-inactive
                    'org-sltypes-time-stamp-inactive
                    nil
                    nil))

(transient-define-suffix org-slt-phdyellow-agrees (args)
  "Agrees with other thing. Symmetric."
  (interactive (list (transient-args 'org-slt-phdyellow)))
  (org-sltypes-link (transient-arg-value "backlink" args)
		    (transient-arg-value "inline" args)
		    (transient-arg-value "stored" args)
		    "AGREES_WITH"
		    "AGREES_WITH"
                    'org-sltypes-time-stamp-inactive
                    'org-sltypes-time-stamp-inactive
                    nil
                    nil))

(transient-define-suffix org-slt-phdyellow-colleagues (args)
  "This and other are Colleagues. Symmetric."
  (interactive (list (transient-args 'org-slt-phdyellow)))
  (org-sltypes-link (transient-arg-value "backlink" args)
		    (transient-arg-value "inline" args)
		    (transient-arg-value "stored" args)
		    "COLLEAGUES"
		    "COLLEAGUES"
                    'org-sltypes-time-stamp-inactive
                    'org-sltypes-time-stamp-inactive
                    nil
                    nil))


(transient-define-suffix org-slt-phdyellow-actions (args)
  "Actions other thing"
  (interactive (list (transient-args 'org-slt-phdyellow)))
  (org-sltypes-link (transient-arg-value "backlink" args)
		    (transient-arg-value "inline" args)
		    (transient-arg-value "stored" args)
		    "ACTIONED_BY"
		    "ACTIONS"
                    'org-sltypes-time-stamp-inactive
                    'org-sltypes-time-stamp-inactive
                    nil
                    nil))

(transient-define-suffix org-slt-phdyellow-pursues (args)
  "Pursues other thing"
  (interactive (list (transient-args 'org-slt-phdyellow)))
  (org-sltypes-link (transient-arg-value "backlink" args)
		    (transient-arg-value "inline" args)
		    (transient-arg-value "stored" args)
		    "PURSUED_BY"
		    "PURSUES"
                    'org-sltypes-time-stamp-inactive
                    'org-sltypes-time-stamp-inactive
                    nil
                    nil))

(transient-define-suffix org-slt-phdyellow-supports (args)
  "Supports other thing"
  (interactive (list (transient-args 'org-slt-phdyellow)))
  (org-sltypes-link (transient-arg-value "backlink" args)
		    (transient-arg-value "inline" args)
		    (transient-arg-value "stored" args)
		    "SUPPORTED_BY"
		    "SUPPORTS"
                    'org-sltypes-time-stamp-inactive
                    'org-sltypes-time-stamp-inactive
                    nil
                    nil))

(transient-define-suffix org-slt-phdyellow-employs (args)
  "Employs person"
  (interactive (list (transient-args 'org-slt-phdyellow)))
  (org-sltypes-link (transient-arg-value "backlink" args)
		    (transient-arg-value "inline" args)
		    (transient-arg-value "stored" args)
		    "EMPLOYED_BY"
		    "EMPLOYS"
                    'org-sltypes-time-stamp-inactive
                    'org-sltypes-time-stamp-inactive
                    nil
                    nil))

(transient-define-suffix org-slt-phdyellow-leads (args)
  "Leads to other thing"
  (interactive (list (transient-args 'org-slt-phdyellow)))
  (org-sltypes-link (transient-arg-value "backlink" args)
		    (transient-arg-value "inline" args)
		    (transient-arg-value "stored" args)
		    "FOLLOWS_FROM"
		    "LEADS_TO"
                    'org-sltypes-time-stamp-inactive
                    'org-sltypes-time-stamp-inactive
                    nil
                    nil))


(provide 'org-slt-phdyellow)
;;; org-slt-phdyellow.el ends here
