;; Automatically load paredit when editing a lisp file
;; More at http://www.emacswiki.org/emacs/ParEdit
(require 'cl)

(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)


(defun define-keys (args)
  (lexical-let ((defkeys (lambda (map args)
                           (-map (lambda (x)
                                   (if map
                                       (define-key map (kbd (car x)) (cadr x))
                                     (global-set-key (kbd (car x)) (cadr x))))
                                 (-partition 2 args)))))
    (-map (lambda (modelist)
            (cond
             ((eq (car modelist) :global) (funcall defkeys nil (cdr modelist)))
             (t (lexical-let ((modelist modelist))
                  (if (stringp (caddr modelist))
                      (eval-after-load (caddr modelist)
                        `(-map (lambda (x)
                                 (define-key ,(cadr modelist) (kbd (car x)) (cadr x)))
                               (-partition 2 ',(cdddr modelist))))
                    (add-hook (caddr modelist)
                              (lambda ()
                                (funcall defkeys (eval (cadr modelist)) (cdddr modelist)))))))))
          (-partition-by-header #'keywordp args))))
;; Paredit key mappings for evil mode
;;    :local paredit-mode-map paredit-mode-hook


 (define-keys   
    '( :local paredit-mode-map paredit-mode-hook
             "M-[" paredit-wrap-square
             "M-{" paredit-wrap-curly
             "M-p" paredit-backward-down
             "M-;" paredit-forward-down
             "C-M-p" paredit-backward-up
             "C-M-;" paredit-forward-up
             "C-M-q" beginning-of-defun
             "M-q" highlight-symbol-prev
             "M-k" kill-line
             "M-d" kill-region
             "C-w" paredit-backward-kill-word))

;; eldoc-mode shows documentation in the minibuffer when writing code
;; http://www.emacswiki.org/emacs/ElDoc
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)
