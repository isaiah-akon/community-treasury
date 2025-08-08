;; Title: CommunityTreasury - Decentralized Asset Management Protocol

;; Summary:
;; A sophisticated decentralized treasury management system that empowers communities
;; to collectively manage digital assets through democratic governance mechanisms,
;; featuring time-locked deposits, weighted voting, and transparent proposal execution.

;; Description:
;; CommunityTreasury revolutionizes how decentralized organizations manage their funds
;; by implementing a robust governance framework built on the Stacks blockchain.
;; The protocol enables community members to stake assets, propose funding initiatives,
;; participate in weighted voting based on their contribution, and execute approved
;; proposals automatically. With built-in security measures including time locks,
;; minimum thresholds, and anti-manipulation safeguards, it provides a trustless
;; environment for collaborative financial decision-making at scale.

;; CONSTANTS & ERROR DEFINITIONS

(define-constant contract-owner tx-sender)

;; Error Constants
(define-constant err-owner-only (err u100))
(define-constant err-not-initialized (err u101))
(define-constant err-already-initialized (err u102))
(define-constant err-insufficient-balance (err u103))
(define-constant err-invalid-amount (err u104))
(define-constant err-unauthorized (err u105))
(define-constant err-proposal-not-found (err u106))
(define-constant err-proposal-expired (err u107))
(define-constant err-already-voted (err u108))
(define-constant err-below-minimum (err u109))
(define-constant err-locked-period (err u110))
(define-constant err-transfer-failed (err u111))
(define-constant err-invalid-duration (err u112))
(define-constant err-zero-amount (err u113))
(define-constant err-invalid-target (err u114))
(define-constant err-invalid-description (err u115))
(define-constant err-invalid-proposal-id (err u116))
(define-constant err-invalid-vote (err u117))

;; Protocol Parameters
(define-constant minimum-duration u144) ;; Minimum proposal duration: 1 day (assuming 10min blocks)
(define-constant maximum-duration u20160) ;; Maximum proposal duration: 14 days

;; DATA VARIABLES

(define-data-var total-supply uint u0)
(define-data-var minimum-deposit uint u1000000) ;; Minimum deposit in microSTX
(define-data-var lock-period uint u1440) ;; Lock period: ~10 days in blocks
(define-data-var initialized bool false)
(define-data-var last-rebalance uint u0)
(define-data-var proposal-count uint u0)

;; DATA MAPS

;; User token balances (governance weight)
(define-map balances
  principal
  uint
)

;; Deposit tracking with time locks and reward calculations
(define-map deposits
  principal
  {
    amount: uint,
    lock-until: uint,
    last-reward-block: uint,
  }
)

;; Proposal registry with complete metadata
(define-map proposals
  uint
  {
    proposer: principal,
    description: (string-ascii 256),
    amount: uint,
    target: principal,
    expires-at: uint,
    executed: bool,
    yes-votes: uint,
    no-votes: uint,
  }
)

;; Vote tracking to prevent double voting
(define-map votes
  {
    proposal-id: uint,
    voter: principal,
  }
  bool
)

;; PRIVATE HELPER FUNCTIONS

(define-private (is-contract-owner)
  ;; Validates if the transaction sender is the contract owner
  (is-eq tx-sender contract-owner)
)