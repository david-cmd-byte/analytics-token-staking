;; Title: Analytics Token Staking and Governance Contract

;; Summary: The Analytics Token Staking and Governance Contract enables users to stake STX tokens to earn ANALYTICS-TOKEN rewards,
;; participate in protocol governance, and access tiered benefits.
;; Key features include dynamic reward multipliers based on stake size/lock duration,
;; a governance system for proposals/voting, cooldown-protected unstaking, and administrative controls for safety.

;; Description: A Clarity smart contract for staking STX tokens, earning analytics tokens,
;; and participating in protocol governance through a tiered system with voting capabilities.

;; Token Definition
(define-fungible-token ANALYTICS-TOKEN u0)

;; Contract Owner & Error Codes
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u1000))
(define-constant ERR-INVALID-PROTOCOL (err u1001))
(define-constant ERR-INVALID-AMOUNT (err u1002))
(define-constant ERR-INSUFFICIENT-STX (err u1003))
(define-constant ERR-COOLDOWN-ACTIVE (err u1004))
(define-constant ERR-NO-STAKE (err u1005))
(define-constant ERR-BELOW-MINIMUM (err u1006))
(define-constant ERR-PAUSED (err u1007))

;; Contract State Variables
(define-data-var contract-paused bool false)
(define-data-var emergency-mode bool false)
(define-data-var stx-pool uint u0)

;; Staking Parameters
(define-data-var base-reward-rate uint u500)    ;; 5% base rate (100 = 1%)
(define-data-var bonus-rate uint u100)          ;; 1% bonus for longer staking
(define-data-var minimum-stake uint u1000000)   ;; Minimum stake amount
(define-data-var cooldown-period uint u1440)    ;; 24 hour cooldown in blocks
(define-data-var proposal-count uint u0)

;; Data Maps

;; Governance Proposals
(define-map Proposals
    { proposal-id: uint }
    {
        creator: principal,
        description: (string-utf8 256),
        start-block: uint,
        end-block: uint,
        executed: bool,
        votes-for: uint,
        votes-against: uint,
        minimum-votes: uint
    }
)

;; User Account Data
(define-map UserPositions
    principal
    {
        total-collateral: uint,
        total-debt: uint,
        health-factor: uint,
        last-updated: uint,
        stx-staked: uint,
        analytics-tokens: uint,
        voting-power: uint,
        tier-level: uint,
        rewards-multiplier: uint
    }
)