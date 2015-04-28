
(require 'evil-leader)
(global-evil-leader-mode)

;;Evil mode on
(require 'evil)
(evil-mode 1)

;;Enable search vim style
(setq evil-search-module 'evil-search
      evil-want-C-u-scroll t
      evil-want-C-w-in-emacs-state )

(require 'evil-surround)
(global-evil-surround-mode 1)

(require 'evil-easymotion)
(evilem-define (kbd "<f12>") 'evil-forward-word-begin)
