# withdrawal-timer

This smart contract is a safe where you can put your ETH, and if something happens to you, someone you allowed (allowedAddress) will be able to withdraw the ETH after a certain amount of time.

## 1. The owner deploys the contract with a certain amount of ETH

## 2. The allowed address (or the owner) requests a withdraw
The requester choose the amount to withdraw and need to pay 0.1ETH to prevent spam request.

## 3. Once the timer for this request his over
The allowed address (or the owner) can withdraw the amount knowing the request id.

## At any time, the owner can:
- cancel a withdraw request.
- change the timer (will be effective only for new requests).
- change the allowed address.

## Feedbacks received

- [X] You should always work with ETH in units of Wei(the conversion from Eth to Wei can be made from the front-end)
- [X] I see a few way to reduce gas too (like uint -> uint8 or uint64)
- [X] public functions could be external too
- [ ] There is an argument for allowing the existing allowed address to change the allowed address
- [ ] There's also an argument that the owner should be able to withdraw immediately
- [X] the allowed address could be an argument inside the constructor instead of being hardcoded
- [ ] You could use the Ownable lib from Open Zeppelin instead of having your own stuff
