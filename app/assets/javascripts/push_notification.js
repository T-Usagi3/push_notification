window.addEventListener('load', () => {
  navigator.serviceWorker.register('/service_worker.js').then(() => {
    Notification.requestPermission(state => {
      if(state !== 'granted') {
        return;
      }
      navigator.serviceWorker.ready.then(registration => {
        const subscribe = subscription => {
          const encode64 = str => btoa(String.fromCharCode.apply(null, new Uint8Array(str))).replace(/\+/g, '-').replace(/\//g, '_');
          const endpoint = subscription.endpoint;
          const publicKey = encode64(subscription.getKey('p256dh'));
          const auth = encode64(subscription.getKey('auth'));
          let sendBtn = document.getElementById('send');

          document.getElementById('label-endpoint').textContent = endpoint;
          document.getElementById('label-p256dh').textContent = publicKey;
          document.getElementById('label-auth').textContent = auth;
          sendBtn.onclick = function () {
            let formData = new FormData();

            formData.append('p256dh', publicKey);
            formData.append('auth', auth);
            formData.append('endpoint', endpoint);

            fetch('/push_notifications', {
              method: 'POST',
              credentials: 'include',
              body: formData
            }).then(r => r.text()).then(r => console.log(r));
          }
        }

        registration.pushManager.getSubscription().then(subscription => {
          if(subscription) {
            subscribe(subscription);
          } else {
            registration.pushManager.subscribe({
              userVisibleOnly: true
            }).then(subscribe);
          }
        });
      });
    });
  });
});
