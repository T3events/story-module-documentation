(defsystem "story-module-documentation"
  :defsystem-depends-on ("story-module-system")
  :class :story-module-system
  :category "none"
  :icon :puzzle-piece
  :description "none"
  :version "0.1"
  :author "unknown"
  :license "unknown"
  :serial t
  :depends-on ("story-modules" "story-module-polymer" "story-module-files")
  :components ((:static-file "story-module-documentation.asd")
               (:file "documentation")
               (:file "demo-documentation")))

