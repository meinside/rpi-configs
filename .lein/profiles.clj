;; My .lein/profiles.clj
;;
;; last update: 2019.07.28.

;; Plugins and dependencies
;;
;; https://github.com/kumarshantanu/lein-exec
;; https://github.com/technomancy/leiningen/tree/master/lein-pprint
;; https://github.com/technomancy/slamhound
;; https://github.com/clojure-emacs/cider-nrepl

{:user {:plugins [[lein-exec "0.3.7"], [lein-pprint "1.2.0"], [cider/cider-nrepl "0.21.1"]]
        :dependencies [[slamhound "1.5.5"]]}}
