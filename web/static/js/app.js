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
    chan.on("move:up", state => console.log(state.up))
    chan.on("move:down", state => console.log(state.down))
    chan.on("move:left", state => console.log(state.left))
    chan.on("move:right", state => console.log(state.right))
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
  }
}

App.init()

export default App
