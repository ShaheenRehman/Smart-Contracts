// SPDX-License-Identifier: MIT
pragma solidity 0.8.5;

import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";

error Lottery__NotEnoughtETH();
error Lottery__WinnerTransactionFailed();
error Lottery__LotteryStateIsNotOpen();
error Lottery__UpKeepNotNeeded(
    uint accountBalance,
    uint noOfPlayers,
    uint lotteryState
);

contract Lottery is VRFConsumerBaseV2, KeeperCompatibleInterface {
    enum LotteryState {
        OPEN,
        CALCULATING
    }

    uint private immutable i_entranceFee;
    address payable[] private players;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_keyHash;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    uint16 private constant REQUEST_CONFIRMATIONS = 2;
    uint32 private constant NUM_WORDS = 1;

    address private lotteryWinner;
    LotteryState private lotteryState;
    uint256 private lastBlockTimeStamp;
    uint256 private immutable i_interval;

    event LotteryEnter(address indexed player);
    event RequestLotteryWinner(uint indexed requestId);
    event WinnerLottery(address indexed winner);

    constructor(
        bytes32 keyHash,
        address vrfCoordinatorV2,
        uint _entranceFee,
        uint64 subscriptionId,
        uint32 callbackGasLimit,
        uint256 interval
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_entranceFee = _entranceFee;
        i_keyHash = keyHash;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        lotteryState = LotteryState.OPEN;
        lastBlockTimeStamp = block.timestamp;
        i_interval = interval;
    }

    function enterLottery() public payable {
        if (msg.value <= i_entranceFee) {
            revert Lottery__NotEnoughtETH();
        }
        if (lotteryState != LotteryState.OPEN) {
            revert Lottery__LotteryStateIsNotOpen();
        }
        players.push(payable(msg.sender));
        emit LotteryEnter(msg.sender);
    }

    function checkUpkeep(
        bytes memory /* checkData */
    )
        public
        view
        override
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        bool isOpen = (LotteryState.OPEN == lotteryState);
        bool timePassed = ((block.timestamp - lastBlockTimeStamp) > i_interval);
        bool noOfPlayers = players.length > 0;
        bool lotteryBalance = address(this).balance > 0;
        upkeepNeeded = (isOpen && timePassed && noOfPlayers && lotteryBalance);
    }

    function performUpkeep(
        bytes calldata /* performData */
    ) external override {
        (bool upkeepNeeded, ) = checkUpkeep("");
        if (!upkeepNeeded) {
            revert Lottery__UpKeepNotNeeded(
                address(this).balance,
                players.length,
                uint(lotteryState)
            );
        }

        lotteryState = LotteryState.CALCULATING;
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_keyHash, //0xd89b2bf150e3b9e13446986e571fb9cab24b13cea0a43ea20a6049a85cc807cc
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        emit RequestLotteryWinner(requestId);
    }

    function fulfillRandomWords(
        uint256, /*requestId*/
        uint256[] memory randomWords
    ) internal override {
        uint index = randomWords[0] % players.length;
        address payable winner = players[index];
        players = new address payable[](0);
        lastBlockTimeStamp = block.timestamp;
        lotteryWinner = winner;
        lotteryState = LotteryState.OPEN;
        (bool success, ) = winner.call{value: address(this).balance}("");
        // require(success, "lotteryWinner Failed");
        if (!success) {
            revert Lottery__WinnerTransactionFailed();
        }
        emit WinnerLottery(winner);
    }

    function getEntranceFee() public view returns (uint) {
        return i_entranceFee;
    }

    function getPlayers(uint index) public view returns (address) {
        return players[index];
    }

    function getLotteryWinner() public view returns (address) {
        return lotteryWinner;
    }

    function getLotteryState() public view returns (LotteryState) {
        return lotteryState;
    }

    function getNumWords() public pure returns (uint256) {
        return NUM_WORDS;
    }

    function getLastTimeStamp() public view returns (uint256) {
        return lastBlockTimeStamp;
    }

    function getInterval() public view returns (uint256) {
        return i_interval;
    }

    function getNumberOfPlayers() public view returns (uint256) {
        return players.length;
    }

    function getRequestConfirmations() public pure returns (uint256) {
        return REQUEST_CONFIRMATIONS;
    }
}
