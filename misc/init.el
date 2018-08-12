(require 'package)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
		    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))

(package-initialize)

;; Helper functions for setup
(defun tw/apply-all (state things)
  (mapc (lambda (fn) (apply fn state)) things))

(defun tw/turn-off (things)
  (tw/apply-all '(-1) things))

(defun tw/turn-on (things)
  (tw/apply-all '(t) things))

;; Customise display settings
(tw/turn-off
 '(tool-bar-mode   ;; no tool bar
   menu-bar-mode   ;; no menu bar
   blink-cursor-mode ;; don't blink cursor
   ))

;; Customise fringe size
(when (not (equal (window-system) nil))
  (fringe-mode (cons 16 8)))

;; Indicate end of buffer in the fringe (2013-05-26)
(toggle-indicate-empty-lines) ;;

(when (equal (window-system) nil)
  (use-package xclip))

;; No splash screen (2011-07-29)
(setq inhibit-splash-screen t)

;; Turn on column number
(column-number-mode t)

;; Let me use the entire screen please
(setq scroll-margin 0)

;; Make sure all remnants of a theme is unloaded before a new theme is loaded
(defadvice load-theme (before theme-dont-propagate activate)
  (mapc #'disable-theme custom-enabled-themes))

;; Make sure all buffer names are properly uniquified
(use-package uniquify
  :config
  (setq uniquify-buffer-name-style      'post-forward
        uniquify-separator              ":"
        uniquify-after-kill-buffer-p t  ;; rename after killing uniquified
        uniquify-ignore-buffers-re      "^\\*"))

;; ;; Set up emacs packages
;; (setq package-archives '(("gnu"       . "http://elpa.gnu.org/packages/")
;;                          ("marmalade" . "http://marmalade-repo.org/packages/")
;;                          ("melpa"     . "http://melpa.milkbox.net/packages/")))


;; Don't save customized settings in this file
(setq custom-file (expand-file-name "custom.el.new" user-emacs-directory))
(load custom-file)

;; ********************************************************
;; global text settings
;; --------------------------------------------------------

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default fill-column 66)

;; Emacs should not expect sentences to end with a period followed
;; by TWO spaces. (2013-04-11)
(setq sentence-end-double-space nil)

;; ********************************************************
;; programming
;; --------------------------------------------------------

;; Settings for C
(add-hook 'c-mode-common-hook
          (lambda ()
            (progn
              (setq comment-start "//")
              (setq comment-end "")
              (global-company-mode)
              (flycheck-mode t)
              )))

;; Trying out irony-mode (2017-10-10)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

;; Highlight dangerous C functions
(add-hook 'c-mode-hook (lambda () (font-lock-add-keywords nil '(("\\<\\(malloc\\|calloc\\|free\\|realloc\\)\\>" . font-lock-warning-face)))))

;; Misc programming settings
(use-package yasnippet)

(use-package yankpad
  :ensure t
  :defer 10
  :init
  (setq yankpad-file "~/.emacs.d/yankpad.org")
  :config
  (bind-key "<backtab>" 'yankpad-insert)
  (bind-key "<M-tab>" 'yankpad-expand)
  ;; (bind-key "<f7>" 'yankpad-map)
  ;; If you want to complete snippets using company-mode
  ;; (add-to-list 'company-backends #'company-yankpad)
  :diminish yankpad)

;; Added improved ggtags configuration (2016-06-26)
(use-package ggtags
  :init
  (add-hook 'c-mode-common-hook
            (lambda ()
              (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
                (ggtags-mode 1))))
  :bind (:map ggtags-mode-map
              ("C-c g s" . ggtags-find-other-symbol)
              ("C-c g h" . ggtags-view-tag-history)
              ("C-c g r" . ggtags-find-reference)
              ("C-c g f" . ggtags-find-file)
              ("C-c g c" . ggtags-create-tags)
              ("C-c g u" . ggtags-update-tags))
  :diminish ggtags-mode)

(electric-pair-mode)
(show-paren-mode)
(global-auto-revert-mode 1)

;; ********************************************************
;; keybindings
;; --------------------------------------------------------

(global-set-key (kbd "C-c C-f") 'vimish-fold)
(global-set-key (kbd "C-c C-x") 'vimish-fold-delete)
(global-set-key (kbd "C-c C-v") 'vimish-fold-toggle)
(global-set-key (kbd "C-c v") 'vimish-fold-toggle-all)

(global-set-key (kbd "C-x .")  'ispell-word)

(global-set-key (kbd "C-x <left>")  'windmove-left)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <up>")    'windmove-up)
(global-set-key (kbd "C-x <down>")  'windmove-down)

(global-set-key (kbd "C-x |")  'split-window-horizontally)
(global-set-key (kbd "C-x -")  'split-window-below)

(global-set-key (kbd "C-x ,")  'shrink-window-if-larger-than-buffer)

(global-set-key (kbd "C-c n") 'tw/cleanup-buffer)

;; (global-unset-key (kbd "C-x C-c")) ;; uncomment to unbind normal quit

(global-set-key (kbd "C-x r q") 'save-buffers-kill-terminal)

(global-set-key (kbd "C-x r e") 'tw/eval-region)

;; Create a scratch buffer
(global-set-key (kbd "M-n n") 'tw/create-scratch-buffer)

;; Use hippie expand rather than dabbrevs
(global-set-key (kbd "C--") 'dabbrev-expand)

;; Navigation
(global-set-key (kbd "M-g b") 'beginning-of-buffer)
(global-set-key (kbd "M-g e") 'end-of-buffer)

(global-set-key (kbd "M-g m") 'tw/push-mark-no-activate)
(global-set-key (kbd "M-g SPC") 'tw/jump-to-mark)

(global-set-key (kbd "C-'") 'ace-jump-char-mode)

;; Multiple cursors mode (2013-04-05)
(global-set-key (kbd "M-P")   'mc/edit-lines)
(global-set-key (kbd "M-Å")   'mc/mark-all-like-this)
(global-set-key (kbd "M-Ö")   'mc/mark-previous-like-this)
(global-set-key (kbd "M-Ä")   'mc/mark-next-like-this)

(global-set-key (kbd "M-j") 'tw/join-lines)

;; Visual regexp rocks! (2013-05-11)
(global-set-key (kbd "M-%") 'vr/query-replace)
(global-set-key (kbd "M-/") 'vr/replace)

;; Highlighting symbols in buffers (2013-04)
(global-set-key (kbd "M-å") 'highlight-symbol-at-point)
(global-set-key (kbd "M-ä") 'highlight-symbol-next)
(global-set-key (kbd "M-ö") 'highlight-symbol-prev)
(global-set-key (kbd "M-p") 'highlight-symbol-query-replace)

(global-set-key (kbd "§") 'tw/goto-matching-paren-or-insert)

;; ********************************************************
;; hooks
;; --------------------------------------------------------
;; Remove/kill completion buffer when done
(add-hook 'minibuffer-exit-hook
          '(lambda ()
             (let ((buffer "*Completions*"))
               (and (get-buffer buffer)
                    (kill-buffer buffer)))))

;; ********************************************************
;; packages
;; --------------------------------------------------------
;; Automatically detect language for Flyspell (2017-02-04)
(use-package guess-language
  :ensure t
  :defer t
  :init (add-hook 'text-mode-hook #'guess-language-mode)
  :config
  (setq guess-language-langcodes '((en . ("en_GB" "English"))
                                   (sv . ("sv_SE" "Swedish")))
        guess-language-languages '(en sv)
        guess-language-min-paragraph-length 30)
  :diminish guess-language)

;; Nice fuzzy matching for M-x
(use-package smex
  :config
  (progn
    (setq smex-save-file "~/.emacs.d/smex.save")
    (global-set-key (kbd "M-x") 'smex)
    (global-set-key (kbd "M-X") 'execute-extended-command)
    (smex-initialize)))

;; Show regexps live in the buffer
(use-package visual-regexp)

;; Setup imenu
(use-package idomenu
  :bind
  (("M-i" . idomenu)))

;; Setup GitGutter+
(use-package git-gutter+
  :config
  (progn
    (when (not (equal (window-system) nil))
      (require 'git-gutter-fringe+))
    (global-git-gutter+-mode t)
    (setq git-gutter+-hide-gutter t))
  :diminish git-gutter+
  :bind
  (("C-x g t" . git-gutter+-mode)
   ("C-x g n" . git-gutter+-next-hunk)
   ("C-x g p" . git-gutter+-previous-hunk)
   ("C-x g v" . git-gutter+-revert-hunk)))

;; Use ido mode
(use-package ido
  :config
  (ido-mode t)
  (ido-everywhere 1)
  (setq ido-enable-prefix nil
        ido-enable-flex-matching t
        ido-case-fold nil
        ido-auto-merge-work-directories-length -1
        ido-create-new-buffer 'always
        ido-use-filename-at-point nil
        ido-max-prospects 10))

(use-package ido-vertical-mode
  :config
  (ido-vertical-mode))

;; Avy (2016-06-15)
(use-package avy-mode
  :bind
  (("M-g c" . avy-goto-char)))

;; Start up emacs server
(use-package server
  :config
  (unless (server-running-p)
    (server-start)))

;; Persistent bookmark navigation
(use-package bm
  :config
  (set-variable 'bm-highlight-style (if (display-graphic-p) 'bm-highlight-only-fringe 'bm-highlight-only-line))
  :bind
  (("M-o"      . bm-toggle)
   ("M-<down>" . bm-next)
   ("M-<up>"   . bm-previous)))

;; Move text up or down
(use-package move-text
  :bind
  (("M-S-<up>"   . move-text-up)
   ("M-S-<down>" . move-text-down)))

(use-package projectile
  :diminish projectile-mode
  :config
  (projectile-global-mode))

(use-package meghanada
  :diminish meghanada-mode "MH"
  :config
  (add-hook 'java-mode-hook
            (lambda ()
              ;; meghanada-mode on
              (meghanada-mode t)
              (flycheck-mode t)
              (add-hook 'before-save-hook 'delete-trailing-whitespace))))


;; ********************************************************
;; file handling
;; --------------------------------------------------------

;; Move to trash when deleting stuff
(when (equal system-type 'darwin)
  (setq delete-by-moving-to-trash t
        trash-directory "~/.Trash/emacs"))

;; Backup settings
(setq backup-directory-alist
      `(("." . ,(expand-file-name
                 (concat user-emacs-directory "file-backups")))))

;; Allow 10 backups, warn if backing up file of size > 1000000
(setq delete-old-versions t
      backup-by-copying   t
      kept-new-versions   20
      kept-old-versions   10
      version-control     t
      large-file-warning-threshold   1000000)

(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))


;; ********************************************************
;; LaTeX support
;; --------------------------------------------------------
(add-hook 'latex-mode-hook 'subword-mode)
(setq latex-load-hook (quote (imenu-add-menubar-index)))
(setq latex-mode-hook (quote (imenu-add-menubar-index)))
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)

;; Kill a window, and its temporary buffer if not tied to a file
(global-set-key (kbd "ESC ESC") 'tw/kill-and-close)

;; ********************************************************
;; Themes
;; --------------------------------------------------------
(unless (equal (window-system) nil)
  (load-theme 'hc-zenburn))

;; ********************************************************
;; org-mode settings
;; --------------------------------------------------------
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c a") 'org-agenda)

(setq org-src-fontify-natively t)

;; ********************************************************
;; PDF Tools
;; ********************************************************
;; (pdf-tools-install)
(use-package pdf-tools
  :pin manual ;; manually update
  :config
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  ;; more fine-grained zooming
  (setq pdf-view-resize-factor 1.1)
  ;; keyboard shortcuts
  (define-key pdf-view-mode-map (kbd "h") 'pdf-annot-add-highlight-markup-annotation)
  (define-key pdf-view-mode-map (kbd "t") 'pdf-annot-add-text-annotation)
  (define-key pdf-view-mode-map (kbd "D") 'pdf-annot-delete)
  (define-key pdf-view-mode-map (kbd "M-g b") 'pdf-view-first-page)
  (define-key pdf-view-mode-map (kbd "M-g e") 'pdf-view-last-page))

;; ********************************************************
;; Various definitions
;; ********************************************************
(defun tw/untabify-buffer ()
  (interactive)
  (untabify (point-min) (point-max)))

(defun tw/indent-buffer ()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun tw/cleanup-buffer-safe ()
  "Perform a bunch of safe operations on the whitespace content of a buffer.
Does not indent buffer, because it is used for a before-save-hook, and that
might be bad."
  (interactive)
  (delete-trailing-whitespace))

(defun tw/cleanup-buffer ()
  "Perform a bunch of operations on the whitespace content of a buffer.
Including indent-buffer, which should not be called automatically on save."
  (interactive)
  (tw/untabify-buffer)
  (tw/cleanup-buffer-safe)
  (tw/indent-buffer))

(defun tw/create-scratch-buffer nil
  "create a new scratch buffer to work in. (could be *scratch* - *scratchX*)"
  (interactive)
  (let ((n 0)
        bufname)
    (while (progn
             (setq bufname (concat "*scratch"
                                   (if (= n 0) "" (int-to-string n))
                                   "*"))
             (setq n (1+ n))
             (get-buffer bufname)))
    (switch-to-buffer (get-buffer-create bufname))
    (text-mode)
    ))

(defun tw/kill-and-close nil
  (interactive)
  (progn
    (if (buffer-modified-p)
        (message "Keeping buffer")
      (kill-buffer))
    (delete-window)))

(defun tw/s-trim-left (s)
  "Remove whitespace at the beginning of S."
  (if (string-match "\\`[ \t\n\r]+" s)
      (replace-match "" t t s)
    s))

(defun tw/s-trim-right (s)
  "Remove whitespace at the end of S."
  (if (string-match "[ \t\n\r]+\\'" s)
      (replace-match "" t t s)
    s))

(defun tw/s-trim (s)
  "Remove whitespace at the beginning and end of S."
  (tw/s-trim-left (tw/s-trim-right s)))

(defun tw/eval-region ()
  (interactive)
  (progn
    (eval-region (region-beginning) (region-end))
    (message "Evaluated %s!"
             (if (> (- (region-end) (region-beginning)) 48)
                 (tw/s-trim (format "%s...%s"
                                    (buffer-substring (region-beginning) (+ (region-beginning) 24))
                                    (buffer-substring (- (region-end) 24) (region-end))))
               (tw/s-trim
                (buffer-substring (region-beginning) (region-end)))))))

;; Joining lines together with optional argument
(defun tw/join-lines (no-lines)
  (interactive "p")
  (dotimes
      (number no-lines)
    (join-line -1)))

(defun tw/push-mark-no-activate ()
  "Pushes `point' to `mark-ring' and does not activate the region
Equivalent to \\[set-mark-command] when \\[transient-mark-mode] is disabled"
  (interactive)
  (push-mark (point) t nil)
  (message "Pushed mark to ring"))

(defun tw/jump-to-mark ()
  "Jumps to the local mark, respecting the `mark-ring' order.
This is the same as using \\[set-mark-command] with the prefix argument."
  (interactive)
  (set-mark-command 1))

(defun tw/goto-matching-paren-or-insert (arg)
  (interactive "p")
  (cond ((looking-at "[([{]") (forward-sexp 1) (backward-char))
        ((looking-at "[])}]") (forward-char) (backward-sexp 1))
        (t (self-insert-command (or arg 1)))))

;; Add separator to linum-mode
(setq linum-format "%4d \u2502 ")
(global-linum-mode)

;; Local Variables:
;; mode: emacs-lisp
;; byte-compile-warnings: (not mapcar)
;; End:
