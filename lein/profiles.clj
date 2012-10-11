{:user {
  :plugins [[lein-marginalia "0.7.0"]
            [lein-swank "1.4.4"]
            [lein-cljsbuild "0.2.7"]
            [lein-repls "1.9.5"]
            [lein-newnew "0.3.4"]
            [clj-stacktrace "0.2.4"]
            [lein-ring "0.7.5"]
            [lein-pprint "1.1.1"]
            [ring-mock "0.1.3"]]
  :dependencies  {clj-stacktrace "0.2.4"}
  :injections  [
      (let  [orig  (ns-resolve
                     (doto
                       'clojure.stacktrace
                       require)
                     'print-cause-trace)
             new
             (ns-resolve
               (doto
                 'clj-stacktrace.repl
                 require)
               'pst)]
        (alter-var-root
          orig
          (constantly
            @new)))]}}
