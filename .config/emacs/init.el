;;; init.el --- Personal Emacs config  -*- lexical-binding: t; -*-

;;; Packages

(require 'package)
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))
(package-initialize)

;; First run: no package index yet, so fetch it before `use-package' installs.
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

;; Keep customize output out of this file.
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file 'noerror 'nomessage)

;;; Editor settings (from nvim/sets.lua)

(setq-default indent-tabs-mode nil      ; expandtab
              tab-width 4               ; tabstop
              fill-column 80)           ; colorcolumn = 80

(setq make-backup-files nil             ; nobackup
      auto-save-default nil             ; noswapfile
      create-lockfiles nil
      scroll-margin 8                   ; scrolloff = 8
      scroll-conservatively 101
      ring-bell-function #'ignore
      use-short-answers t)

(setq display-line-numbers-type 'relative) ; number + relativenumber
(global-display-line-numbers-mode 1)
(column-number-mode 1)

(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)

(global-auto-revert-mode 1)
(save-place-mode 1)
(recentf-mode 1)
(electric-pair-mode 1)                  ; nvim-autopairs

;;; Appearance

;; gruber-darker-theme 0.7 lacks a lexical-binding cookie, which Emacs 31
;; warns about on every start. Upstream issue; not ours to fix.
(require 'warnings)
(add-to-list 'warning-suppress-log-types '(files missing-lexbind-cookie))
(add-to-list 'warning-suppress-types '(files missing-lexbind-cookie))

(use-package gruber-darker-theme
  :config (load-theme 'gruber-darker t))

;;; Evil

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil        ; evil-collection handles this
        evil-want-C-u-scroll t
        evil-want-C-d-scroll t
        evil-undo-system 'undo-redo
        evil-shift-width 4
        evil-ex-search-highlight-all nil ; nohlsearch
        ;; guicursor = "": block cursor in every mode
        evil-normal-state-cursor 'box
        evil-insert-state-cursor 'box
        evil-visual-state-cursor 'box
        evil-replace-state-cursor 'box
        evil-operator-state-cursor 'box)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-surround               ; vim-surround
  :after evil
  :config (global-evil-surround-mode 1))

;;; Leader key (Space, as in nvim)

(use-package general
  :after evil
  :config
  (general-create-definer my/leader
    :states '(normal visual motion)
    :keymaps 'override
    :prefix "SPC")

  (my/leader
    "pv" '(dired-jump :which-key "file explorer")))

(use-package which-key
  :config (which-key-mode 1))

;;; Minibuffer completion & search (telescope.lua)

(use-package vertico
  :init (vertico-mode 1)
  :custom (vertico-cycle t)
  :bind (:map vertico-map
              ("C-j" . vertico-next)
              ("C-k" . vertico-previous)))

;; Space-separated, any-order matching, like telescope's fuzzy filter.
(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package marginalia
  :init (marginalia-mode 1))

(use-package savehist                   ; remembered history ranks candidates
  :ensure nil
  :init (savehist-mode 1))

(use-package consult
  :bind (([remap switch-to-buffer] . consult-buffer)
         ([remap yank-pop]         . consult-yank-pop)
         ([remap goto-line]        . consult-goto-line)))

(my/leader
  "pf" '(consult-fd       :which-key "find files")
  "ps" '(consult-ripgrep  :which-key "live grep")
  "/"  '(consult-line     :which-key "search buffer")
  "b"  '(consult-buffer   :which-key "buffers")
  "pr" '(consult-recent-file :which-key "recent files"))

;;; Startup finished

(setq gc-cons-threshold (* 16 1024 1024))

;;; init.el ends here
