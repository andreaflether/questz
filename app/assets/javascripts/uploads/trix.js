// Turn off the default Trix captions
// Trix.config.attachments.preview.caption = {
//   name: false,
//   size: false
// };

function uploadAttachment(attachment) {
  // Create our form data to submit
  var file = attachment.file;
  var form = new FormData;
  form.append('Content-Type', file.type);
  form.append('photo[image]', file);

  // Create our XHR request
  var xhr = new XMLHttpRequest;
  xhr.open('POST', '/photos.json', true);
  xhr.setRequestHeader('X-CSRF-Token', Rails.csrfToken());

  // Report file uploads back to Trix
  xhr.upload.onprogress = function(event) {
    var progress = event.loaded / event.total * 100;
    attachment.setUploadProgress(progress);
  }

  // Tell Trix what url and href to use on successful upload
  xhr.onload = function() {
    if (xhr.status === 201) {
      var data = JSON.parse(xhr.responseText);
      return attachment.setAttributes({
        url: data.image_url,
        href: data.url,
        id: data.id
      })
    }
  }

  return xhr.send(form);
}

function removeAttachment(file_id) {
  return $.ajax({
    headers: { 'X-CSRF-Token': Rails.csrfToken() },
    type: 'DELETE',
    dataType: 'json',
    url: '/photos/' + file_id,
    cache: false,
    contentType: false,
    processData: false
  });
}

// Listen for the Trix attachment event to trigger upload
document.addEventListener('trix-attachment-add', function(event) {
  var attachment = event.attachment;
  if (attachment.file) {
    return uploadAttachment(attachment);
  }
});

// Listen for the Trix attachment event to trigger remove
document.addEventListener('trix-attachment-remove', function(event) {
  var file_id;
  file_id = event.attachment.attachment.attributes.values.id;
  return removeAttachment(file_id);
});