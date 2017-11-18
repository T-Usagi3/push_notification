self.addEventListener('push', e => {
  let data = e.data.json();
  let title = data.title;
  let msg = {
    icon: '',
    body: data.body,
    tag: data.tag
  };
  e.waitUntil(self.registration.showNotification(title, msg));
}, false);
