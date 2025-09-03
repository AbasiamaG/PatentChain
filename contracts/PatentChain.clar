;; PatentChain: Patent Filing and Prior Art Documentation System
;; Version: 1.0.0

(define-constant ERR-NOT-AUTHORIZED (err u1))
(define-constant ERR-PATENT-NOT-FOUND (err u2))
(define-constant ERR-ALREADY-FILED (err u3))
(define-constant ERR-INVALID-STATUS (err u4))
(define-constant ERR-INVALID-CLAIM-COUNT (err u5))
(define-constant ERR-INVALID-PATENT-CATEGORY (err u6))
(define-constant ERR-INVALID-FILING-TYPE (err u7))
(define-constant ERR-INVALID-PATENT-TITLE (err u8))
(define-constant ERR-INVALID-DESCRIPTION (err u9))

(define-constant MIN-CLAIM-COUNT u1)

(define-data-var next-patent-id uint u1)

(define-map patent-registry
    uint
    {
        inventor: principal,
        patent-title: (string-utf8 50),
        description: (string-utf8 200),
        patent-category: (string-utf8 15),
        filing-type: (string-utf8 10),
        filing-status: (string-utf8 15),
        claim-count: uint
    })

(define-private (validate-patent-category (patent-category (string-utf8 15)))
    (or 
        (is-eq patent-category u"Mechanical")
        (is-eq patent-category u"Electrical")
        (is-eq patent-category u"Chemical")
        (is-eq patent-category u"Software")
        (is-eq patent-category u"Biotechnology")
        (is-eq patent-category u"Medical")
    ))

(define-private (validate-filing-type (filing-type (string-utf8 10)))
    (or 
        (is-eq filing-type u"Utility")
        (is-eq filing-type u"Design")
        (is-eq filing-type u"Plant")
        (is-eq filing-type u"Provisional")
        (is-eq filing-type u"Reissue")
    ))

(define-private (validate-text-input (text (string-utf8 200)) (min-length uint) (max-length uint))
    (let 
        (
            (text-length (len text))
        )
        (and 
            (>= text-length min-length)
            (<= text-length max-length)
        )
    ))

(define-public (file-patent 
    (patent-title (string-utf8 50))
    (description (string-utf8 200))
    (patent-category (string-utf8 15))
    (filing-type (string-utf8 10))
    (claim-count uint))
    (let
        (
            (patent-id (var-get next-patent-id))
        )
        (asserts! (validate-text-input patent-title u3 u50) ERR-INVALID-PATENT-TITLE)
        (asserts! (validate-text-input description u10 u200) ERR-INVALID-DESCRIPTION)
        (asserts! (>= claim-count MIN-CLAIM-COUNT) ERR-INVALID-CLAIM-COUNT)
        (asserts! (validate-patent-category patent-category) ERR-INVALID-PATENT-CATEGORY)
        (asserts! (validate-filing-type filing-type) ERR-INVALID-FILING-TYPE)
        
        (map-set patent-registry patent-id {
            inventor: tx-sender,
            patent-title: patent-title,
            description: description,
            patent-category: patent-category,
            filing-type: filing-type,
            filing-status: u"pending",
            claim-count: claim-count
        })
        (var-set next-patent-id (+ patent-id u1))
        (ok patent-id)
    ))

(define-public (approve-patent (patent-id uint))
    (let
        (
            (patent (unwrap! (map-get? patent-registry patent-id) ERR-PATENT-NOT-FOUND))
        )
        (asserts! (is-eq tx-sender (get inventor patent)) ERR-NOT-AUTHORIZED)
        (asserts! (is-eq (get filing-status patent) u"pending") ERR-INVALID-STATUS)
        (ok (map-set patent-registry patent-id (merge patent { filing-status: u"approved" })))
    ))

(define-read-only (get-patent (patent-id uint))
    (ok (map-get? patent-registry patent-id)))

(define-read-only (get-inventor (patent-id uint))
    (ok (get inventor (unwrap! (map-get? patent-registry patent-id) ERR-PATENT-NOT-FOUND))))

(define-read-only (get-total-patents)
    (ok (- (var-get next-patent-id) u1)))

(define-read-only (get-patent-status (patent-id uint))
    (ok (get filing-status (unwrap! (map-get? patent-registry patent-id) ERR-PATENT-NOT-FOUND))))