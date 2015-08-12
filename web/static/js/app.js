import {Socket} from "phoenix"

class App {
    static init() {
	var socket = new Socket("/socket")
	socket.connect()
	socket.onClose(e => console.log("CLOSE", e))

	var chan = socket.chan("games:live", {})
	chan.join().receive("ignore", () => console.log("auth error"))
            .receive("ok", () => console.log("join ok"))
	chan.onError(e => console.log("something went wrong", e))
	chan.onClose(e => console.log("channel closed", e))

	document.onkeydown = checkKey;
	chan.on("move:up", state => display_move(state));
	chan.on("move:down", state => display_move(state));
	chan.on("move:left", state => display_move(state));
	chan.on("move:right", state => display_move(state));
	chan.on("grid", game => write_grid(game.grid))
	chan.on("move", game => write_grid(game.grid))

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

	function write_grid(grid) {
	    var tileContainer = document.getElementById("tile-container")
	    while (tileContainer.firstChild) {
		tileContainer.removeChild(tileContainer.firstChild);
	    }

	    for (var i = 0; i < grid.length; i++) {
		for (var j = 0; j < grid[i].length; j++) {
		    if (grid[i][j] > 0) {
			var tile = document.createElement("div")
			tile.className = "tile tile-" + grid[i][j] + " tile-position-" + (j + 1) + "-" + (i + 1)
			var tileInner = document.createElement("div")
			tileInner.className = "tile-inner"
			var value = document.createTextNode(grid[i][j])

			tileInner.appendChild(value)
			tile.appendChild(tileInner)
			tileContainer.appendChild(tile)
		    }
		}
	    }
	}

	function display_move(state) {
	    var upCounter = document.getElementById("up-counter")
	    var downCounter = document.getElementById("down-counter")
	    var leftCounter = document.getElementById("left-counter")
	    var rightCounter = document.getElementById("right-counter")

	    if (upCounter.hasChildNodes()) upCounter.removeChild(upCounter.firstChild);
	    if (downCounter.hasChildNodes()) downCounter.removeChild(downCounter.firstChild);
	    if (leftCounter.hasChildNodes()) leftCounter.removeChild(leftCounter.firstChild);
	    if (rightCounter.hasChildNodes()) rightCounter.removeChild(rightCounter.firstChild);

	    upCounter.appendChild(document.createTextNode(state.up))
	    downCounter.appendChild(document.createTextNode(state.down))
	    leftCounter.appendChild(document.createTextNode(state.left))
	    rightCounter.appendChild(document.createTextNode(state.right))
	}
    }
}

App.init()

export default App
