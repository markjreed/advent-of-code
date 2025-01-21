(if (not (= 2 (count *command-line-args*)))
    (binding [*out* *err*] 
        (println (format "Usage: %s input-file" (first *command-line-args*)))
        (System/exit 1)))

(def wires (atom {}))

(def resolved (atom {}))
(defn resolve-wire [wire] 
    (if (not (contains? (deref resolved) wire))
        (let [res (bit-and 65535 
                           (if (re-matches #"^\d+$" wire)
                               (Integer/parseInt wire)
                               (((deref wires) wire))))]
            (reset! resolved (conj (deref resolved) (vec (list wire res))))))
    ((deref resolved) wire))


(defn make-num [number] #(identity number))

(defn make-alias [wire] #(resolve-wire wire))

(defn make-not-num [number] #(bit-not number))

(defn make-not-wire [wire] #(bit-not (resolve-wire wire)))

(defn make-binop [left op right] 
    #(let [arg1 (resolve-wire left)
           arg2 (resolve-wire right)]
      (cond 
          (= op "AND")    (bit-and arg1 arg2)
          (= op "OR")     (bit-or arg1 arg2)
          (= op "LSHIFT") (bit-shift-left arg1 arg2)
          (= op "RSHIFT") (bit-shift-right arg1 arg2))))
      
(with-open [r (clojure.java.io/reader (first (rest *command-line-args*)))]
    (doseq [line (line-seq r)] 
        (let [[_ expr wire] (re-matches #"^(.*\S)\s*->\s*(\w+)$" line)]
            (reset! wires (conj (deref wires) (vec (list wire 
                (let [[_ number]       (re-matches #"^(\d+)$" expr)
                      [_ alias-wire]   (re-matches #"^(\w+)$" expr)
                      [_ not-number]   (re-matches #"^NOT\s+(\d+)" expr)
                      [_ not-wire]     (re-matches #"^NOT\s+(\w+)" expr)
                      [_ arg1 op arg2] (re-matches #"^(\w+)\s+(AND|OR|LSHIFT|RSHIFT)\s+(\w+)" expr)]
                    (cond 
                        number      (make-num (Integer/parseInt number))
                        alias-wire  (make-alias alias-wire)
                        not-number  (make-not-num (Integer/parseInt number))
                        not-wire    (make-not-wire not-wire)
                        op          (make-binop arg1 op arg2)
                        :else       (doall (printf "Unrecognized expression '%s'!" expr) (System/exit 1)))))))))))

(let [a (resolve-wire "a")]
    (println a)
    (reset! resolved {})
    (reset! wires (conj (deref wires) (vec (list "b" (make-num a)))))
    (println (resolve-wire "a")))
