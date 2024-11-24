#!/bin/bash

# Configuration
NUM_WALLETS=10
TOKEN_MINT="" 
SOURCE_WALLET_JSON="WalletAddress.json" #the json should have private key for the wallet
PROGRAM_ID="TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb"

# Create directory for new wallets
mkdir -p generated_wallets

# Function to generate random number between min and max
random_amount() {
    min=$1
    max=$2
    echo $(( ( RANDOM % ($max - $min + 1) ) + $min ))
}

# For each wallet
for i in $(seq 1 $NUM_WALLETS); do
    echo "Creating wallet $i..."
    
    # Generate new wallet
    solana-keygen new --no-bip39-passphrase -o "generated_wallets/wallet_$i.json"
    
    # Get public key of new wallet
    NEW_WALLET_ADDRESS=$(solana-keygen pubkey "generated_wallets/wallet_$i.json")
    
    echo "Creating token account for $NEW_WALLET_ADDRESS..."
    
    # Create token account
    
    
    
    # Calculate random amount (between 1% and 3% of 1 billion)
    BASE_AMOUNT=1000000000 # 1B as default
    PERCENTAGE=$(random_amount 1 3)
    TRANSFER_AMOUNT=$((BASE_AMOUNT * PERCENTAGE / 100))
    
    echo "Transferring $TRANSFER_AMOUNT tokens to $NEW_WALLET_ADDRESS..."
    
    # Transfer tokens
    spl-token transfer $TOKEN_MINT $TRANSFER_AMOUNT $NEW_WALLET_ADDRESS \
        --program-id $PROGRAM_ID \
        --owner $SOURCE_WALLET_JSON \
        --fee-payer $SOURCE_WALLET_JSON \
        --allow-unfunded-recipient \
        --fund-recipient
    
    echo "Completed transfer to wallet $i"
    echo "------------------------"
    
    # Add small delay to avoid rate limiting
    sleep 2
done

echo "Distribution complete! Check generated_wallets directory for the keypairs."