;; VIEW-KILL

;; Displays the entire kill ring as a single page of numbered items.
;; Select a number to insert that item into your current buffer.
;; Use <SPACE> to scroll.
;; The length of the kill ring is controlled by the variable `kill-ring-max';


(defun view-kill ()
  (interactive)
  (save-excursion
    (save-window-excursion
      (let ((working-buffer (current-buffer))
            (new-buffer (get-buffer-create "kill-ring-view"))
            (count 0)
            (custom-map (copy-keymap minibuffer-local-map))
            (selection nil)
            )      
        (unwind-protect
            (progn
              (define-key custom-map " " 'scroll-other-window)
              
              (switch-to-buffer new-buffer t)
              (delete-other-windows)
              
              (dolist (x kill-ring)
                (insert (concat "----- " 
                                (number-to-string count) 
                                " -----"))
                (newline)
                (insert x)
                (newline)
                (newline)
                (setq count (+ count 1))
                )
              (goto-char (point-min))
              
              (let ((choice (read-from-minibuffer "choose: " nil custom-map t nil "x")))
                (and (numberp choice)
                     (< choice count)
                     (progn
                       (set-buffer working-buffer)
                       (insert (nth choice kill-ring))
                       (setq selection choice)
                       ))
                ))
          (kill-buffer new-buffer) ; unwind-protect clean-up form
          )
        selection
        ))))
