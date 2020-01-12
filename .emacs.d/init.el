;; Set package repos
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")))

;; EVIL mode
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

(display-time-mode t)

(load-theme 'wombat)

(set-frame-parameter (selected-frame) 'alpha '(95 . 50))
 (add-to-list 'default-frame-alist '(alpha . (95 . 50)))

(setq inhibit-splash-screen t)

;(when window-system
; (speedbar t))
