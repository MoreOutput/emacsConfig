(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(package-refresh-contents)

(setenv "PATH" (concat (getenv "PATH") ":/Users/rockybevins/.nvm/v0.10.40/bin/"))
(setq exec-path (append exec-path '("/Users/rockybevins/.nvm/v0.10.40/bin/")))
(package-install 'flycheck)
(global-flycheck-mode)
(add-hook 'after-init-hook #'global-flycheck-mode)
;; Adding JSHint via flymake
;;(require 'flymake-jshint)
;;(add-hook 'js-mode-hook 'flymake-mode)

;; current theme
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(load-theme 'badwolf t)

;; autocomplete
(ac-config-default)

;; auto buffer and fs sync
(global-auto-revert-mode t)

;; always enable projectile mode
(projectile-global-mode)

;; Turn off beeping sound	
(setq visible-bell 1)

;; Flexible file find and tabs
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(setq indent-line-function 'insert-tab)
(global-linum-mode t)

(setq-default indent-tabs-mode t)
(setq-default tab-width 4) ; Assuming you want your tabs to be four spaces wide
(defvaralias 'c-basic-offset 'tab-width)

(defun ido-imenu ()
  "Update the imenu index and then use ido to select a symbol to navigate to.
Symbols matching the text at point are put first in the completion list."
  (interactive)
  (imenu--make-index-alist)
  (let ((name-and-pos '())
        (symbol-names '()))
    (flet ((addsymbols
            (symbol-list)
            (when (listp symbol-list)
              (dolist (symbol symbol-list)
                (let ((name nil) (position nil))
                  (cond
                   ((and (listp symbol) (imenu--subalist-p symbol))
                    (addsymbols symbol))

                   ((listp symbol)
                    (setq name (car symbol))
                    (setq position (cdr symbol)))

                   ((stringp symbol)
                    (setq name symbol)
                    (setq position
                          (get-text-property 1 'org-imenu-marker symbol))))

                  (unless (or (null position) (null name))
                    (add-to-list 'symbol-names name)
                    (add-to-list 'name-and-pos (cons name position))))))))
      (addsymbols imenu--index-alist))
    ;; If there are matching symbols at point, put them at the beginning
    ;; of `symbol-names'.
    (let ((symbol-at-point (thing-at-point 'symbol)))
      (when symbol-at-point
        (let* ((regexp (concat (regexp-quote symbol-at-point) "$"))
               (matching-symbols
                (delq nil (mapcar
                           (lambda (symbol)
                             (if (string-match regexp symbol) symbol))
                           symbol-names))))
          (when matching-symbols
            (sort matching-symbols (lambda (a b) (> (length a) (length b))))
            (mapc
             (lambda (symbol)
               (setq symbol-names (cons symbol (delete symbol symbol-names))))
             matching-symbols)))))
    (let* ((selected-symbol (ido-completing-read "Symbol? " symbol-names))
           (position (cdr (assoc selected-symbol name-and-pos))))
      (push-mark)
      (if (overlayp position)
          (goto-char (overlay-start position))
        (goto-char position)))))

(global-set-key (kbd "C-x C-i") 'ido-imenu)
    
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
		[default default default italic underline success warning error])
 '(custom-enabled-themes (quote (tango-dark)))
 '(custom-safe-themes
		(quote
		 ("604648621aebec024d47c352b8e3411e63bdb384367c3dd2e8db39df81b475f5" default)))
 '(notmuch-search-line-faces
		(quote
		 (("unread" :foreground "#aeee00")
		  ("flagged" :foreground "#0a9dff")
		  ("deleted" :foreground "#ff2c4b" :bold t))))
 '(tab-stop-list
		(quote
		 (4 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80 84 88 92 96 100 104 108 112 116 120))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
