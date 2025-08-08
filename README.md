# CommunityTreasury - Decentralized Asset Management Protocol

[![Stacks](https://img.shields.io/badge/Stacks-Blockchain-purple)](https://www.stacks.co/)
[![Clarity](https://img.shields.io/badge/Clarity-Smart_Contract-blue)](https://clarity-lang.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-Vitest-yellow)](https://vitest.dev/)

A sophisticated decentralized treasury management system that empowers communities to collectively manage digital assets through democratic governance mechanisms, featuring time-locked deposits, weighted voting, and transparent proposal execution.

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Getting Started](#getting-started)
- [Usage](#usage)
- [API Reference](#api-reference)
- [Security](#security)
- [Development](#development)
- [Testing](#testing)
- [Deployment](#deployment)
- [Contributing](#contributing)
- [License](#license)

## 🌟 Overview

CommunityTreasury revolutionizes how decentralized organizations manage their funds by implementing a robust governance framework built on the Stacks blockchain. The protocol enables community members to stake assets, propose funding initiatives, participate in weighted voting based on their contribution, and execute approved proposals automatically.

### Key Benefits

- **Democratic Governance**: Weighted voting based on token holdings ensures fair representation
- **Security First**: Built-in time locks, minimum thresholds, and anti-manipulation safeguards
- **Transparency**: All proposals, votes, and executions are recorded on-chain
- **Trustless Operations**: Automated execution of approved proposals without intermediaries
- **Community-Driven**: Designed for DAOs, community funds, and collective investment groups

## ✨ Features

### Core Functionality

- **🏦 Asset Deposits**: Secure STX deposits with automatic governance token minting
- **⏰ Time-Locked Withdrawals**: Configurable lock periods to prevent manipulation
- **📝 Proposal System**: Comprehensive proposal creation with metadata and validation
- **🗳️ Weighted Voting**: Democratic voting system based on governance token holdings
- **🚀 Automatic Execution**: Trustless execution of approved funding proposals
- **📊 Transparent Governance**: Complete audit trail of all governance activities

### Security Features

- **Initialization Control**: Owner-only initialization for deployment security
- **Input Validation**: Comprehensive validation of all user inputs
- **Balance Verification**: Strict balance checks before any token operations
- **Proposal Expiration**: Time-bound proposals to prevent stale governance
- **Double-Voting Prevention**: Built-in protection against duplicate votes
- **Minimum Thresholds**: Configurable minimum deposits and proposal requirements

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Community     │    │   Governance     │    │   Treasury      │
│   Members       │◄──►│   System        │◄──►│   Management    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
        │                        │                        │
        ▼                        ▼                        ▼
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│ STX Deposits    │    │ Proposal Voting  │    │ Fund Execution  │
│ Token Minting   │    │ Weighted System  │    │ STX Transfers   │
│ Lock Periods    │    │ Time Validation  │    │ Balance Checks  │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

### Contract Structure

- **Constants**: Error codes and protocol parameters
- **Data Variables**: Global state management
- **Data Maps**: User balances, deposits, proposals, and votes
- **Private Functions**: Internal helpers and validators
- **Public Functions**: User-facing operations
- **Read-Only Functions**: Data queries and views

## 🚀 Getting Started

### Prerequisites

- [Clarinet](https://github.com/hirosystems/clarinet) - Stacks smart contract development toolkit
- [Node.js](https://nodejs.org/) (v16 or higher)
- [Git](https://git-scm.com/)

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/isaiah-akon/community-treasury.git
   cd community-treasury
   ```

2. **Install dependencies**:

   ```bash
   npm install
   ```

3. **Verify Clarinet installation**:

   ```bash
   clarinet --version
   ```

### Quick Start

1. **Check contract syntax**:

   ```bash
   clarinet check
   ```

2. **Run tests**:

   ```bash
   npm test
   ```

3. **Start local development environment**:

   ```bash
   clarinet console
   ```

## 📖 Usage

### Basic Workflow

1. **Initialize Contract**: Deploy and initialize the treasury
2. **Deposit Assets**: Community members deposit STX and receive governance tokens
3. **Create Proposals**: Submit funding proposals with detailed descriptions
4. **Vote on Proposals**: Cast weighted votes based on token holdings
5. **Execute Approved Proposals**: Automatically transfer approved funds

### Example Usage

```clarity
;; Initialize the treasury (owner only)
(contract-call? .community-treasury initialize)

;; Deposit 1000 STX and receive governance tokens
(contract-call? .community-treasury deposit u1000000000)

;; Create a funding proposal
(contract-call? .community-treasury create-proposal 
  "Fund community hackathon prizes" 
  u500000000 
  'SP1234...RECIPIENT 
  u1440)

;; Vote on proposal #1
(contract-call? .community-treasury vote u1 true)

;; Execute approved proposal
(contract-call? .community-treasury execute-proposal u1)
```

## 📚 API Reference

### Public Functions

#### Protocol Management

##### `initialize()`

Initializes the treasury contract. Can only be called once by the contract owner.

**Returns**: `(response bool uint)`

---

#### Asset Management

##### `deposit(amount: uint)`

Deposits STX tokens and mints corresponding governance tokens with time lock.

**Parameters**:

- `amount`: Amount in microSTX (minimum 1,000,000)

**Returns**: `(response bool uint)`

**Errors**:

- `err-below-minimum`: Amount below minimum deposit
- `err-zero-amount`: Cannot deposit zero amount

##### `withdraw(amount: uint)`

Withdraws STX tokens after lock period expires, burns governance tokens.

**Parameters**:

- `amount`: Amount of governance tokens to burn

**Returns**: `(response bool uint)`

**Errors**:

- `err-locked-period`: Lock period not yet expired
- `err-insufficient-balance`: Insufficient governance tokens

---

#### Governance System

##### `create-proposal(description: string-ascii, amount: uint, target: principal, duration: uint)`

Creates a new funding proposal with comprehensive validation.

**Parameters**:

- `description`: Proposal description (max 256 characters)
- `amount`: Requested funding amount in microSTX
- `target`: Recipient principal address
- `duration`: Proposal duration in blocks (144-20160)

**Returns**: `(response uint uint)` - Proposal ID

**Errors**:

- `err-invalid-description`: Empty or invalid description
- `err-invalid-target`: Invalid recipient address
- `err-invalid-duration`: Duration outside valid range

##### `vote(proposal-id: uint, vote-for: bool)`

Casts a weighted vote on a proposal based on governance token balance.

**Parameters**:

- `proposal-id`: ID of the proposal to vote on
- `vote-for`: true for yes, false for no

**Returns**: `(response bool uint)`

**Errors**:

- `err-already-voted`: User has already voted on this proposal
- `err-proposal-expired`: Proposal voting period has ended

##### `execute-proposal(proposal-id: uint)`

Executes an approved proposal by transferring funds to the target recipient.

**Parameters**:

- `proposal-id`: ID of the proposal to execute

**Returns**: `(response bool uint)`

**Errors**:

- `err-proposal-expired`: Proposal execution period requirements not met
- `err-insufficient-balance`: Treasury lacks sufficient funds

### Read-Only Functions

##### `get-balance(account: principal)`

Returns the governance token balance for a given account.

##### `get-total-supply()`

Returns the total supply of governance tokens in circulation.

##### `get-proposal(proposal-id: uint)`

Retrieves complete proposal data by ID.

##### `get-deposit-info(account: principal)`

Returns deposit information including lock status for an account.

##### `get-vote(proposal-id: uint, voter: principal)`

Checks if and how a specific voter voted on a proposal.

## 🔒 Security

### Security Measures

- **Access Control**: Owner-only initialization and administrative functions
- **Input Validation**: Comprehensive validation of all user inputs
- **Time Locks**: Configurable lock periods for deposits and proposals
- **Balance Verification**: Strict balance checks before operations
- **Anti-Manipulation**: Prevention of double voting and invalid proposals

### Security Considerations

- Always verify proposal details before voting
- Understand lock periods before depositing
- Verify contract initialization before use
- Monitor proposal execution for transparency

### Audit Status

This contract has been designed with security best practices. However, it has not undergone a formal security audit. Use at your own risk in production environments.

## 🛠️ Development

### Project Structure

```
community-treasury/
├── contracts/
│   └── community-treasury.clar     # Main contract
├── tests/
│   └── community-treasury.test.ts  # Test suites
├── settings/
│   ├── Devnet.toml                 # Development settings
│   ├── Testnet.toml                # Testnet settings
│   └── Mainnet.toml                # Mainnet settings
├── Clarinet.toml                   # Clarinet configuration
├── package.json                    # Node dependencies
└── README.md                       # This file
```

### Configuration

#### Protocol Parameters

```clarity
;; Configurable parameters in the contract
(define-constant minimum-duration u144)      ;; ~1 day
(define-constant maximum-duration u20160)    ;; ~14 days
(define-data-var minimum-deposit uint u1000000)  ;; 1 STX minimum
(define-data-var lock-period uint u1440)     ;; ~10 days lock
```

#### Environment Settings

Modify settings in `settings/` directory for different network configurations:

- `Devnet.toml`: Local development
- `Testnet.toml`: Testnet deployment
- `Mainnet.toml`: Production deployment

## 🧪 Testing

### Test Suite

The project uses Vitest with Clarinet SDK for comprehensive testing.

### Running Tests

```bash
# Run all tests
npm test

# Run tests with coverage report
npm run test:report

# Run tests in watch mode
npm run test:watch

# Run Clarinet checks
clarinet check
```

### Test Categories

- **Unit Tests**: Individual function testing
- **Integration Tests**: End-to-end workflow testing
- **Security Tests**: Attack vector validation
- **Edge Case Tests**: Boundary condition testing

### Writing Tests

Tests are located in `tests/community-treasury.test.ts`. Example test:

```typescript
import { describe, expect, it } from "vitest";

describe("CommunityTreasury", () => {
  it("should initialize successfully", () => {
    const { result } = simnet.callPublicFn(
      "community-treasury", 
      "initialize", 
      [], 
      deployerAddress
    );
    expect(result).toBeOk(true);
  });
});
```

## 🚀 Deployment

### Local Deployment

1. **Start local Clarinet console**:

   ```bash
   clarinet console
   ```

2. **Deploy contract**:

   ```clarity
   ::deploy_contract community-treasury
   ```

### Testnet Deployment

1. **Configure testnet settings** in `settings/Testnet.toml`

2. **Deploy to testnet**:

   ```bash
   clarinet deployments apply --deployment=testnet
   ```

### Mainnet Deployment

1. **Configure mainnet settings** in `settings/Mainnet.toml`

2. **Deploy to mainnet**:

   ```bash
   clarinet deployments apply --deployment=mainnet
   ```

### Post-Deployment

1. **Initialize the contract**:

   ```clarity
   (contract-call? .community-treasury initialize)
   ```

2. **Verify deployment**:

   ```clarity
   (contract-call? .community-treasury get-total-supply)
   ```

## 🤝 Contributing

We welcome contributions to the CommunityTreasury project! Please follow these guidelines:

### Development Process

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Contribution Guidelines

- Follow Clarity coding standards
- Add tests for new functionality
- Update documentation as needed
- Ensure all tests pass before submitting

### Code Review Process

All submissions require review before merging. We review:

- Code quality and standards
- Test coverage and quality
- Documentation completeness
- Security implications

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Stacks Foundation](https://stacks.org/) for the blockchain infrastructure
- [Hiro Systems](https://www.hiro.so/) for development tools
- The Clarity community for best practices and support
