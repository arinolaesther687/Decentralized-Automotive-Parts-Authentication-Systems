;; Component Tracking Contract
;; Tracks automotive components throughout their lifecycle

(define-map components
  { component-id: (string-ascii 50) }
  {
    manufacturer-id: uint,
    part-number: (string-ascii 50),
    serial-number: (string-ascii 50),
    manufacture-date: uint,
    component-type: (string-ascii 30),
    status: (string-ascii 20),
    current-owner: principal,
    created-by: principal
  }
)

(define-map component-history
  { component-id: (string-ascii 50), sequence: uint }
  {
    action: (string-ascii 30),
    timestamp: uint,
    actor: principal,
    location: (string-ascii 100),
    notes: (string-ascii 200)
  }
)

(define-map component-sequence
  { component-id: (string-ascii 50) }
  { next-sequence: uint }
)

;; Error codes
(define-constant ERR-COMPONENT-EXISTS (err u200))
(define-constant ERR-COMPONENT-NOT-FOUND (err u201))
(define-constant ERR-NOT-AUTHORIZED (err u202))
(define-constant ERR-INVALID-STATUS (err u203))

;; Create a new component
(define-public (create-component
  (component-id (string-ascii 50))
  (manufacturer-id uint)
  (part-number (string-ascii 50))
  (serial-number (string-ascii 50))
  (component-type (string-ascii 30))
)
  (begin
    (asserts! (is-none (map-get? components { component-id: component-id })) ERR-COMPONENT-EXISTS)
    (map-set components
      { component-id: component-id }
      {
        manufacturer-id: manufacturer-id,
        part-number: part-number,
        serial-number: serial-number,
        manufacture-date: block-height,
        component-type: component-type,
        status: "manufactured",
        current-owner: tx-sender,
        created-by: tx-sender
      }
    )
    (map-set component-sequence
      { component-id: component-id }
      { next-sequence: u1 }
    )
    (unwrap-panic (add-component-history component-id "manufactured" "Factory" "Component created"))
    (ok true)
  )
)

;; Add history entry for component
(define-public (add-component-history
  (component-id (string-ascii 50))
  (action (string-ascii 30))
  (location (string-ascii 100))
  (notes (string-ascii 200))
)
  (let (
    (component (unwrap! (map-get? components { component-id: component-id }) ERR-COMPONENT-NOT-FOUND))
    (sequence-data (unwrap! (map-get? component-sequence { component-id: component-id }) ERR-COMPONENT-NOT-FOUND))
    (current-sequence (get next-sequence sequence-data))
  )
    (map-set component-history
      { component-id: component-id, sequence: current-sequence }
      {
        action: action,
        timestamp: block-height,
        actor: tx-sender,
        location: location,
        notes: notes
      }
    )
    (map-set component-sequence
      { component-id: component-id }
      { next-sequence: (+ current-sequence u1) }
    )
    (ok current-sequence)
  )
)

;; Update component status
(define-public (update-component-status (component-id (string-ascii 50)) (new-status (string-ascii 20)))
  (let ((component (unwrap! (map-get? components { component-id: component-id }) ERR-COMPONENT-NOT-FOUND)))
    (map-set components
      { component-id: component-id }
      (merge component { status: new-status, current-owner: tx-sender })
    )
    (unwrap-panic (add-component-history component-id new-status "Updated" "Status changed"))
    (ok true)
  )
)

;; Get component info
(define-read-only (get-component (component-id (string-ascii 50)))
  (map-get? components { component-id: component-id })
)

;; Get component history entry
(define-read-only (get-component-history (component-id (string-ascii 50)) (sequence uint))
  (map-get? component-history { component-id: component-id, sequence: sequence })
)

;; Get next sequence number for component
(define-read-only (get-component-sequence (component-id (string-ascii 50)))
  (map-get? component-sequence { component-id: component-id })
)
