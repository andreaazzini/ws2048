import {Socket} from "phoenix"

class App {
    static init() {
        var state = []
        var socket = new Socket("/socket")
        socket.connect()
        socket.onClose(e => console.log("CLOSE", e))

        var chan = socket.chan("games:live")
        chan.join().receive("ignore", () => console.log("auth error"))
            .receive("ok", () => console.log("join ok"))
        chan.onError(e => console.log("something went wrong", e))
        chan.onClose(e => console.log("channel closed", e))

        document.onkeydown = checkKey;
        chan.on("move:up", state => display_move(state))
        chan.on("move:down", state => display_move(state))
        chan.on("move:left", state => display_move(state))
        chan.on("move:right", state => display_move(state))
        chan.on("grid", game => init_grid(game.grid))
        chan.on("move", game => write_grid(game.grid))
        chan.on("timeout", timeout => display_timeout(timeout.decided))

        function checkKey(e) {
            e = e || window.event;

            if (e.keyCode == '38') {
                chan.push("move:up")
            }
            else if (e.keyCode == '40') {
                chan.push("move:down")
            }
            else if (e.keyCode == '37') {
                chan.push("move:left")
            }
            else if (e.keyCode == '39') {
                chan.push("move:right")
            }
        }

        function display_timeout(decided) {
            var moveTimer = document.getElementById("timer")
            var move = document.getElementById("move")

            var initial = 200;
            var count = initial;
            var counter;

            function timer() {
                if (count <= 0) {
                    clearInterval(counter);
                    return;
                }
                count--;
                displayCount(count);
            }

            function displayCount(count) {
                var res = count / 100;
                moveTimer.innerHTML = res.toPrecision(count.toString().length);
            }

            counter = setInterval(timer, 8);
            displayCount(initial);
            if (decided) {
                move.style.background = "green"
            } else {
                display_move({up: 0, down: 0, left: 0, right: 0})
                move.style.background = "red"
            }
        }

        function init_grid(grid) {
            state = grid
            write_grid(grid)
        }

        function write_grid(grid) {
            var tileContainer = document.getElementById("tile-container")
            while (tileContainer.firstChild) {
                tileContainer.removeChild(tileContainer.firstChild);
            }

            for (var i = 0; i < grid.length; i++) {
                for (var j = 0; j < grid[i].length; j++) {
                    if (grid[i][j]) {
                        var tile = document.createElement("div")
                        tile.className = "tile tile-" + grid[i][j] + " tile-position-" + (j + 1) + "-" + (i + 1)
                        if (state[i][j]) {
                            if (state[i][j] != grid[i][j]) tile.className += " tile-merged"
                        } else {
                            tile.className += " tile-new"
                        }
                        var tileInner = document.createElement("div")
                        tileInner.className = "tile-inner"
                        var value = document.createTextNode(grid[i][j])

                        tileInner.appendChild(value)
                        tile.appendChild(tileInner)
                        tileContainer.appendChild(tile)
                    }
                }
            }
            state = grid
        }

        function display_move(state) {
            var move = document.getElementById("move")

            var moves = [state.up, state.down, state.left, state.right]
            var selected_move = Math.max.apply(null, moves)
            var moveIndex = moves.indexOf(selected_move)

            if (move.hasChildNodes()) move.removeChild(move.firstChild)

            var unique_move = true
            for (var i = 0; i < moves.length; i++) {
                if (i != moveIndex && moves[i] == selected_move) {
                    unique_move = false
                    break
                }
            }
            if (unique_move) {
                switch (moveIndex) {
                    case 0:
                        move.appendChild(document.createTextNode("\u2191"));
                        break;
                    case 1:
                        move.appendChild(document.createTextNode("\u2193"));
                        break;
                    case 2:
                        move.appendChild(document.createTextNode("\u2190"));
                        break;
                    case 3:
                        move.appendChild(document.createTextNode("\u2192"));
                        break;
                }
            } else move.appendChild(document.createTextNode("\u2014"));

            move.style.background = "#cca92c"
        }
    }
}

App.init()

export default App
