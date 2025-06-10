;; Authenticity Verification Contract
;; Verifies the authenticity of automotive parts

(define-map authenticity-records
  { component-id: (string-ascii 50) }
  {
    is-authentic: bool,
    verification-date: uint,
    verifier: principal,
    verification-method: (string-ascii 50),
    confidence-score: uint,
    digital-signature: (string-ascii 100)
  }
)

(define-map authorized-verifiers
  { verifier: principal }
  { authorized: bool, authorization-date: uint }
)

(define-data-var contract-owner principal tx-sender)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED (err u300))
(define-constant ERR-COMPONENT-NOT-FOUND (err u301))
(define-constant ERR-ALREADY-VERIFIED (err u302))
(define-constant ERR-INVALID-CONFIDENCE (err u303))

;; Authorize a verifier
(define-public (authorize-verifier (verifier principal))
  (begin
    (asserts! (is-eq tx-sender (var-get contract-owner)) ERR-NOT-AUTHORIZED)
    (map-set authorized-verifiers
      { verifier: verifier }
      { authorized: true, authorization-date: block-height }
    )
    (ok true)
  )
)

;; Verify component authenticity
(define-public (verify-authenticity
  (component-id (string-ascii 50))
  (is-authentic bool)
  (verification-method (string-ascii 50))
  (confidence-score uint)
  (digital-signature (string-ascii 100))
)
  (let ((verifier-data (unwrap! (map-get? authorized-verifiers { verifier: tx-sender }) ERR-NOT-AUTHORIZED)))
    (asserts! (get authorized verifier-data) ERR-NOT-AUTHORIZED)
    (asserts! (is-none (map-get? authenticity-records { component-id: component-id })) ERR-ALREADY-VERIFIED)
    (asserts! (and (>= confidence-score u0) (<= confidence-score u100)) ERR-INVALID-CONFIDENCE)
    (map-set authenticity-records
      { component-id: component-id }
      {
        is-authentic: is-authentic,
        verification-date: block-height,
        verifier: tx-sender,
        verification-method: verification-method,
        confidence-score: confidence-score,
        digital-signature: digital-signature
      }
    )
    (ok true)
  )
)

;; Get authenticity record
(define-read-only (get-authenticity-record (component-id (string-ascii 50)))
  (map-get? authenticity-records { component-id: component-id })
)

;; Check if component is authentic
(define-read-only (is-component-authentic (component-id (string-ascii 50)))
  (match (map-get? authenticity-records { component-id: component-id })
    record (get is-authentic record)
    false
  )
)

;; Check if verifier is authorized
(define-read-only (is-authorized-verifier (verifier principal))
  (match (map-get? authorized-verifiers { verifier: verifier })
    verifier-data (get authorized verifier-data)
    false
  )
)
