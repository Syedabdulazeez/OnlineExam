function updateTimer() {
  const endTimeStr = document.getElementById("exam-data").getAttribute("end_time");
  const endTime = new Date(endTimeStr);
  const now = new Date();
  const timeLeft = endTime - now;

  if (timeLeft <= 0) {
    document.getElementById("exam-form").submit();
  } else {
    const minutes = Math.floor((timeLeft % (1000 * 60 * 60)) / (1000 * 60));
    const seconds = Math.floor((timeLeft % (1000 * 60)) / 1000);
    const countdownElement = document.getElementById("countdown");

    if (minutes > 15) {
      countdownElement.style.color = "green";
    } else if (minutes > 1) {
      countdownElement.style.color = "orange";
    } else {
      countdownElement.style.color = "red";
    }

    countdownElement.innerHTML = "Time Left: " + minutes + "m " + seconds + "s";
  }
}

setInterval(updateTimer, 1000);
updateTimer();
