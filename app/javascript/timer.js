document.addEventListener('DOMContentLoaded', function() {
  const timerDisplay = document.getElementById('timer-display');
  const startStopButton = document.getElementById('start-stop-button');
 
 
  let timerInterval;
  let seconds = 0;
  let isTimerRunning = false;
 
  //ストップウォッチ機能
  function formatTime(timeInSeconds) {
   const hours = Math.floor(timeInSeconds / 3600);
   const minutes = Math.floor((timeInSeconds % 3600) / 60);
   const seconds = timeInSeconds % 60;
 
   return (
     String(hours).padStart(2, '0') +
     ':' +
     String(minutes).padStart(2, '0') +
     ':' +
     String(seconds).padStart(2, '0') 
   );
  }
 
  function updateTimerDisplay() {
   timerDisplay.textContent = formatTime(seconds);
  }
 
   //イベント発火条件
  startStopButton.addEventListener('click', startStopTimer);
 
   //ストップウォッチの内部機能
   function startStopTimer() {
     if (isTimerRunning) {
     clearInterval(timerInterval);
     startStopButton.textContent = '開始'; //クリックすると表示切替
     saveTimeData(seconds); //経過時間をデータベースに保存
     seconds = 0; //停止と同時にカウントリセット
     updateTimerDisplay();
     } else {
         timerInterval = setInterval(function() {
           if (!document.hidden) { //アクティブ状態でのみカウンター機能
             seconds++;
             updateTimerDisplay();
           } 
         }, 1000);
       startStopButton.textContent = '終了';
     }
 
     isTimerRunning = !isTimerRunning;
   }
   
   //サーバーサイドにデータ送信
   function saveTimeData(durationSeconds) {
     const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
     fetch('/timers/save',{
       method: 'POST',
       //Json形式で送信
       headers: {
        'Content-type': 'application/json',
        'X-CSRF-Token': csrfToken,
       },
       //JSON形式のデータ格納
       body: JSON.stringify({
         duration_seconds: durationSeconds,
       }),
     })
     //サーバーサイドからのレスポンスをJSON形式で解釈
     .then(response => response.json())
     .then(data => {
       console.log('Success:', data);
     })
     .catch((error) => {
       console.error('Error', error);
     });
   }
 
 
   //アクティブ状態でのタグ名変更
   document.addEventListener('visibilitychange', function() {
     if (document.hidden) {
       document.title = "【警告】タイマー停止中";
     } else {
       document.title = "TimecounterApp";
     }
   });
 
 });