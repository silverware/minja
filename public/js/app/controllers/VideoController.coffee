if typeof webkitRTCPeerConnection != "undefined"
    RTCPeerConnection = webkitRTCPeerConnection
else if typeof mozRTCPeerConnection != "undefined"
    RTCPeerConnection = mozRTCPeerConnection


Chat.VideoController = Em.ObjectController.extend
  title: "Video Chat"


