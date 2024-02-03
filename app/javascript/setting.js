const setting = () => {
  //要素取得
  const countDownRadio = document.getElementById('count-down-radio');
  const breakTimeForm = document.getElementById('break-time-form');
  const countUpRadio = document.getElementById('count-up-radio');

 // ページ読み込み時に表示を制御
  if (countDownRadio.checked) {
    breakTimeForm.style.display = 'block'; // カウントダウンが選択時フォームを表示
  } else {
    breakTimeForm.style.display = 'none'; // カウントアップが選択時フォームを非表示
  }

  //カウントダウン選択時
  countDownRadio.addEventListener('change', function() {
    breakTimeForm.style.display = countDownRadio.checked ? 'block' : 'none';
  });

  //カウントアップ選択時
  countUpRadio.addEventListener('change', function() {
    breakTimeForm.style.display = countUpRadio.checked ? 'none' : 'block';
  });

};
window.addEventListener("turbo:load", setting);
window.addEventListener("turbo:render",setting);