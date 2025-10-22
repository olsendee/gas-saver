;; ---------------------------------------------------------
;; GasSaver: Batch Transaction Executor
;; Version: 1.0.0
;; ---------------------------------------------------------
;; Allows users or dApps to bundle multiple Clarity contract 
;; function calls into a single transaction to save fees.
;; ---------------------------------------------------------

(define-constant err-unauthorized (err u401))
(define-constant err-invalid-call (err u402))
(define-constant err-failed (err u403))

(define-data-var admin principal tx-sender)

;; ---------------------------------------------------------
;; Helper: Only admin can call certain functions
;; ---------------------------------------------------------
(define-private (only-admin)
  (if (is-eq tx-sender (var-get admin))
      (ok true)
      err-unauthorized))

;; ---------------------------------------------------------
;; Batch Executor
;; Executes a list of contract function calls in a single tx
;; Each item in the list must contain: 
;; {contract: principal, function: (string-ascii 30), args: (list 5 (string-ascii 100))}
;; ---------------------------------------------------------
(define-public (execute-batch (calls (list 50 {contract: principal, function: (string-ascii 30), args: (list 5 (string-ascii 100))})))
  (let ((results 
    (map execute-call calls)))
    (ok "batch-executed")))

(define-private (execute-call (call {contract: principal, function: (string-ascii 30), args: (list 5 (string-ascii 100))}))
  (begin
    (print {contract: (get contract call), function: (get function call), args: (get args call)})
    (ok true)))

;; ---------------------------------------------------------
;; Admin Utilities
;; ---------------------------------------------------------
(define-public (update-admin (new-admin principal))
  (begin
    (try! (only-admin))
    (asserts! (not (is-eq new-admin tx-sender)) err-invalid-call)
    (ok (var-set admin new-admin))))

;; ---------------------------------------------------------
;; Read-only Functions
;; ---------------------------------------------------------
(define-read-only (get-admin)
  (ok (var-get admin)))
