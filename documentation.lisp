(in-package :story)

(define-story-module documentation
  :root (namestring (asdf:system-relative-pathname :story-module-documentation ""))
  :imports (("documentation-demo" documentation-demo-template))
  :directories ("docs")
  :depends-on (:polymer :iron-request :files :paper-button :iron-icons :paper-icon-button))

(define-template documentation-demo
  :properties ()
  :style (("#listing" :margin-bottom 20px)
          ("span.doc-entry" :color blue :cursor pointer :display inline-block
                            :padding "6px 10px 6px 10px"))
  :content ((:div :id "top")
            (:div :id "index")
            (:div :id "viewer"
                  (:div :id "controls" (icon-button :icon "arrow-back" :on-tap "viewerBack"))
                  (:div :id "contents"))))

(define-template-method documentation-demo attached ()
  (with-content (top index viewer)
    (hide index)
    (hide viewer)
    (fetch-json "/docs/.file-listing"
                (lambda (val)
                  (loop for el in val
                        do ((@ top append)
                            (dom (:paper-button nil ((style "margin-right:10px;")
                                                     (on-tap "selectDocIndex")
                                                     (value (@ el name))))
                                 (@ el name))))))))

(define-template-method documentation-demo select-doc-index (event)
  (let ((root (+ "/docs/" (@ event target value) "/")))
    (with-content (index viewer)
      (hide viewer)
      (show index)
      (fetch-json (+ root "index.json")
                  (lambda (val)
                    (set-html index "")
                    (loop for el in (@ val entries)
                          do (append-child index (dom (:span "doc-entry" ((entry el)
                                                                          (root root)
                                                                          (on-tap "selectDocEntry")))
                                                      (@ el name)))))))))

(define-template-method documentation-demo select-doc-entry (event)
  (let* ((entry (@ event target entry))
         (pos ((@ entry path index-of) "#"))
         (base (if (plusp pos) ((@ entry path substr) 0 pos) (@ entry path)))
         (into (when (plusp pos) ((@ entry path substr) (1+ pos)))))
    (with-content (index viewer contents)
      (hide index)
      (show viewer)
      (request (+ (@ event target root) base ".html")
               (lambda (val)
                 (set-html contents (@ val response))
                 (when into ((@  (id into) scroll-into-view))))))))

(define-template-method documentation-demo viewer-back (event)
  (with-content (index viewer)
    (hide viewer)
    (show index)))
