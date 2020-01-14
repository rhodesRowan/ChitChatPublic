const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendPushNotification = functions.database.ref('/messages/{messageID}').onCreate((snapshot, context) => {

  // get the values from the message
  const messageData = snapshot.val();
  const toID = messageData.toID;
  const fromID = messageData.fromID;
  var messageBody;
  if (messageData.text) {
    messageBody = messageData.text;
  } else if (messageData.gifID) {
    messageBody = "sent a gif";
  } else if (messageData.videoURL) {
    messageBody = "sent a video";
  } else if (messageData.imageURL) {
    messageBody = "sent an image"
  }
  return admin.firestore().collection("users").doc(fromID).get().then(snapshot => {
    const senderDetails = snapshot.data();
    const senderName = senderDetails.name;
    return (admin.firestore().collection("users").doc(toID).get().then(snapshot => {
      const receiverDetails = snapshot.data();
      const deviceToken = receiverDetails.deviceToken;
      const payload = {
        notification: {
          title: senderName,
          body: messageBody,
          sound: "message.m4a",
          badge: "1",
        },
        data: {
          senderID: fromID,
          category: "private_message"
        }
      }

      const options = {
        content_available: true,
        mutable_content: true
      }

      return admin.messaging().sendToDevice(deviceToken, payload, options).then( response => {
        return response
      })
    }))
  })
});
