(defun synorg-forward ()
"Forward syntex for Org.

Trying to jump from current line to matched line LaTeX counterpart.
From there, jump to PDF line via `AUCTeX'\'s `TeX-view'.

See `synorg-backward' for backward direction and command line
setup."
    (interactive)
    (let ((text (replace-regexp-in-string
                 ;; leading, trailing spaces;
                 ;; backslashes, brackets, curly braces, dollars
                 "\\(^[ \t]+\\|[ \t]+$\\|\\\\[^ {\\[]*\\|\\[.*\\]\\|{.*}\\|\\$.*\\$\\)" ".*"
                 (buffer-substring-no-properties
                  (line-beginning-position) (line-end-position))))
          (tex-file (replace-regexp-in-string "org\\'" "tex" (buffer-file-name))))
      (save-window-excursion
        (find-file tex-file)
        (goto-char (point-min))
        (re-search-forward text)
        (TeX-view))))
  (defun synorg-backward (file line)
    "Backward syntex for Org.

Trying to jump from `line' in LaTeX `file'.
`emacsclient --no-wait --eval \"(synorg-backward \\\"%file\\\" %line)\"'"
    (let ((text (save-window-excursion
                  (find-file file)
                  (goto-line line)
                  (replace-regexp-in-string
                   ;; leading, trailing spaces;
                   ;; backslashes, brackets, curly braces, dollars
                   "\\(^[ \t]+\\|[ \t]+$\\|\\\\[^ {\\[]*\\|\\[.*\\]\\|{.*}\\|\\$.*\\$\\)" ".*"
                   (buffer-substring-no-properties
                    (line-beginning-position) (line-end-position)))))
          (org-file (replace-regexp-in-string "tex\\'" "org" file)))
      (find-file org-file)
      (goto-char (point-min))
      (re-search-forward text)
      (org-show-entry)
      (recenter)
      (global-hl-line-mode global-hl-line-mode)))

(provide 'synorg)
