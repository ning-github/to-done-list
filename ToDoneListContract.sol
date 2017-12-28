pragma solidity ^0.4.16;

contract ToDoneList {
	address taskedUser;
	event LogUpdate(string updateText, uint amount);

	struct Task {
		string name;
		string descrption;
		bool completed;
	}

	mapping(uint => Task) public tasks;
	int tasksRemaining;
	int tasksCompleted;
	bool allDone;

	// may need to impose a limit
	uint nextTaskId;

	function ToDoneList() {
		taskedUser = msg.sender;
		allDone = true;
	}

	modifier ifDone() {
		if (!allDone) {
			throw;
		}
		_;
	}

	// Money
	function depositFunds() payable {
		LogUpdate("Deposited funds: ", msg.value);
	}

	function checkPot() constant returns(uint) {
		LogUpdate("Current balance is: ", this.balance);
		return this.balance;
	}

	function redeemReward() ifDone {
		LogUpdate("Redeeming reward: ", this.balance);
		taskedUser.transfer(this.balance);
	}

	// Tasks
	function newTask(string name, string description) returns(uint) {
		uint taskId = nextTaskId++;
		tasksRemaining++;
		tasks[taskId] = Task(name, description, false);
		if (allDone) {
		    allDone = false;
		}
		return taskId;
	}

	function completeTask(uint taskId) returns(string) {
		if (tasks[taskId].completed == true) {
			return "Already completed";
		}
		tasks[taskId].completed = true;
		tasksCompleted++;
		tasksRemaining--;
		if (tasksRemaining <= 0) {
			allDone = true;
			return "All tasks completed!";
		}
		// return name of completed task as confirmation
		return tasks[taskId].name;
	}

	function clearList() returns(bool) {
		if (!allDone) {
			return false;
		}
		allDone = false;
		tasksRemaining = 0;
		tasksCompleted = 0;
		nextTaskId = 0;
	}
}

