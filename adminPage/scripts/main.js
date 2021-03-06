const PAGE_COUNT = 3;
const SESSION_TIME = 30;
var currentTime = Date.parse(new Date());
var deadLine = new Date(currentTime + SESSION_TIME * 60 * 1000);
var timeinterval;

function onPageLoadad() {
    setCurrentTimeOnTable();
    // TODO:: Category loading function needs to be added
}

function setCurrentTimeOnTable() {
    document.getElementById("current-date").textContent = getCurrentDate();
}

function getCurrentDate() {
    var date = new Date();
    var dd = String(date.getDate()).padStart(2, '0');
    var mm = String(date.getMonth() + 1).padStart(2, '0');
    var yyyy = date.getFullYear();

    return yyyy + '-' + mm + '-' + dd;
}

function initializeTimerInfo() {
    currentTime = Date.parse(new Date());
    deadLine = new Date(currentTime + SESSION_TIME * 60 * 1000);
}
function getLoginId() {
    return $("#email-text").val();
}
  
function getLoginPassword() {
    return $("#password-text").val();
}

// Menu movement
(function($) {
    $('.show-when-login').click(function() {
        if($(this).index() == 0) {
            return;
        }
        $(this)
        .addClass('active-button')
        .siblings('.show-when-login')
        .removeClass('active-button');
        
        $('section:eq('+$(this).data('rel')+')')
        .stop()
        .fadeIn(300, 'linear')
        .siblings('section')
        .stop()
        .fadeOut(300, 'linear'); 
    });
})(jQuery);
  
$(document).ready(function(){
    $('#email-text, #password-text').keypress(function(event){
        if(event.keyCode === 13){
            $('#login-button').click();
        }
    });
});
  
function onSignIn() {
    initializeTimerInfo();
    var email = getLoginId()+"@admin.com";
    var password = getLoginPassword();
    firebase.auth().signInWithEmailAndPassword(email, password)
        .then(function (success) {
            document.getElementById('auth-text').innerHTML = "Logout";
            $('#email-text').val("");
            $('#password-text').val("");
            this.displayMenu();
            this.addContentsData();
            this.runTimer(deadLine);
            console.log(success);
        })
        .catch(function (error) {
            // Handle Errors here.
            var errorCode = error.code;
            var errorMessage = error.message;
            console.log(errorCode);
            console.log(errorMessage);
        });
}
  
function onSignOut() {
    clearInterval(timeinterval);
    firebase.auth().signOut()
        .then(function (success) {
            var option = document.getElementsByClassName('show-when-login');
            for(var i = 0; i < option.length; i++){
            option[i].style.display = 'none';
            }
            $('section:eq("0")')
            .stop()
            .fadeIn(300, 'linear')
            .siblings('section')
            .stop()
            .fadeOut(300, 'linear'); 
            document.getElementById('auth-text').innerHTML = "Login";
        })
        .catch(function (error) {
            console.log(error);
        })
    
}
  
function displayMenu() {
    var option = document.getElementsByClassName('show-when-login');
    if(isSignIn()){
        for(var i = 0; i < option.length; i++){
            option[i].style.display = 'block';
        }
        option[1].className += " active-button";
        $('.active-button').click();
    }
}

function addContentsData() {
    var index = 0;
    firebase.database().ref('/videos/').once('value')
    .then(function(snapshot) {
        snapshot.forEach(function(video) {
            var videoName = Object.keys(snapshot.val())[index];
            var videoAuthor = video.val().author;
            var videoCategory = video.val().category;
            var videoTag = video.val().tag;
            var videoDate = video.val().date;
            createContent(videoName, videoAuthor, videoCategory, videoTag, videoDate);
            index +=1;
        })
    });
}

function createContent(name, author, category, tag) {
    var container = document.getElementById('user-data');
    var row = document.createElement('tr');
    var removeImgData = document.createElement('img');
    removeImgData.src = "images/trash.png";
    removeImgData.className = "removeIcon";
    removeImgData.setAttribute("onclick","removeSelectedContent('" + name + "')");
    
    for(var i = 0; i < 5; i++) {
        var tData = document.createElement('td');
        if(i == 0){
            tData.innerHTML = author;
        }
        else if(i == 1){
            tData.innerHTML = name;
        }
        else if(i == 2){
            tData.innerHTML = category;
        } else if(i == 3) {
            tData.innerHTML = tag;
        } else {
            tData.appendChild(removeImgData);
        }
        row.appendChild(tData);
    
        // Add element in reverse order
        container.insertBefore(row, container.firstChild);
    }
}

function removeSelectedContent(name) {
    console.log(name);
}
  
// For timer test
function getCurrentTime() {
    var date = new Date();
    var currentTime = date.getFullYear() + "."
      + (date.getMonth()+1)  + "." 
      + date.getDate() + " "  
      + date.getHours() + ":"  
      + date.getMinutes() + ":" 
      + date.getSeconds();
    return currentTime;
}

function timeRemaining(endtime){
	var t = Date.parse(endtime) - Date.parse(new Date());
	var seconds = Math.floor( (t/1000) % 60 );
	var minutes = Math.floor( (t/1000/60) % 60 );
	var hours = Math.floor( (t/(1000*60*60)) % 24 );
	var days = Math.floor( t/(1000*60*60*24) );
	return {'total':t, 'days':days, 'hours':hours, 'minutes':minutes, 'seconds':seconds};
}

function runTimer(endtime){
	var clock = document.getElementById("remaining-session-time");
	function update_clock(){
		var t = timeRemaining(endtime);
		clock.innerHTML = t.minutes+'분 '+t.seconds + '초';
        if(t.total<=0) {
            clearInterval(timeinterval);
            onSignOut('force');
        }
	}
	update_clock(); // run function once at first to avoid delay
    timeinterval = setInterval(update_clock,1000);
}

onPageLoadad();