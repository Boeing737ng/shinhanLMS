/* Bootstrap core JavaScript */
//<script src="/vendor/jquery/jquery.min.js"></script>
//<script src="/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

/* Core plugin JavaScript */
//<script src="/vendor/jquery-easing/jquery.easing.min.js"></script>

/* Custom scripts for all pages */
//<script src="/js/sb-admin-2.min.js"></script>

/* Page level plugins */
//<script src="vendor/chart.js/Chart.min.js"></script>

/* firebase */
//<script src="https://www.gstatic.com/firebasejs/6.3.5/firebase-app.js"></script>
//<script src="https://www.gstatic.com/firebasejs/5.10.1/firebase-auth.js"></script>
//<script src="https://www.gstatic.com/firebasejs/6.2.3/firebase-storage.js"></script>
//<script src="https://www.gstatic.com/firebasejs/5.10.1/firebase-database.js"></script>
//<script src="js/firebaseConfig.js"></script>


/* bootstrap select */
//<script src="/vendor/bootstrap-select/dist/js/bootstrap-select.js"></script>


/* Bootstrap core JavaScript */
addJavascript('/vendor/jquery/jquery.min.js');
addJavascript('/vendor/bootstrap/js/bootstrap.bundle.min.js');

/* Core plugin JavaScript */
addJavascript('/vendor/jquery-easing/jquery.easing.min.js');

/* Custom scripts for all pages */
addJavascript('/js/sb-admin-2.min.js');

/* Page level plugins */
addJavascript('/vendor/chart.js/Chart.min.js');

/* firebase */
addJavascript('https://www.gstatic.com/firebasejs/6.3.5/firebase-app.js');
addJavascript('https://www.gstatic.com/firebasejs/5.10.1/firebase-auth.js');
addJavascript('https://www.gstatic.com/firebasejs/6.2.3/firebase-storage.js');
addJavascript('https://www.gstatic.com/firebasejs/5.10.1/firebase-database.js');
addJavascript('/js/firebaseConfig.js');

/* bootstrap select */
addJavascript('/vendor/bootstrap-select/dist/js/bootstrap-select.js');






function addJavascript(jsname) {

	var th = document.getElementsByTagName('head')[0];

	var s = document.createElement('script');

	s.setAttribute('type','text/javascript');

	s.setAttribute('src',jsname);

	th.appendChild(s);

}


function resizeWindow() {
    var the_height= document.body.scrollHeight;
    $(window.parent.document.getElementById('contentDiv')).css('height', the_height);
    $(window.parent.document.getElementById('contentDiv')).css('overflow', 'hidden');
}