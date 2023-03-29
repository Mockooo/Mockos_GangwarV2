$(document).ready(function(){
  window.addEventListener('message', function(event) {
      var data = event.data;
      if(data.timer === true) {
        var minutes = Math.round((data.zeit - 30)/60),
        remainingSeconds = data.zeit % 60;

        if (remainingSeconds < 10) {
          remainingSeconds = "0" + remainingSeconds;  
        }

        document.getElementById('zeit').innerHTML = minutes + ":" + remainingSeconds;

        if (data.zeit == 0) {
          document.getElementById('zeit').innerHTML = "00:00";
        }
      } else if (data.timer === false) {

      }
  });
});