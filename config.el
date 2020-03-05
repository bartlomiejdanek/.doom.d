;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "bard"
      user-mail-address "me@bard.sh")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Hack" :size 20))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-dracula)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq
  display-line-numbers-type t
  terraform-format-on-save-mode t
  projectile-project-search-path '("~/projects/")
  dired-dwim-target t
  +magit-hub-features t
  org-agenda-skip-scheduled-if-done t
  org-ellipsis " ▾ "
  org-bullets-bullet-list '("·")
  org-tags-column -80
  org-agenda-files (ignore-errors (directory-files +org-dir t "\\.org$" t))
  org-log-done 'time
  org-refile-targets (quote ((nil :maxlevel . 1)))
  org-capture-templates '(("x" "Note" entry
                           (file+olp+datetree "journal.org")
                           "**** [ ] %U %?" :prepend t :kill-buffer t)
                          ("t" "Task" entry
                           (file+headline "tasks.org" "Inbox")
                           "* [ ] %?\n%i" :prepend t :kill-buffer t))
  +org-capture-todo-file "tasks.org"
  org-super-agenda-groups '((:name "Today"
                                   :time-grid t
                                   :scheduled today)
                            (:name "Due today"
                                   :deadline today)
                            (:name "Important"
                                   :priority "A")
                            (:name "Overdue"
                                   :deadline past)
                            (:name "Due soon"
                                   :deadline future)
                            (:name "Big Outcomes"
                                   :tag "bo"))
  )

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(after! ruby
  (add-to-list 'hs-special-modes-alist
               `(ruby-mode
                 ,(rx (or "def" "class" "module" "do" "{" "[")) ; Block start
                 ,(rx (or "}" "]" "end"))                       ; Block end
                 ,(rx (or "#" "=begin"))                        ; Comment start
                 ruby-forward-sexp nil)))

(remove-hook 'enh-ruby-mode-hook #'+ruby|init-robe)
(company-terraform-init)

(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

(set-popup-rule! "^\\*Org Agenda" :side 'bottom :size 0.90 :select t :ttl nil)
(set-popup-rule! "^CAPTURE.*\\.org$" :side 'bottom :size 0.90 :select t :ttl nil)
(set-popup-rule! "^\\*org-brain" :side 'right :size 1.00 :select t :ttl nil)

; (after! org
;   (setq org-agenda-files (list "~/org/work.org"
;                                "~/org/devops.org"
;                                "~/org/keebs.org")))

(add-hook 'org-mode-hook #'auto-fill-mode)
(add-hook! 'org-mode-hook (company-mode -1))
(add-hook! 'org-capture-mode-hook (company-mode -1))

(after! org
  (set-face-attribute 'org-link nil
                      :weight 'normal
                      :background nil)
  (set-face-attribute 'org-code nil
                      :foreground "#a9a1e1"
                      :background nil)
  (set-face-attribute 'org-date nil
                      :foreground "#5B6268"
                      :background nil)
  (set-face-attribute 'org-level-1 nil
                      :foreground "steelblue2"
                      :background nil
                      :height 1.2
                      :weight 'normal)
  (set-face-attribute 'org-level-2 nil
                      :foreground "slategray2"
                      :background nil
                      :height 1.0
                      :weight 'normal)
  (set-face-attribute 'org-level-3 nil
                      :foreground "SkyBlue2"
                      :background nil
                      :height 1.0
                      :weight 'normal)
  (set-face-attribute 'org-level-4 nil
                      :foreground "DodgerBlue2"
                      :background nil
                      :height 1.0
                      :weight 'normal)
  (set-face-attribute 'org-level-5 nil
                      :weight 'normal)
  (set-face-attribute 'org-level-6 nil
                      :weight 'normal)
  (set-face-attribute 'org-document-title nil
                      :foreground "SlateGray1"
                      :background nil
                      :height 1.75
                      :weight 'bold)
  (setq org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))
(map! :ne "SPC n b" #'org-brain-visualize)

(defun worklog-today()
  "If you have a work-log then move to today's date.  If it isn't found
 then create it"
  (interactive "*")
  (beginning-of-buffer)
  (if (not (search-forward (format-time-string "# %d-%m-%Y") nil t 1))
      (progn
        (end-of-buffer)
        (insert (format-time-string "\n\n# %d-%m-%Y\n"))
        (insert (format-time-string "%d-%m-%Y\t%H:%M\t")))
    (progn
      (end-of-buffer)
      (insert (format-time-string "%d-%m-%Y\t%H:%M\t")))))

(defun worklog_hook ()
  (when (equalp (file-name-nondirectory (buffer-file-name)) "work.md")
    (worklog-today)
    )
)

(add-hook 'find-file-hook 'worklog_hook)

(defun worklog()
  (interactive "*")
  (find-file "~/work.md"))

(global-set-key (kbd "C-x w") 'worklog)

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

; (add-hook 'before-save-hook 'gofmt-before-save)

(defun my-go-mode-hook ()
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)

(with-eval-after-load 'go-mode
   (require 'go-autocomplete))

(defun my-go-mode-hook ()
  ; Use goimports instead of go-fmt
  (setq gofmt-command "goimports")
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
)
(add-hook 'go-mode-hook 'my-go-mode-hook)

(setq company-idle-delay 0.001)
