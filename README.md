# PatentChain

A decentralized patent filing and prior art documentation system for managing intellectual property on Stacks blockchain.

## Features

- Patent application filing with comprehensive metadata
- Inventor claim management and validation
- Patent category classification system
- Filing type specification and tracking
- Patent status management and approval workflow

## Smart Contract Functions

### Public Functions
- `file-patent` - File new patent application with claims
- `approve-patent` - Approve patent filing (inventor only)

### Read-Only Functions
- `get-patent` - Get patent application details
- `get-inventor` - Get patent inventor information
- `get-total-patents` - Get total filed patents
- `get-patent-status` - Get patent filing status

## Patent Categories
- Mechanical, Electrical, Chemical, Software, Biotechnology, Medical

## Filing Types
- Utility, Design, Plant, Provisional, Reissue

## Usage

Deploy the contract to create a patent filing system where inventors can file applications and track their intellectual property throughout the approval process.

## License

MIT