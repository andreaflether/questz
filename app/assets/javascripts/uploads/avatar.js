Dropzone.autoDiscover = false;

$(document).ready(function() {
  var previewNode = document.querySelector('#template');
  previewNode.id = '';
  var previewTemplate = previewNode.parentNode.innerHTML;
  previewNode.parentNode.removeChild(previewNode);
  
  var avatarUploadModal = new bootstrap.Modal(document.getElementById('changeAvatarModal'), {
    keyboard: false,
    backdrop: 'static'
  })

  var submitButton = $('#upload-avatar');

  $('#changeAvatarModal').on('hidden.bs.modal', function () {
    $('.dropzone-previews').remove();
  })

  function toggleSubmitBtnDisabledPropTo(state) {
    submitButton.prop('disabled', state);
  }

  var avatarDropzone = new Dropzone(document.querySelector('#avatar-dropzone'), {
    paramName: 'user[avatar]',
    url: '/update_avatar',
    method: 'patch',
    parallelUploads: 1,
    maxFilesize: 2,
    maxThumbnailFilesize: 2,
    previewsContainer: '#preview',
    acceptedFiles: '.png, .jpg, .jpeg',
    maxFiles: 1,
    thumbnailWidth: null,
    thumbnailHeight: null,
    autoProcessQueue: false,
    clickable: '.fileinput-button',
    previewTemplate: previewTemplate,
    init: function() {
      this.on('addedfile', function() {
        toggleSubmitBtnDisabledPropTo(false);
        if (this.files.length > 1) {
          this.removeFile(this.files[0]);
        }
      });

      this.on('removedfile', function() {
        toggleSubmitBtnDisabledPropTo(true);
      });

      this.on('sending', function (data, xhr, formData) {
        toggleSubmitBtnDisabledPropTo(true);
        formData.append('user_id', $('#user_id').val());
        formData.append('authenticity_token', Rails.csrfToken());
      });

      this.on('complete', function () {
        if(avatarDropzone.getRejectedFiles().length > 0) {
          toggleSubmitBtnDisabledPropTo(true);
          $('.dropzone-previews .user-avatar-preview').remove();
        } else {
          avatarDropzone.processQueue();

          avatarUploadModal.hide();
    
          this.removeAllFiles(true); 
          $('#edit-avatar').load(location.href + ' #edit-avatar > *', '' );
          $.notyf.open({ type: 'success', message: 'Your avatar was successfully updated!'}); 
        }
      });

      submitButton.click(function () {
        avatarDropzone.processQueue();
      });
    }
  });
});