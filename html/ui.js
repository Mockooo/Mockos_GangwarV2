function setValue(key, value){
	$('#'+key+' span').html(value)

}

$(document).ready(function(){
    window.addEventListener('message', function(event) {
        
        var data = event.data;
        if (data.punkte === false) {
            $('#job1').text(data.job1);
            $('#job2').text(data.job2);
        }else if(data.punkte === true) {
            $('#punktezahl-links').text(data.plinks);
            $('#punktezahl-rechts').text(data.prechts);
        }
    });
});