(if (display-graphic-p)
    (progn
      (push '(font . "Fira Mono 17") default-frame-alist) ; Sets prefered font
      (use-package gruvbox-theme
	:ensure t
	:config
        (load-theme 'gruvbox t))))
