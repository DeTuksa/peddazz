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

        tokensQuery.then(tokensRef=>{
            const tokensPromise = tokensRef.map(tokenRef => {
                return tokenRef.get();
            });

            Promise.all(tokensPromise).then(val=>{
                const tokens = [];
                for (var x = 0; x < val.length; x++) {
                const data = val[x].data();
                tokens.push(data["token"]);
                }

                const message = {
                    notification: {
                      title: change.data().from,
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

            });
        });
    });
