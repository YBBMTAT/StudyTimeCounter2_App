const timer = () => {
  //要素取得
  const timerDisplay = document.getElementById('timer-display');
  const startStopButton = document.getElementById('start-stop-button');
  const breakButton = document.getElementById("break-button");
  const breakTimerDisplay = document.getElementById('break-timer-display');
  const breakImage = document.querySelector('.break-icon'); 

  //インターバル保持
  let timerInterval;
  let breakTimerInterval; 
  let seconds = 0;
  let breakSeconds = 0;
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
 
  //ディスプレイ更新関数
  function updateTimerDisplay() {
   timerDisplay.textContent = formatTime(seconds);
  }
  function updateBreakTimerDisplay() {
    breakTimerDisplay.textContent = formatTime(breakSeconds);
  }
 
   //イベント発火条件
  startStopButton.addEventListener('click', startStopTimer);
 
   //ストップウォッチの内部機能
   function startStopTimer() {
     if (isTimerRunning) {
     clearInterval(timerInterval);
     clearInterval(breakTimerInterval);
     startStopButton.textContent = '開始'; //クリックすると表示切替
     saveTimeData(seconds); //経過時間をデータベースに保存
     seconds = 0; //停止と同時にカウントリセット
     breakSeconds = 0;
     updateTimerDisplay();
     updateBreakTimerDisplay();
     } else {
         timerInterval = setInterval(function() {
           if (!document.hidden) { //アクティブ状態でのみカウンター機能
             seconds++; //加算処理
             updateTimerDisplay();
           } 
         }, 1000);
       startStopButton.textContent = '終了';
     }
 
     isTimerRunning = !isTimerRunning;
   }
   
   //usersettingテーブルからデータ取得
    fetch('/usersettings/countdown_setting')
    .then(response => response.json())
    .then(data => {
      const configurationState = data.configuration_state;
      const countdownTime = data.countdown_time;
        console.log(configurationState);
        console.log(countdownTime);

   //休憩ボタンクリック時の処理
    breakButton.addEventListener('click', function() {
      if (isTimerRunning) {
        clearInterval(timerInterval);
        isTimerRunning = false;
        startStopButton.textContent = '開始';
        clearInterval(breakTimerInterval); // 既に休憩時間のインターバルが動いていたらクリアする
        breakTimerDisplay.style.display = 'block'; // 休憩時間ディスプレイを表示する
       
        // カウントダウンモードの場合のみ初期化
        if (configurationState === false) {
          breakSeconds = countdownTime;
        }
       
        breakTimerInterval = setInterval(function() {
          if (configurationState === true) {
            console.log("カウントアップ")
           breakSeconds++;
          } else if (configurationState === false) {
            if (breakSeconds > 0) {
              breakSeconds--;
            } else {
              clearInterval(breakTimerInterval); // 時間が0になったらタイマーを停止
            }
          }
          updateBreakTimerDisplay(); // 休憩時間ディスプレイを更新する
        }, 1000);
        breakImage.style.display = 'block';
      }
    });
  })
  .catch(error => {
    console.error('Error:', error);
  });

   // 開始ボタンを押したら休憩時間のカウントをリセットする
   startStopButton.addEventListener('click', function() {
    clearInterval(breakTimerInterval);
    breakSeconds = 0;
    updateBreakTimerDisplay();
    breakTimerDisplay.style.display = 'none';
    breakImage.style.display = 'none';
   });

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
 
 };

window.addEventListener("turbo:load", timer);
window.addEventListener("turbo:render",timer);