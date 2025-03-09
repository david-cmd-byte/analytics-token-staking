# Analytics Token Staking & Governance Contract

**Version**: 1.0.0

### **Overview**

This Clarity smart contract enables users to stake STX tokens to earn **ANALYTICS-TOKEN** rewards and participate in protocol governance. The system features a tiered staking mechanism with dynamic rewards, voting power scaling, and administrative safeguards. Designed for decentralized analytics platforms, it incentivizes long-term participation while ensuring community-driven protocol updates.

### **Key Features**

1. **Tiered Staking System**

   - **Tiers**: 3 levels (Bronze, Silver, Gold) based on STX staked.
   - **Reward Multipliers**:
     - Bronze (1M+ STX): 1x base rewards
     - Silver (5M+ STX): 1.5x rewards + governance features
     - Gold (10M+ STX): 2x rewards + full governance rights

2. **Lock-Up Bonuses**

   - Optional lock periods (0, 30, 60 days) boost rewards by 1.25x–1.5x.

3. **Governance Engine**

   - Create/veto proposals with voting power proportional to staked STX.
   - Minimum 1M STX staked to propose governance actions.

4. **Security Protections**
   - 24-hour cooldown for unstaking.
   - Emergency pause/resume functions.
   - Penalty-free withdrawals post-cooldown.

### **Technical Specifications**

#### **Constants**

- `CONTRACT-OWNER`: Admin address with pause/resume privileges.
- `minimum-stake`: 1,000,000 STX (1 STX = 1e6 units).
- `cooldown-period`: 1,440 blocks (~24 hours).

#### **Reward Formula**

```
Rewards = (staked_amount × base_rate × multiplier × elapsed_blocks) / 14,400,000
```

- **Base Rate**: 5% APY (adjustable via governance).
- **Multiplier**: Tier + lock-period bonuses.

#### **Data Structures**

- `UserPositions`: Tiers, STX staked, voting power, rewards.
- `StakingPositions`: Lock periods, cooldown timers, accrued rewards.
- `Proposals`: Voting deadlines, vote counts, execution status.

### **Core Functions**

#### **Staking**

1. **`stake-stx`**: Lock STX to earn rewards.

   - Inputs: `amount` (STX), `lock-period` (0/4,320/8,640 blocks).
   - Requirements: Minimum 1M STX, valid lock period.

2. **`initiate-unstake`**: Start 24-hour cooldown.
3. **`complete-unstake`**: Withdraw STX post-cooldown.

#### **Governance**

1. **`create-proposal`**: Submit governance action (e.g., reward rate changes).

   - Requires ≥1M STX staked.
   - Inputs: `description` (256 chars), `voting-period` (100–2,880 blocks).

2. **`vote-on-proposal`**: Cast votes using staking-derived voting power.

#### **Administration**

- **`pause-contract`/**`resume-contract`\*\*: Freeze/all operations (owner-only).

### **Governance Process**

1. **Proposal Creation**

   - Submit description + voting window.
   - Minimum 1M STX staked required.

2. **Voting Phase**

   - Votes weighted by `voting-power` (1 STX = 1 vote).
   - Proposals pass if:
     - `votes-for > votes-against`
     - Total votes ≥ `minimum-votes` (1M).

3. **Execution**
   - Successful proposals executable after `end-block`.

### **Security & Error Handling**

#### **Error Codes**

- `ERR-NOT-AUTHORIZED` (1000): Unauthorized action.
- `ERR-INSUFFICIENT-STX` (1003): Insufficient staked balance.
- `ERR-COOLDOWN-ACTIVE` (1004): Premature withdrawal attempt.

#### **Emergency Protocols**

- **Pause Mode**: Halts all staking/unstaking during threats.
- **Audited Withdrawals**: STX refunds guaranteed post-cooldown.

### **Integration Guide**

#### **Dependencies**

- Clarinet (local testing).
- Hiro Explorer (mainnet deployment).

#### **Sample Interactions**

**Stake STX (30-Day Lock):**

```clarity
(contract-call? .analytics-staking-contract stake-stx u5000000 u4320)
```

**Create Proposal:**

```clarity
(contract-call? .analytics-staking-contract create-proposal "Increase base reward rate to 6%" u1000)
```
