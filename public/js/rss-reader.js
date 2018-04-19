const handle = setInterval(updateTimestamps, 90000);

function updateTimestamps() {
  let first = true;
  const stamps = document.querySelectorAll('.humantime');

  stamps.forEach(stampItem => {
    fetch(`/humantime?stamp=${stampItem.dataset.stamp}&first=${first}`).then(
      response => {
        if (response.status === 200) {
          response.json().then(data => {
            if (data.first && data.ago.match(/yesterday/i)) {
              console.log('Cancelling update');
              clearInterval(handle); // Stop asking after the top one is yesterday
            }

            stampItem.textContent = data.ago;
          });
        }
      }
    );

    first = false;
  });
}

const feeds = document.getElementById('feeds');
const reload = document.getElementById('reload');

feeds.addEventListener('change', function() {
  window.location = '/feed/' + this.value;
});

reload.addEventListener('click', () => window.location.reload(true));
