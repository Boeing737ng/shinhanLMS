function uploadVideo() {
    var contentFile = document.getElementById("content-file").files[0];

    var metadata = {
        contentType: null
    };
    var uploadTask = firebase.storage().ref('videos/' + contentFile.name).put(contentFile, metadata);

    uploadTask.on(firebase.storage.TaskEvent.STATE_CHANGED,
    function(snapshot) {
        var progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        console.log('Upload is ' + progress + '% done');
        switch (snapshot.state) {
        case firebase.storage.TaskState.PAUSED:
            console.log('Upload is paused');
            break;
        case firebase.storage.TaskState.RUNNING:
            break;
        }
    }, function(error) {
        switch (error.code) {
            case 'storage/unauthorized':
                break;
            case 'storage/canceled':
                break;
            case 'storage/unknown':
                break;
        }
    }, function() {
        uploadTask.snapshot.ref.getDownloadURL().then(function(downloadURL) {
            setVideoDatabase(downloadURL);
            console.log('File available at', downloadURL);
        });
    });
}

function setVideoDatabase(url) {

    var contentName = document.getElementById("content-name").value;
    var contentAuthor = document.getElementById("content-author").value;
    var contentCategory = document.getElementById("content-category").value;
    var contentTag = document.getElementById("content-tags").value;
    var contentDescription = document.getElementById("content-description").value;
    var contentAddedTime = document.getElementById("current-date").textContent;

    firebase.database().ref('videos/' + replaceBlankSpace(contentName) + '/').set({
        downloadURL: url,
        author: contentAuthor,
        category: contentCategory,
        tags: contentTag,
        description: contentDescription,
        date: contentAddedTime
    }).then(function onSuccess(res) {
        console.log("Video info uploaded");
      }).catch(function onError(err) {
        console.log("ERROR!!!! " + err);
      });
}

function replaceBlankSpace(string) {
    return string.replace(' ','_');
}