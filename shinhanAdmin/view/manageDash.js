$(document).ready(function() {

    window.FakeLoader.init( );
    
    
/** start of grid ***********************/
/*스터디관리*/ 

$("#grid1").jsGrid({
    width: "100%",
    height: "241px",
    //inserting: true,
    //editing: true,
    sorting: true,
    paging: false,
    //filtering: true,
    data: [],
    //data: clients,
    fields: [
        { name: "studyname", title: '스터디명', type: "text", width: 120, editing: false, align: "center" },
        { name: "creator", title: "개설자", type: 'text', width: 150, editing: false, align: "center" },
        { name: "date", title: "등록일자", type: 'text', width: 150, editing: false, align: "center", cellRenderer: function(item, value){
            var rslt = $("<td>").addClass("my-row-custom-class");
            var date = moment(item, 'YYYYMMDDHHmmss').format('YYYY-MM-DD');
            $(rslt).append(date);
            return rslt; 
          } }
      
    ],


    
});

fnRetrieve1();


/*조회->스터디*/
function fnRetrieve1() {
    window.FakeLoader.showOverlay();
    
    var searchStudy = $('#studyname').val() || '';//스터디명
    var searchCreator = $('#creator').val() || '';//개설자
    var searchDate = $('#date').val() || '';//등록일자

    //searchCompany = searchCompany.toLowerCase();

    parent.database.ref('/'+ '신한은행'+'/study').once('value').then(function(snapshot)
    {

        var catArr = snapshot.val();
        var rsltArr = [];
        
        $.each(catArr, function(idx, studyObj) {
                 rsltArr.push(studyObj);
        });

        $("#grid1").jsGrid("option", "data", rsltArr);

        window.FakeLoader.hideOverlay();

        $('#grid1').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click
    });
}

/*공지사항관리*/
$("#grid2").jsGrid({
    width: "100%",
    height: "241px",
    //inserting: true,
    //editing: true,
    sorting: true,
    paging: false,
    //filtering: true,
    data: [],

    insertcss: 'editRow',

    //data: clients,


    fields: [
        { name: "title", title: '제목', type: "text", width: 120, editing: false, align: "center" },
        { name: "writor", title: "작성자", type: 'text', width: 150, editing: false, align: "center" },
        { name: "date", title: "등록일자", type: 'text', width: 150, editing: false, align: "center", cellRenderer: function(item, value){
            var rslt = $("<td>").addClass("my-row-custom-class");
            var date = moment(item, 'YYYYMMDDHHmmss').format('YYYY-MM-DD');
            $(rslt).append(date);
            return rslt; 
          } }
        

    ]
    
});

fnRetrieve2();

/*조회->공지사항*/
function fnRetrieve2() {
    window.FakeLoader.showOverlay();
    
    var searchStudy = $('#title').val() || '';//제목
    var searchCreator = $('#writor').val() || '';//작성자
    var searchDate = $('#date').val() || '';//등록일자

    parent.database.ref('/'+ '신한은행'+'/notie').once('value').then(function(snapshot)
    {

        var catArr = snapshot.val();
        var rsltArr = [];
        
        $.each(catArr, function(idx, studyObj) {
                 rsltArr.push(studyObj);
        });

        $("#grid2").jsGrid("option", "data", rsltArr);

        window.FakeLoader.hideOverlay();

        $('#grid2').find('tr.jsgrid-row:eq(0)').click(); //첫번째 row click
    });
}
/*************************차트***************************/

// Set new default font family and font color to mimic Bootstrap's default styling
Chart.defaults.global.defaultFontFamily = 'Nunito', '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
Chart.defaults.global.defaultFontColor = '#858796';

function number_format(number, decimals, dec_point, thousands_sep) {
  // *     example: number_format(1234.56, 2, ',', ' ');
  // *     return: '1 234,56'
  number = (number + '').replace(',', '').replace(' ', '');
  var n = !isFinite(+number) ? 0 : +number,
    prec = !isFinite(+decimals) ? 0 : Math.abs(decimals),
    sep = (typeof thousands_sep === 'undefined') ? ',' : thousands_sep,
    dec = (typeof dec_point === 'undefined') ? '.' : dec_point,
    s = '',
    toFixedFix = function(n, prec) {
      var k = Math.pow(10, prec);
      return '' + Math.round(n * k) / k;
    };
  // Fix for IE parseFloat(0.55).toFixed(0) = 0;
  s = (prec ? toFixedFix(n, prec) : '' + Math.round(n)).split('.');
  if (s[0].length > 3) {
    s[0] = s[0].replace(/\B(?=(?:\d{3})+(?!\d))/g, sep);
  }
  if ((s[1] || '').length < prec) {
    s[1] = s[1] || '';
    s[1] += new Array(prec - s[1].length + 1).join('0');
  }
  return s.join(dec);
}



// 차트
var a=15000;
var ctx = document.getElementById("view_count_chart");
var myBarChart = new Chart(ctx, {
  type: 'bar',
  data: {
    labels: ["1위", "2위", "3위", "4위", "5위", "6위","7위","8위","9위","10위"],
    datasets: [{
      label: "조회수 : ",
      backgroundColor: "#4e73df",
      hoverBackgroundColor: "#2e59d9",
      borderColor: "#4e73df",
      data: [a, 5312, 6251, 7841, 9821, 14984],
    }],
  },
  options: {
    maintainAspectRatio: false,
    layout: {
      padding: {
        left: 10,
        right: 25,
        top: 25,
        bottom: 0
      }
    },
    scales: {
      xAxes: [{
        time: {
          unit: 'month'
        },
        gridLines: {
          display: false,
          drawBorder: false
        },
        ticks: {
          maxTicksLimit: 6
        },
        maxBarThickness: 25,
      }],
      yAxes: [{
        ticks: {
          min: 0,
          max: 15000,
          maxTicksLimit: 10,
          padding: 10,
          // Include a dollar sign in the ticks
          callback: function(value, index, values) {
            return  number_format(value)+ ' 회';
          }
        },
        gridLines: {
          color: "rgb(234, 236, 244)",
          zeroLineColor: "rgb(234, 236, 244)",
          drawBorder: false,
          borderDash: [2],
          zeroLineBorderDash: [2]
        }
      }],
    },
    legend: {
      display: false
    },
    tooltips: {
      titleMarginBottom: 10,
      titleFontColor: '#6e707e',
      titleFontSize: 14,
      backgroundColor: "rgb(255,255,255)",
      bodyFontColor: "#858796",
      borderColor: '#dddfeb',
      borderWidth: 1,
      xPadding: 15,
      yPadding: 15,
      displayColors: false,
      caretPadding: 10,
      callbacks: {
        label: function(tooltipItem, chart) {
          var datasetLabel = chart.datasets[tooltipItem.datasetIndex].label || '';
          return datasetLabel + number_format(tooltipItem.yLabel)+' 회';
        }
      }
    },
  }
});


    //resize frame height
    resizeFrame();
    
});
