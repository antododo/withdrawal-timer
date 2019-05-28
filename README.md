# withdrawal-timer

## 1. The owner deploys the contract with a certain amount of ETH

## 2. The allowed address (or the owner) requests a withdraw
The requester choose the amount to withdraw and need to pay 0.1ETH are to prevent spam request.

## 3. Once the timer for this request his over
The allowed address (or the owner) can withdraw the amount knowing the request id.

## At any time, the owner can:
- cancel a withdraw request.
- change the timer (will be effective only for new requests).
- change the allowed address.