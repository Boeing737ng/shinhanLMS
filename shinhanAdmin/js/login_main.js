
(function ($) {
    "use strict";


    /*==================================================================
    [ Focus input ]*/
    $('.input100').each(function(){
        $(this).on('blur', function(){
            if($(this).val().trim() != "") {
                $(this).addClass('has-val');
            }
            else {
                $(this).removeClass('has-val');
            }
        });    
    })
  
  
    /*==================================================================
    [ Validate ]*/
    var input = $('.validate-input .input100');

    $('.validate-form').on('submit',function(){
        /* var check = true;

        for(var i=0; i<input.length; i++) {
            if(validate(input[i]) == false){
                showValidate(input[i]);
                check=false;
            }
        }

        if(check) {
            var loginId = $('input[name=loginId]').val();
            var password = $('input[name=pass]').val();
            onSignIn(loginId, password);
        }

        return check; */
    });


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
        /* if($(input).val().trim() == ''){
            return false;
        } */

        if($(input).attr('name') == 'empNo') {
            if(($(input).val() || '').trim() == '') {
                return false;
            }
        }else if($(input).attr('name') == 'pass') {

            if(($(input).val() || '').trim() == '') {
                return false;
            }
        }
        
        /* if($(input).attr('type') == 'email' || $(input).attr('name') == 'email') {
            if($(input).val().trim().match(/^([a-zA-Z0-9_\-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([a-zA-Z0-9\-]+\.)+))([a-zA-Z]{1,5}|[0-9]{1,3})(\]?)$/) == null) {
                return false;
            }
        }
        else {
            if($(input).val().trim() == ''){
                return false;
            }
        } */
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
                //document.getElementById('auth-text').innerHTML = "Logout";
                //$('#email-text').val("");
                //$('#password-text').val("");
                //this.displayMenu();
                //this.addContentsData();
                //this.runTimer(deadLine);
                console.log(success);

                window.location.href = '/index.html';
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

})(jQuery);