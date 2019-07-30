;; .lein/profiles.clj
;;
;; last update: 2019.07.29.

{:user {
        ;; plugins
        :plugins [
                  ;; https://github.com/kumarshantanu/lein-exec
                  [lein-exec "0.3.7"]

                  ;; https://github.com/technomancy/leiningen/tree/master/lein-pprint
                  [lein-pprint "1.2.0"]

                  ;; https://github.com/clojure-emacs/cider-nrepl
                  [cider/cider-nrepl "0.21.1"]

                  ;; https://github.com/venantius/ultra
                  ;;[venantius/ultra "0.6.0"]

                  ;; https://github.com/xsc/lein-ancient
                  [lein-ancient "0.6.15"]]

        ;; dependencies
        :dependencies [
                       ;; https://github.com/technomancy/slamhound
                       [slamhound "1.5.5"]]

        ;; global variables
        :global-vars {*print-length* 20}}

 ;; profile for headless nREPL
 :headless-repl {
                 ;; plugins
                 :plugins []

                 ;; dependencies
                 :dependencies []

                 ;; global variables
                 :global-vars {*print-length* 20}}}
