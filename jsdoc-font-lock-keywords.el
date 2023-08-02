;;; jsdoc-font-lock-keywords.el --- Extra font lock keywords for jsdoc comments -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Karim Aziiev <karim.aziiev@gmail.com>

;; Author: Karim Aziiev <karim.aziiev@gmail.com>
;; URL: https://github.com/KarimAziev/jsdoc-font-lock-keywords
;; Version: 0.1.0
;; Keywords: faces languages
;; Package-Requires: ((emacs "24.1"))

;; This file is NOT part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Extra font lock keywords for jsdoc comments

;;; Code:

(defconst jsdoc-font-lock-keywords-typedoc-link-tag-regexp
  "\\[\\[.*?\\]\\]"
  "Matches a typedoc link.")

(defconst jsdoc-font-lock-keywords-typedoc-literal-markup-regexp
  "\\(`+\\).*?\\1"
  "Matches a typedoc keyword markup.")

(defconst jsdoc-font-lock-keywords-jsdoc-before-tag-regexp
  "\\(?:^\\s-*\\*+\\|/\\*\\*\\)\\s-*"
  "Matches everything we allow before the @ of a jsdoc tag.")

;; This was taken from js2-mode.
(defconst jsdoc-font-lock-keywords-jsdoc-param-tag-regexp
  (concat jsdoc-font-lock-keywords-jsdoc-before-tag-regexp
          "\\(@"
          (regexp-opt
           '("arg"
             "argument"
             "param"
             "prop"
             "property"
             "typedef"))
          "\\)"
          "\\s-*\\({[^}]+}\\)?"         ; optional type
          "\\s-*\\[?\\([[:alnum:]_$\.]+\\)?\\]?"  ; name
          "\\_>")
  "Matches jsdoc tags with optional type and optional param name.")

;; This was taken from js2-mode.
;; and extended with tags in http://usejsdoc.org/
(defconst jsdoc-font-lock-keywords-jsdoc-typed-tag-regexp
  (concat jsdoc-font-lock-keywords-jsdoc-before-tag-regexp
          "\\(@"
          (regexp-opt
           '("enum"
             "extends"
             "field"
             "id"
             "implements"
             "lends"
             "mods"
             "requires"
             "return"
             "returns"
             "throw"
             "throws"
             "type"
             "yield"
             "yields"))
          "\\)\\s-*\\({[^}]+}\\)?")
  "Matches jsdoc tags with optional type.")

;; This was taken from js2-mode.
;; and extended with tags in http://usejsdoc.org/
(defconst jsdoc-font-lock-keywords-jsdoc-arg-tag-regexp
  (concat jsdoc-font-lock-keywords-jsdoc-before-tag-regexp
          "\\(@"
          (regexp-opt
           '("access"
             "alias"
             "augments"
             "base"
             "borrows"
             "bug"
             "callback"
             "config"
             "default"
             "define"
             "emits"
             "exception"
             "extends"
             "external"
             "fires"
             "func"
             "function"
             "host"
             "kind"
             "listens"
             "member"
             "memberof"
             "method"
             "mixes"
             "module"
             "name"
             "namespace"
             "requires"
             "since"
             "suppress"
             "this"
             "throws"
             "var"
             "variation"
             "version"))
          "\\)\\s-+\\([^ \t]+\\)")
  "Matches jsdoc tags with a single argument.")

;; This was taken from js2-mode
;; and extended with tags in http://usejsdoc.org/
(defconst jsdoc-font-lock-keywords-jsdoc-empty-tag-regexp
  (concat jsdoc-font-lock-keywords-jsdoc-before-tag-regexp
          "\\(@"
          (regexp-opt
           '("abstract"
             "addon"
             "async"
             "author"
             "class"
             "classdesc"
             "const"
             "constant"
             "constructor"
             "constructs"
             "copyright"
             "default"
             "defaultValue"
             "privateRemarks"
             "deprecated"
             "desc"
             "description"
             "event"
             "example"
             "exec"
             "export"
             "exports"
             "file"
             "fileoverview"
             "final"
             "func"
             "function"
             "generator"
             "global"
             "hidden"
             "hideconstructor"
             "ignore"
             "implicitcast"
             "inheritdoc"
             "inner"
             "instance"
             "interface"
             "license"
             "method"
             "mixin"
             "noalias"
             "noshadow"
             "notypecheck"
             "override"
             "overview"
             "owner"
             "package"
             "preserve"
             "preservetry"
             "private"
             "protected"
             "public"
             "readonly"
             "remarks"
             "static"
             "summary"
             "supported"
             "todo"
             "tutorial"
             "virtual"))
          "\\)\\s-*")
  "Matches empty jsdoc tags.")

(defface jsdoc-font-lock-keywords-jsdoc-tag
  '((t :foreground "SlateGray"))
  "Face used to highlight @whatever tags in jsdoc comments."
  :group 'typescript)

(defface jsdoc-font-lock-keywords-jsdoc-type
  '((t :foreground "SteelBlue"))
  "Face used to highlight {FooBar} types in jsdoc comments."
  :group 'typescript)

(defface jsdoc-font-lock-keywords-jsdoc-value
  '((t :foreground "gold4"))
  "Face used to highlight tag values in jsdoc comments."
  :group 'typescript)

(defface jsdoc-font-lock-keywords-access-modifier-face
  '((t (:inherit font-lock-keyword-face)))
  "Face used to highlight access modifiers."
  :group 'typescript)

(defface jsdoc-font-lock-keywords-this-face
  '((t (:inherit font-lock-keyword-face)))
  "Face used to highlight this keyword."
  :group 'typescript)

(defface jsdoc-font-lock-keywords-primitive-face
  '((t (:inherit font-lock-keyword-face)))
  "Face used to highlight builtin types."
  :group 'typescript)


(defun jsdoc-font-lock-keywords-documentation-font-lock-helper (re limit)
  "Check whether jsdoc highlighting with regexp RE is to be applied.
Searches for the next token to be highlighted.
The optional second argument LIMIT is a buffer position that bounds the search."
  (let* ((result))
    (while
        (and
         (not result)
         (re-search-forward re limit t)
         (if
             (let ((parse (syntax-ppss)))
               (and
                (nth 4 parse)
                ;; Inside a comment ...
                (save-match-data
                  (save-excursion
                    (goto-char (nth 8 parse))
                    (looking-at "/\\(\\*\\*\\|/\\)")))))
             (setq result (point))
           t)))
    result))

(defun jsdoc-font-lock-keywords-jsdoc-param-matcher (limit)
  "Font-lock mode matcher to find jsdoc parameter tags in documentation.
The optional second argument LIMIT is a buffer position that bounds the search."
  (jsdoc-font-lock-keywords-documentation-font-lock-helper jsdoc-font-lock-keywords-jsdoc-param-tag-regexp limit))

(defun jsdoc-font-lock-keywords-jsdoc-typed-tag-matcher (limit)
  "Font-lock mode matcher to find jsdoc typed tags in documentation.
The optional second argument LIMIT is a buffer position that bounds the search."
  (jsdoc-font-lock-keywords-documentation-font-lock-helper
   jsdoc-font-lock-keywords-jsdoc-typed-tag-regexp limit))

(defun jsdoc-font-lock-keywords-jsdoc-arg-tag-matcher (limit)
  "Find jsdoc tags that take one argument in documentation.
The optional second argument LIMIT is a buffer position that bounds the search."
  (jsdoc-font-lock-keywords-documentation-font-lock-helper
   jsdoc-font-lock-keywords-jsdoc-arg-tag-regexp limit))

(defun jsdoc-font-lock-keywords-jsdoc-empty-tag-matcher (limit)
  "Font-lock mode matcher to find jsdoc tags without argument in documentation.
The optional second argument LIMIT is a buffer position that bounds the search."
  (jsdoc-font-lock-keywords-documentation-font-lock-helper
   jsdoc-font-lock-keywords-jsdoc-empty-tag-regexp limit))

(defun jsdoc-font-lock-keywords-typedoc-link-matcher (limit)
  "Font-lock mode matcher to find typedoc links in documentation.
The optional second argument LIMIT is a buffer position that bounds the search."
  (jsdoc-font-lock-keywords-documentation-font-lock-helper
   jsdoc-font-lock-keywords-typedoc-link-tag-regexp limit))

(defun jsdoc-font-lock-keywords-typedoc-literal-markup-matcher (limit)
  "Font-lock mode matcher to find typedoc literal markup in documentation.
The optional second argument LIMIT is a buffer position that bounds the search."
  (jsdoc-font-lock-keywords-documentation-font-lock-helper
   jsdoc-font-lock-keywords-typedoc-literal-markup-regexp limit))

(defconst jsdoc-font-lock-keywords
  `((jsdoc-font-lock-keywords-jsdoc-param-matcher
     (1
      'jsdoc-font-lock-keywords-jsdoc-tag
      t
      t)
     (2
      'jsdoc-font-lock-keywords-jsdoc-type
      t
      t)
     (3
      'jsdoc-font-lock-keywords-jsdoc-value
      t
      t))
    (jsdoc-font-lock-keywords-jsdoc-typed-tag-matcher
     (1
      'jsdoc-font-lock-keywords-jsdoc-tag
      t
      t)
     (2
      'jsdoc-font-lock-keywords-jsdoc-type
      t
      t))
    (jsdoc-font-lock-keywords-jsdoc-arg-tag-matcher
     (1
      'jsdoc-font-lock-keywords-jsdoc-tag
      t
      t)
     (2
      'jsdoc-font-lock-keywords-jsdoc-value
      t
      t))
    (jsdoc-font-lock-keywords-jsdoc-empty-tag-matcher
     (1
      'jsdoc-font-lock-keywords-jsdoc-tag
      t
      t))
    (jsdoc-font-lock-keywords-typedoc-link-matcher
     (0
      'jsdoc-font-lock-keywords-jsdoc-value
      t))
    (jsdoc-font-lock-keywords-typedoc-literal-markup-matcher
     (0 'jsdoc-font-lock-keywords-jsdoc-value t))))

;;;###autoload
(defun jsdoc-font-lock-keywords-add (&optional mode)
  "Add jsdoc font lock keywords to MODE."
  (font-lock-add-keywords
   mode
   jsdoc-font-lock-keywords))

;;;###autoload
(defun jsdoc-font-lock-keywords-remove (&optional mode)
  "Remove jsdoc font lock keywords to MODE."
  (font-lock-remove-keywords mode
                             jsdoc-font-lock-keywords))

(provide 'jsdoc-font-lock-keywords)
;;; jsdoc-font-lock-keywords.el ends here