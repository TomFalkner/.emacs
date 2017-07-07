;;; Package --- Summary

;;; Commentary:
;;; Code:

(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
	     '("marmalade" . "https://marmalade-repo.org/packages/"))

(package-initialize)

;; (require 'color-theme-railscasts)
;; (color-theme-railscasts)

;; (require solarized-theme)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

(setq visible-bell nil)
(setq ring-bell-function 'ignore)

;; Make it easier to move between windows
(windmove-default-keybindings)

(setq org-replace-disputed-keys t)

; hide splash screen
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message t)

(setq-default indent-tabs-mode nil)


; GUI emacs doesn't load $PATH
(exec-path-from-shell-initialize)
(setenv "GEM_HOME" "/Users/mrf/.rvm/gems/ruby-2.1.1")

(add-to-list 'load-path "~/lib/slime")
(add-to-list 'load-path "~/lib/slime/contrib")

(require 'slime-autoloads)

(setq inferior-lisp-program "/usr/local/bin/clisp")

(slime-setup)

;(if (display-graphic-p)
;     (load-theme 'color-theme-railscasts t))

(add-to-list 'custom-theme-load-path "~/emacs-libs/emacs-color-theme-solarized-master/")
;; (load-theme 'solarized-dark)
;; (load-theme 'railscasts-reloaded t)
;; (require 'color-theme-sanityinc-tomorrow)
;; m-x color-theme-sanityinc-tomorrow-night

(load-theme 'dracula t)


(ac-config-default)

(global-auto-complete-mode t)

(require 'yasnippet)
(yas-global-mode 1)
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))

;; Make tab competion work with term
(add-hook 'term-mode-hook (lambda ()
                            (yas-minor-mode -1)))

;; Make tab competion work with org mode
(add-hook 'org-mode-hook (lambda ()
                           (yas-minor-mode -1)))

;; Lets show latex previews
(setq org-latex-create-formula-image-program 'dvipng)
(setq org-preview-latex-default-process 'dvipng)

;; Remap yas expand so autocomplete can use TAB
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)
(define-key yas-minor-mode-map (kbd "C-c C-p") 'yas-insert-snippet)

(require 'expand-region)
(global-set-key (kbd "C-=") 'er/expand-region)

;; Web Mode setup
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)

(require 'web-mode)

(add-to-list 'auto-mode-alist '("\\.cshtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.scss\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.liquid\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-m")

(setq web-mode-engines-alist '(("angularjs" . "\\.html\\'")))

;; Tern
(add-to-list 'load-path "~/emacs-libs/tern/emacs")
(autoload 'tern-mode "tern.el" nil t)

(add-hook 'js2-mode-hook (lambda ()
                           (push 'ac-source-yasnippet ac-sources)))

(add-hook 'js2-mode-hook
          (defun my-js2-mode-setup ()
            (push 'ac-source-yasnippet ac-sources)
            (tern-mode t)
            (when (executable-find "eslint")
              (flycheck-select-checker 'javascript-eslint))))


(add-hook 'js2-mode-hook (lambda ()
                           (tern-mode t)))

(add-hook 'js2-mode-hook #'(lambda ()
                             (define-key js2-mode-map "\C-ci" 'js-doc-insert-function-doc)))

(eval-after-load 'tern
  '(progn
     (require 'tern-auto-complete)
     (tern-ac-setup)))

(add-hook 'json-mode-hook #'(lambda ()
                              (when (executable-find "jsonlint")
                                (flycheck-select-checker 'json-jsonlint))))

(add-hook 'js2-mode-hook
          #'(lambda ()
              (define-key js2-mode-map (kbd "C-x C-e") 'nodejs-repl-send-last-sexp)
              (define-key js2-mode-map (kbd "C-c C-r") 'nodejs-repl-send-region)
              (define-key js2-mode-map (kbd "C-c C-l") 'nodejs-repl-load-file)
              (define-key js2-mode-map (kbd "C-c C-z") 'nodejs-repl-switch-to-repl)))
              
              


(defun my-web-mode-hook ()
  "Hooks for web mode."
  (setq web-mode-markup-indent-offset 4)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))

(add-hook 'web-mode-hook 'my-web-mode-hook)

;; SCSS Indentation

(defun my-css-hook ()
  "Hook for scss via css."
  (setq css-indent-offset 2))

(add-hook 'css-mode-hook 'my-css-hook)

(global-set-key (kbd "C-x g") 'magit-status)

;; Whitespace
(require 'whitespace)

;; Sublime style matching
(require 'ido)
(require 'flx-ido)

(ido-mode 1)
(ido-everywhere 1)
(flx-ido-mode 1)
;; Disable ido faces
(setq ido-enable-flex-matching t)
(setq ido-use-faces nil)
(ido-vertical-mode)


;; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

(setq-default flycheck-disabled-checkers
              (append flycheck-disabled-checkers
                      '(javascript-jshint javascript-jscs)))

(load "~/emacs-libs/flycheck-glsl/flycheck-glsl.el" nil t)
;(add-hook 'after-init-hook #'global-flycheck-mode)


(eval-after-load "org-present"
  '(progn
     (add-hook 'org-present-mode-hook
               (lambda ()
                 (org-present-big)
                 (org-display-inline-images)
                 (org-present-hide-cursor)
                 (org-present-read-only)))
     (add-hook 'org-present-mode-quit-hook
               (lambda ()
                 (org-present-small)
                 (org-remove-inline-images)
                 (org-present-show-cursor)
                 (org-present-read-write)))))

(setq org-src-fontify-natively t)

;; C Sharp
(setq omnisharp-server-executable-path "/usr/local/bin/omnisharp")
(add-hook 'csharp-mode-hook 'omnisharp-mode)

;; F-Sharp
(setq inferior-fsharp-program "/usr/local/bin/fsharpi --readline-")
(setq fsharp-compiler "/usr/local/bin/fsharpc")


;; Typescript
(add-hook 'typescript-mode-hook
          (lambda ()
            (tide-setup)
            (flycheck-mode +1)
            (setq flycheck-check-syntax-automatically '(save mode-enabled))
            (eldoc-mode +1)
            (company-mode-on)))

(setq company-tooltip-align-annotations t)

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (tide-setup)
              (flycheck-mode +1)
              (setq flycheck-check-syntax-automatically '(save mode-enabled))
              (eldoc-mode +1)
              (company-mode-on))))



;; misc
(column-number-mode t)


;; my stuff

(editorconfig-mode 1)

(defalias 'scroll-ahead 'scroll-up)
(defalias 'scroll-behind 'scroll-down)

(defun scroll-n-lines-ahead (&optional n)
  "Scroll ahead N lines (1 by default)."
  (interactive "P")
  (scroll-ahead (prefix-numeric-value n)))

(defun scroll-n-lines-behind (&optional n)
  "Scroll behind N lines (1 by default)"
  (interactive "P")
  (scroll-behind (prefix-numeric-value n)))

(global-set-key "\C-q" 'scroll-n-lines-behind)
(global-set-key "\C-z" 'scroll-n-lines-ahead)

(defun point-to-top ()
  "Put point on top line of window."
  (interactive)
  (move-to-window-line 0))
(global-set-key "\M-," 'point-to-top)

(fset 'fix-matrix
   (lambda (&optional arg) "Keyboard macro." (interactive "p") (kmacro-exec-ring-item (quote ("\336\336\336\336\336\336\336\336\336\336\336\336" 0 "%d")) arg)))


(add-to-list 'auto-mode-alist '("\\.manifest\\'" . json-mode))

(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

(require 're-builder)
(setq reb-re-syntax 'string)

(setq jiralib-url "https://pollinate-jira.atlassian.net")


; Yeggee optimizations
(global-set-key "\C-x\C-m" 'execute-extended-command)

(defalias 'qrr 'query-replace-regexp)

;;(global-set-key "\C-c\C-m" 'execute-extended-command)

;; (global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)

(global-set-key "\C-co" 'other-window)
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default bold shadow italic underline bold bold-italic bold])
 '(ansi-color-names-vector
   (vector "#eaeaea" "#d54e53" "#b9ca4a" "#e7c547" "#7aa6da" "#c397d8" "#70c0b1" "#424242"))
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes (quote (sanityinc-tomorrow-bright)))
 '(custom-safe-themes
   (quote
    ("1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "8db4b03b9ae654d4a57804286eb3e332725c84d7cdab38463cb6b97d5762ad26" "a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" default)))
 '(fci-rule-color "#424242")
 '(frame-background-mode (quote dark))
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (--map
    (solarized-color-blend it "#002b36" 0.25)
    (quote
     ("#b58900" "#2aa198" "#dc322f" "#6c71c4" "#859900" "#cb4b16" "#268bd2"))))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#546E00" . 20)
     ("#00736F" . 30)
     ("#00629D" . 50)
     ("#7B6000" . 60)
     ("#8B2C02" . 70)
     ("#93115C" . 85)
     ("#073642" . 100))))
 '(hl-bg-colors
   (quote
    ("#7B6000" "#8B2C02" "#990A1B" "#93115C" "#3F4D91" "#00629D" "#00736F" "#546E00")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(js2-bounce-indent-p t)
 '(js2-highlight-level 3)
 '(js2-strict-trailing-comma-warning nil)
 '(magit-diff-use-overlays nil)
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#546E00" "#B4C342" "#00629D" "#2aa198" "#d33682" "#6c71c4")))
 '(org-format-latex-options
   (quote
    (:foreground default :background default :scale 1.5 :html-foreground "Black" :html-background "Transparent" :html-scale 1.0 :matchers
                 ("begin" "$1" "$" "$$" "\\(" "\\["))))
 '(package-selected-packages
   (quote
    (sass-mode csharp-mode jq-mode dracula-theme csv-mode sed-mode color-theme-sanityinc-tomorrow railscasts-reloaded-theme org-jira js-doc web-beautify yaml-mode git-timemachine ido-vertical-mode zenburn-theme web-mode typescript tuareg tle tide tern-auto-complete solarized-theme skewer-mode scss-mode restclient railscasts-theme racket-mode projectile php-mode org-present omnisharp nodejs-repl markdown-mode magit js3-mode js2-refactor glsl-mode geiser fsharp-mode flycheck-typescript-tslint flycheck-ocaml flx-ido expand-region exec-path-from-shell emmet-mode editorconfig-core editorconfig dockerfile-mode docker color-theme cider angular-snippets angular-mode 0blayout)))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(projectile-mode t nil (projectile))
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#d54e53")
     (40 . "#e78c45")
     (60 . "#e7c547")
     (80 . "#b9ca4a")
     (100 . "#70c0b1")
     (120 . "#7aa6da")
     (140 . "#c397d8")
     (160 . "#d54e53")
     (180 . "#e78c45")
     (200 . "#e7c547")
     (220 . "#b9ca4a")
     (240 . "#70c0b1")
     (260 . "#7aa6da")
     (280 . "#c397d8")
     (300 . "#d54e53")
     (320 . "#e78c45")
     (340 . "#e7c547")
     (360 . "#b9ca4a"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#990A1B" "#dc322f" "#546E00" "#859900" "#7B6000" "#b58900" "#00629D" "#268bd2" "#93115C" "#d33682" "#00736F" "#2aa198" "#839496" "#657b83")))
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-object-property ((t nil))))
(put 'erase-buffer 'disabled nil)
