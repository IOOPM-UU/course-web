;; This is the assumed theme to get colours right of code
(load-theme 'dracula)

(defun tw/escape-brackets (text)
  (let ((text (replace-regexp-in-string "<" "&lt;" text)))
    (replace-regexp-in-string ">" "&gt;" text)))

(org-link-set-parameters
 "movie"
 :export (lambda (path desc backend)
           (cond
            ((eq 'html backend)
             (format "<video id=\"%s\" src=\"%s\" width=\"640\" controls></video>" path path))))
 :face '(:foreground "maroon"))

(org-link-set-parameters
 "aua"
 :export (lambda (path desc backend)
           (cond
            ((eq 'html backend)
             (format "<a href=\"http://wrigstad.com/ioopm18/achievements.html#%s\">%s</i></a>" path desc))))
             ;; (format "<a href=\"http://auportal.herokuapp.com/achievements/%s\">%s</i></a>" path desc))))
 :face '(:foreground "DarkGoldenrod3"))

(org-link-set-parameters
 "au"
 :export (lambda (path desc backend)
           (cond
            ((eq 'html backend)
             (format "<i class=\"fas fa-trophy\"></i> <a href=\"http://auportal.herokuapp.com/achievements/%s\">%s</i></a>" path desc))))
 :face '(:foreground "DarkGoldenrod3"))

(org-link-set-parameters
 "key"
 :export (lambda (path desc backend)
           (cond
            ((eq 'html backend)
             (format "<span class=\"kbd\">%s</span>"
                     (tw/escape-brackets (format "%s" (or desc path)))))))
 :face '(:background "dim gray" :foreground "white"))

(org-link-set-parameters
 "elisp"
 :export (lambda (path desc backend)
           (cond
            ((eq 'html backend)
             (format "%s" (eval (car (read-from-string path)))))))
 :face '(:background "red" :foreground "white"))

;; Think we can deprecate
;; (org-link-set-parameters
;;  "elisp-link"
;;  :export (lambda (path desc backend)
;;            (cond
;;             ((eq 'html backend)
;;              (format "<a href=\"%s\">%s</a>" (eval (car (read-from-string path))) desc))))
;;  :face '(:background "red" :foreground "white"))

(org-link-set-parameters
 "mark"
 :export (lambda (path desc backend)
           (cond
            ((eq 'html backend)
             (format "<mark>%s</mark>"
                     (tw/escape-brackets (format "%s" (or desc path)))))))
 :face '(:background "gold" :foreground "black"))

(org-link-set-parameters
 "fas"
 :export (lambda (path desc backend)
           (cond
            ((eq 'html backend)
             (format "<i class=\"fas fa-%s\"></i>" path))))
 :face '(:background "SlateBlue3" :foreground "white"))
 
(org-link-set-parameters
 "fab"
 :export (lambda (path desc backend)
           (cond
            ((eq 'html backend)
             (format "<i class=\"fab fa-%s\"></i>" path))))
 :face '(:background "SlateBlue3" :foreground "white"))
 
(org-link-set-parameters
 "quiz"
 :export (lambda (path desc backend)
           (cond
            ((eq 'html backend)
             (format "%s <a href=\"#\" data-toggle=\"tooltip\" data-html=\"true\" title=\"<b>Answer:</b> %s\"><i class=\"fas fa-question-circle\"></i></a>" desc (org-export-string-as path 'html t)))))
 :face '(:background "VioletRed3" :foreground "white"))

             ;; (format "%s <button type=\"button\" class=\"btn btn-secondary\" data-toggle=\"tooltip\" data-html=\"true\" title=\"%s\"><i class=\"fas fa-question-circle\"></button>" desc (org-export-string-as path 'html t)))))

(setq org-publish-project-alist
      '(("root"
         :base-directory "/home/stw/t/ioopm/2018/site/"
         :base-extension "org"
         :exclude "setup.org\\|footer.org\\|code-exams\\|readme.org"
         ;; :publishing-directory "/tmp/ioopm18/"
         :publishing-directory "/ssh:tobias@wrigstad.com:~/domains/wrigstad.com/www/ioopm18/"
         :publishing-function org-html-publish-to-html
         :headline-levels 3
         :section-numbers t
         :with-toc t
         :recursive t
         :auto-sitemap t                ; Generate sitemap.org automagically...
         :sitemap-filename "sitemap-autogen.org"  ; ... call it sitemap.org (it's the default)...
         :sitemap-title "Sitemap"         ; ... with title 'Sitemap'.
         :index-filename "sitemap.org"
         :index-title "Sitemap"
         :html-preamble t)

        ("images"
         :base-directory "/home/stw/t/ioopm/2018/site/images/"
         :base-extension "jpg\\|gif\\|png"
         ;; :publishing-directory "/tmp/ioopm18/images/"
         :publishing-directory "/ssh:tobias@wrigstad.com:~/domains/wrigstad.com/www/ioopm18/images/"
         :publishing-function org-publish-attachment)

        ("misc"
         :base-directory "/home/stw/t/ioopm/2018/site/misc/"
         :base-extension "el\\|pdf\\|c\\|h\\|java\\|txt\\|cast\\|png"
         ;; :publishing-directory "/tmp/ioopm18/misc/"
         :publishing-directory "/ssh:tobias@wrigstad.com:~/domains/wrigstad.com/www/ioopm18/misc/"
         :publishing-function org-publish-attachment)

        ("css"
         :base-directory "/home/stw/t/ioopm/2018/site/css/"
         :base-extension "css"
         ;; :publishing-directory "/tmp/ioopm18/css/"
         :publishing-directory "/ssh:tobias@wrigstad.com:~/domains/wrigstad.com/www/ioopm18/css/"
         :publishing-function org-publish-attachment)

        ("fonts"
         :base-directory "/home/stw/t/ioopm/2018/site/css/fonts/"
         :base-extension "ttf"
         :publishing-directory "/ssh:tobias@wrigstad.com:~/domains/wrigstad.com/www/ioopm18/css/fonts/"
         :publishing-function org-publish-attachment)

        ("js"
         :base-directory "/home/stw/t/ioopm/2018/site/js/"
         :base-extension "js"
         ;; :publishing-directory "/tmp/ioopm18/js/"
         :publishing-directory "/ssh:tobias@wrigstad.com:~/domains/wrigstad.com/www/ioopm18/js/"
         :publishing-function org-publish-attachment)

        ;; ("other"
        ;;  :base-directory "~/other/"
        ;;  :base-extension "css\\|el"
        ;;  :publishing-directory "/ssh:user@host:~/html/other/"
        ;;  :publishing-function org-publish-attachment)

        ("ioopm website" :components ("root" "misc" "fonts" "images" "css" "js"))))

;; Only use the HOME link, not the UP
(customize-set-variable 'org-html-home/up-format 
                        "<div id=\"org-div-home-and-up\">&nbsp;</div>")

;; (setq org-list-allow-alphabetical t)
(setq org-export-with-smart-quotes t)

;; ;; For inline dot code
;; (require 'ob-exp)

;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((dot . t))) ; this line activates dot

(defun my-org-confirm-babel-evaluate (lang body)
  (not (string= lang "dot")))  ; don't ask for dot
(setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate)


