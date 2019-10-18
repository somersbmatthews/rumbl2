import Player from "./player"

let Video = {

   init(socket, element) { if(!element){ return }
      let playerId = element.getAttribute("data-player-id")
      let videoId = element.getAttribute("data-id")
      socket.connect()
      Player.init(element.id, playerId, () => {
         this.onReady(videoId, socket)
      })
      },
   

   onReady(videoId, socket){
      let msgContainer = document.getElementById("msg-container")
      let msgInput = document.getElementById("msg-input")
      let postButton = document.getElementById("msg-submit")
      let vidChannel = socket.channel("videos:" + videoId)

      postButton.addEventListener("click", e => {
         let payoad = {body: msgInput.Value, at: 
            Player.getCurrentTime()}
         vidChannel.push("new_annotation", payload)
                   .receive("error", e => console.log(e) )
                   msgInput.value = ""
         })
         
      
      vidChannel.join()
         .receive("ok", resp => console.log("joined the video channel", resp))
         .receive("error", reason => console.log("join failed", reason))

      renderAnnotation(msgContainer, {user, body, at}){
         // TODO append annotation to msgContainer
      }
      vidChannel.on("ping", ({count}) => console.log("PING", count))
   }

}
export default Video

