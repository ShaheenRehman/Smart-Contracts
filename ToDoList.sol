// SPDX-License-Identifier: aIT
pragma solidity 0.8.5;

contract ToDoList {
    struct Todolist {
        string task;
        bool done;
    }

    Todolist[] public todos;

    function Create(string memory _task) public {
        todos.push(Todolist(_task, false));
    }

    function Update(uint _index, string memory _task) public {
        Todolist storage todo = todos[_index];
        todo.task = _task;
    }

    function Delete(uint _index) public {
        Todolist storage todo = todos[_index];
        delete todo.task;
    }

    function Done(uint _index) public {
        Todolist storage todo = todos[_index];
        todo.done = !todo.done;
    }
}
