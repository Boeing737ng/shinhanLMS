
(function ($) {
    "use strict";

    onSignOut();

    /*==================================================================
    [ Focus input ]*/
    /* $('.input100').each(function(){
        $(this).on('blur', function(){
            if($(this).val().trim() != "") {
                $(this).addClass('has-val');
            }
            else {
                $(this).removeClass('has-val');
            }
        });    
    }) */
    $('.input100').addClass('has-val');
  
  
    /*==================================================================
    [ Validate ]*/
    var input = $('.validate-input .input100');


    $('#btnLogin').on('click', function(e) {
        var check = true;

        for(var i=0; i<input.length; i++) {
            if(validate(input[i]) == false){
                showValidate(input[i]);
                return;
            }
        }

        var loginId = $('input[name=empNo]').val();
        var password = $('input[name=pass]').val();

        console.log(loginId + ' ' + password);
        onSignIn(loginId, password);
    });


    $('.validate-form .input100').each(function(){
        $(this).focus(function(){
           hideValidate(this);
        });
    });

    function validate (input) {

        if($(input).attr('name') == 'empNo') {
            if(($(input).val() || '').trim() == '') {
                return false;
            }
        }else if($(input).attr('name') == 'pass') {

            if(($(input).val() || '').trim() == '') {
                return false;
            }
        }
    }

    function showValidate(input) {
        var thisAlert = $(input).parent();

        $(thisAlert).addClass('alert-validate');
    }

    function hideValidate(input) {
        var thisAlert = $(input).parent();

        $(thisAlert).removeClass('alert-validate');
    }


    function onSignIn(loginId, password) {
        var email = loginId + "@admin.com";
        var password = password;
        firebase.auth().signInWithEmailAndPassword(email, password)
            .then(function (success) {
                setSessionUserInfo(loginId, function() {
                    window.location.href = '/index.html';
                });
            })
            .catch(function (error) {
                // Handle Errors here.
                var errorCode = error.code;
                var errorMessage = error.message;
                console.log(errorCode);
                console.log(errorMessage);

                alert('로그인에 실패했습니다.');
                window.location.href = '/login.html';
            });
    }


    //세션스토리지에 세션정보 저장
    function setSessionUserInfo(userId, callback) {

        firebase.database().ref('/user/' + userId).once('value')
        .then(function (snapshot) {
            var userObj = snapshot.val();
            var sessionStorage = window.sessionStorage;
            sessionStorage.setItem('userInfo', JSON.stringify(userObj));

            if(callback != null && callback != undefined) {
                callback();
            }
        });
    }


    //세션 끊기
    function onSignOut() {
        firebase.auth().signOut().then(function (success) {
            window.sessionStorage.setItem('userInfo', null); //세션스토리지에 있는 내용 삭제
        }).catch(function (error) {
            console.log(error);
        });
    }
    
    /*==================================================================
    [ Show pass ]*/
    var showPass = 0;
    $('.btn-show-pass').on('click', function(){
        if(showPass == 0) {
            $(this).next('input').attr('type','text');
            $(this).find('i').removeClass('zmdi-eye');
            $(this).find('i').addClass('zmdi-eye-off');
            showPass = 1;
        }
        else {
            $(this).next('input').attr('type','password');
            $(this).find('i').addClass('zmdi-eye');
            $(this).find('i').removeClass('zmdi-eye-off');
            showPass = 0;
        }
        
    });


    $('span[data-placeholder=사번]').focus();
    //$('input[name=empNo]').focus();

})(jQuery);