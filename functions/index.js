const functions = require('firebase-functions');
const admin = require("firebase-admin");
admin.initializeApp();

// Create and Deploy Your First Cloud Functions
// https://firebase.google.com/docs/functions/write-firebase-functions

exports.helloWorld = functions.https.onRequest((request, response) => {
 response.send("Hello from Firebase!");
});


exports.messageNotification = functions.firestore
    .document('user/{userId}/messages/{docId}')
    .onCreate((change,context)=>{
        const userId = context.params.userId;
        const tokensQuery = admin
            .firestore()
            .collection("user")
            .doc(userId)
            .collection("tokens")
            .listDocuments();

        return tokensQuery.then(tokensRef=>{
            const tokensPromise = tokensRef.map(tokenRef => {
                return tokenRef.get();
            });

            var senderEmail = change.data().from;
            var senderFirstName ="";
            var senderLastName = "";
            const senderData = admin.firestore().collection('user')
                .where("email","==",senderEmail).get().then(snap=>{
                    senderFirstName = snap.docs[0].data().firstName;
                    senderLastName=snap.docs[0].data().lastName;
                });

            Promise.all(tokensPromise).then(val=>{
                const tokens = [];
                for (var x = 0; x < val.length; x++) {
                const data = val[x].data();
                tokens.push(data["token"]);
                }

                senderData.then(val=>{
                    const message = {
                        notification: {
                          title: senderFirstName+" "+senderLastName,
                          body: change.data().text
                        },
                        tokens: tokens
                      };
    
                    admin
                    .messaging()
                    .sendMulticast(message)
                    .then(val => {
                        console.log(val.successCount);
                        console.log(val.responses);
                    });
                })

            });
        });
    });
