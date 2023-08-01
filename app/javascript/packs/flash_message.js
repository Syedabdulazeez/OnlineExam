document.addEventListener('DOMContentLoaded', function() {
  var noticeElement = document.getElementById('notice');
  if (noticeElement) {
    setTimeout(function() {
      noticeElement.style.opacity = '0';
      setTimeout(function() {
        noticeElement.style.display = 'none';
      }, 1000); // Adjust this value to control the fade-out duration
    }, 2000); // Wait for 2 seconds before starting the fade-out
  }
});