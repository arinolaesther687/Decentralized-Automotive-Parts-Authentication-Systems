# Decentralized Automotive Parts Authentication System

A comprehensive blockchain-based system for authenticating automotive parts, preventing counterfeiting, and ensuring quality standards throughout the supply chain.

## Overview

This system consists of five interconnected Clarity smart contracts that work together to provide end-to-end authentication and tracking of automotive parts:

1. **Manufacturer Verification** - Validates and manages automotive parts manufacturers
2. **Component Tracking** - Tracks automotive components throughout their lifecycle
3. **Authenticity Verification** - Verifies the authenticity of automotive parts
4. **Quality Assurance** - Ensures parts meet quality standards
5. **Counterfeit Prevention** - Detects and prevents counterfeit parts

## Features

### 🏭 Manufacturer Verification
- Register new manufacturers with license verification
- Verify manufacturer credentials
- Track manufacturer reputation and history
- Authorize trusted manufacturers

### 📦 Component Tracking
- Create unique component records with serial numbers
- Track component lifecycle from manufacturing to installation
- Maintain detailed history logs for each component
- Update component status and ownership

### ✅ Authenticity Verification
- Verify component authenticity using digital signatures
- Authorize trusted verifiers
- Confidence scoring system for verification results
- Immutable authenticity records

### 🔍 Quality Assurance
- Define custom quality standards
- Assess components against quality criteria
- Track quality scores and compliance
- Generate quality summary reports

### 🚫 Counterfeit Prevention
- Report suspected counterfeit components
- Blacklist confirmed counterfeit parts
- Trusted reporter system with reputation scoring
- Evidence-based reporting with hash verification

## Smart Contract Architecture

\`\`\`
┌─────────────────────┐    ┌─────────────────────┐
│ Manufacturer        │    │ Component           │
│ Verification        │◄──►│ Tracking            │
└─────────────────────┘    └─────────────────────┘
│                          │
▼                          ▼
┌─────────────────────┐    ┌─────────────────────┐
│ Authenticity        │    │ Quality             │
│ Verification        │    │ Assurance           │
└─────────────────────┘    └─────────────────────┘
│                          │
└──────────┬─────────────────┘
▼
┌─────────────────────┐
│ Counterfeit         │
│ Prevention          │
└─────────────────────┘
\`\`\`

## Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd automotive-parts-auth
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts to Stacks blockchain:

\`\`\`bash
# Deploy manufacturer verification contract
clarinet deploy contracts/manufacturer-verification.clar

# Deploy component tracking contract
clarinet deploy contracts/component-tracking.clar

# Deploy authenticity verification contract
clarinet deploy contracts/authenticity-verification.clar

# Deploy quality assurance contract
clarinet deploy contracts/quality-assurance.clar

# Deploy counterfeit prevention contract
clarinet deploy contracts/counterfeit-prevention.clar
\`\`\`

## Usage Examples

### Register a Manufacturer
\`\`\`clarity
(contract-call? .manufacturer-verification register-manufacturer
"ACME Auto Parts"
"LICENSE-12345")
\`\`\`

### Create a Component
\`\`\`clarity
(contract-call? .component-tracking create-component
"COMP-001"
u1
"BRAKE-PAD-X1"
"SN123456789"
"brake-pad")
\`\`\`

### Verify Authenticity
\`\`\`clarity
(contract-call? .authenticity-verification verify-authenticity
"COMP-001"
true
"digital-signature"
u95
"signature-hash-here")
\`\`\`

### Assess Quality
\`\`\`clarity
(contract-call? .quality-assurance assess-component-quality
"COMP-001"
u1
u85
"Passed all safety tests")
\`\`\`

### Report Counterfeit
\`\`\`clarity
(contract-call? .counterfeit-prevention report-counterfeit
"COMP-002"
"evidence-hash-123"
u4
"Suspected counterfeit based on quality issues")
\`\`\`

## API Reference

### Manufacturer Verification Contract

#### Public Functions
- \`register-manufacturer(name, license-number)\` - Register new manufacturer
- \`verify-manufacturer(manufacturer-id)\` - Verify manufacturer (owner only)

#### Read-Only Functions
- \`get-manufacturer(manufacturer-id)\` - Get manufacturer details
- \`is-manufacturer-verified(manufacturer)\` - Check verification status
- \`get-manufacturer-id(manufacturer)\` - Get manufacturer ID by principal

### Component Tracking Contract

#### Public Functions
- \`create-component(component-id, manufacturer-id, part-number, serial-number, component-type)\`
- \`add-component-history(component-id, action, location, notes)\`
- \`update-component-status(component-id, new-status)\`

#### Read-Only Functions
- \`get-component(component-id)\` - Get component details
- \`get-component-history(component-id, sequence)\` - Get history entry
- \`get-component-sequence(component-id)\` - Get next sequence number

### Authenticity Verification Contract

#### Public Functions
- \`authorize-verifier(verifier)\` - Authorize verifier (owner only)
- \`verify-authenticity(component-id, is-authentic, method, confidence, signature)\`

#### Read-Only Functions
- \`get-authenticity-record(component-id)\` - Get authenticity record
- \`is-component-authentic(component-id)\` - Check if authentic
- \`is-authorized-verifier(verifier)\` - Check verifier authorization

### Quality Assurance Contract

#### Public Functions
- \`create-quality-standard(name, description, min-score, max-score)\`
- \`assess-component-quality(component-id, standard-id, score, notes)\`

#### Read-Only Functions
- \`get-quality-standard(standard-id)\` - Get quality standard
- \`get-quality-assessment(component-id, standard-id)\` - Get assessment
- \`get-component-quality-summary(component-id)\` - Get quality summary

### Counterfeit Prevention Contract

#### Public Functions
- \`add-trusted-reporter(reporter, trust-score)\` - Add trusted reporter (owner only)
- \`report-counterfeit(component-id, evidence-hash, severity, description)\`
- \`blacklist-component(component-id, reason)\` - Blacklist component (owner only)
- \`update-report-status(report-id, new-status)\` - Update report status (owner only)

#### Read-Only Functions
- \`is-component-blacklisted(component-id)\` - Check blacklist status
- \`get-counterfeit-report(report-id)\` - Get report details
- \`get-blacklist-info(component-id)\` - Get blacklist information
- \`is-trusted-reporter(reporter)\` - Check reporter trust status

## Security Considerations

- All contracts implement proper access controls
- Critical functions are restricted to authorized users
- Input validation prevents malicious data
- Immutable records ensure data integrity
- Multi-signature verification for high-value operations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions and support, please open an issue in the GitHub repository.
