( function($) {
  $.fn.flash_message = function(options) {
    
    options = $.extend({
      text: 'Done',
      time: 1500,
      how: 'before',
      class_name: ''
    }, options)
    
    return $(this).each(() => {
      if( $(this).parent().find('.flash_message').get(0) )
        return
      
      $(this).css("color", options.success ? 'green' : 'red')

      let message = $('<span />', {
        'class': 'flash_message ' + options.class_name,
        text: options.text
      }).hide().fadeIn('fast')
      
      $(this)[options.how](message)
      
      message.delay(options.time).fadeOut( 'normal', () => $(this).empty() )
      
    })
  }
})(jQuery)


// Check email validity.
const checkEmail = email => {
  $.ajax({
    url: '/emails/validate',
    type: 'get',
    beforeSend: xhr => {
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
    },
    dataType: 'json',
    data: {
      email: email,
    },
    success: res => {
      const success = !!res.mx_found 
      let message = success ? "Valid Email!" : "Invalid Email!"

      if( res.success === false && res.error ) { message = res.error.info }

      $('#status-area').flash_message({
          text: message,
          how: 'append',
          success: success,
      })
    },
    error:  err => {
      let message = err.status === 429 ?
        err.responseJSON.error.message :
        "Sorry, An Error Occur, Try Again!"

      $('#status-area').flash_message({
          text: message,
          how: 'append',
          success: false,
      })
    }
  })
}


// Event listeners
$( document ).on('turbolinks:load', () => {

  const validateButton = $('#submit-email-js')
  const emailInput = $('#email-input-js')


  // Email Input listeners.
  emailInput.bind('input', function() {
    validateButton.prop("disabled", !$(this).val())

    $(this).val() ?
      validateButton.removeClass( "disabled" ) :
      validateButton.addClass( "disabled" )
  })

  // Validate button listeners.
  validateButton.click( e => {
    e.preventDefault()
    $('#status-area').empty()

    checkEmail(emailInput.val())
    return false
  })

})
