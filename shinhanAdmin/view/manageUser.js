$(document).ready(function () {

    $('#searchCompany').selectpicker();

 /** start of grid ***********************/
 var mainGrid = new tui.Grid({
    el: document.getElementById('mainGrid'),
    rowHeaders: ['checkbox', 'rowNum'],
    data: [],
    bodyHeight: 200,
    scrollX: false,
    scrollY: true,
    columns: [
        {
            header: '사번',
            name: 'name',
            minWidth: 100
        },
        {
            header: '회사명',
            name: 'name',
            minWidth: 100
        },
        {
            header: '성명',
            name: 'release',
            minWidth: 120
        },
        {
            header: '관심태그',
            name: 'creator',
            minWidth: 120
        },
        {
            header: '이메일',
            name: 'date',
            minWidth: 120
        },
        {
            header: '수강강좌수',
            name: 'participant',
            minWidth: 70
        }
    ]
});

 /** start of grid ***********************/
 var detailGrid = new tui.Grid({
    el: document.getElementById('detailGrid'),
    rowHeaders: ['checkbox', 'rowNum'],
    data: [],
    bodyHeight: 250,
    scrollX: false,
    scrollY: true,
    columns: [
        {
            header: '수강과목명',
            name: 'name',
            minWidth: 100
        },
        {
            header: '카테고리',
            name: 'release',
            minWidth: 120
        },
        {
            header: '관련태그',
            name: 'creator',
            minWidth: 120
        },
        {
            header: '강사명',
            name: 'date',
            minWidth: 120
        },
        
    ]
});


    resizeFrame();

});