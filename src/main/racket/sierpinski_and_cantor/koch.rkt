#lang racket
(require 2htdp/image 2htdp/universe)
(require "spacer.rkt")
(provide (all-defined-out))

(define (pow base exponent)
  (cond
    [(zero? exponent) 1]
    [else
     (* base (pow base (- exponent 1)))]))

; Xingjian Xuanyuan
(define (koch-curve-line side-length depth color)
  (cond
    [(zero? depth) (line side-length 0 color)]
    [else
     (local [(define smaller (koch-curve-line (/ side-length 3) (- depth 1) color))]
       (beside/align
        "bottom"
        smaller
        (rotate 60 smaller)
        (rotate -60 smaller)
        smaller))]))

(define (koch-snowflake-line side-length depth color)
  (cond
    [(zero? depth) (line side-length 0 color)]
    [else
     (local [(define c (koch-curve-line (/ side-length 3) (- depth 1) color))]
       (above
        (beside
         (rotate 60 c)
         (rotate -60 c))
        (flip-vertical c)))]))

; https://docs.racket-lang.org/teachpack/2htdpimage-guide.html
(define (koch-curve side-length n)
  (cond
    [(zero? n) (triangle side-length "solid" "black")]
    [else
     (local [(define smaller (koch-curve (/ side-length 3) (- n 1)))]
       (beside/align "bottom"
                     smaller
                     (rotate 60 smaller)
                     (rotate -60 smaller)
                     smaller))]))
    
(define (koch-snowflake side-length n)
  (cond
    [(zero? n) (triangle side-length "solid" "black")]
    [else
     (local [(define c (koch-curve (/ side-length 3) (- n 1)))]
       (above
        (beside
         (rotate 60 c)
         (rotate -60 c))
        (flip-vertical c)))]))

(define (koch-curve-line-2 side-length depth)
  (cond
    [(zero? depth) (line (/ side-length (pow 3 3)) 0 "blue")]
    [else
     (local [(define next-depth (- depth 1))
             (define next-length (/ side-length 3))
             (define (khelper ang) (rotate ang (koch-curve-line-2 next-length next-depth)))]
       (apply beside/align "bottom"
              (map khelper (list 0 60 -60 0))))]))

; https://course.ccs.neu.edu/cs2500f14/
(define PI (* 4.0 (atan 1.0)))

(define SCN_WIDTH 500)
(define SCN_HEIGHT 500)
(define base-scene (empty-scene SCN_WIDTH SCN_HEIGHT))

(struct posn (x y))

; Given a position, put a single dot into the scene
(define (put-dot scn p)
  (place-image (circle 3 "solid" "blue")
               (posn-x p) (posn-y p)
               scn))

; Given a list of positions, draw the dots
(define (draw-dots ps)
  (cond [(empty? ps) base-scene]
        [else (put-dot (draw-dots (rest ps)) (first ps))]))

; Put a line in the scene starting at (x, y) len distance in the given
; direction with the given color
(define (put-line x y ang len color scn)
  (place-image (line (* (cos ang) len)
                     (* (sin ang) len) color)
               (+ x (* (cos ang) (/ len 2)))
               (+ y (* (sin ang) (/ len 2))) scn))

; TODO: fractal-tree, fractal-snowflake, draw to scene

(module+ main ; evualated when enclosing module is run directly (that is: not via require)
  ; (koch-curve 400 3)
  ; (koch-curve 400 4)
  ; (koch-curve 400 5)
  ; (koch-curve 400 6)
  ; (koch-curve 400 7)

  ; (koch-curve-line 729 3)
  ; (koch-curve-line 729 4)
  ; (koch-curve-line 729 5)
  ; (koch-curve-line 729 6)
  ; (koch-curve-line 729 7)

  ; (koch-snowflake-line 300 3 "blue")
  (koch-snowflake-line 300 4 "blue")
  (koch-snowflake-line 300 5 "blue")
  (koch-snowflake-line 300 6 "blue")
  ; (koch-snowflake-line 300 7 "blue")

  ; (koch-snowflake 300 3)
  ; (koch-snowflake 300 4)
  ; (koch-snowflake 300 5)
  ; (koch-snowflake 300 6)
  ; (koch-snowflake 300 7)

  ; (koch-curve-line-2 300 3)
  (koch-curve-line-2 300 4)
  (koch-curve-line-2 300 5)
  (koch-curve-line-2 300 6)
  ; (koch-curve-line-2 300 7)
  )