function onSignUp() {
    var email = "admin@admin.com"
    var password = "admin12";
    firebase.auth().createUserWithEmailAndPassword(email, password)
        .then(function (success) {
            console.log("가입 완료");
        })
        .catch(function (error) {
            // Handle Errors here.
            var errorCode = error.code;
            var errorMessage = error.message;
            console.log(errorCode);
            console.log(errorMessage);
        });
}