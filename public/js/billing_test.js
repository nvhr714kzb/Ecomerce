$(function() {
    Stripe.setPublishableKey('pk_test_51HcMVfERGNfztik5KfRfgDp4ZFiCLCVGq7fdtOQsO5jP2rNRgMqgzNxaipVw4b8xVdazY26UfEfCdy14U33q1FRF00tESjY6hb');
    $('#billing-form').submit(function() {
        $('input[type=submit]', this).attr('disabled', 'disable');
        $('input[type=submit]').val('Payment is processing...');
        //Get info
        var error = false;
        var cc_number = $('#cc_number').val();
        var cc_cvv = $('#cc_cvv').val();
        var cc_exp_month = $('#cc_exp_month').val();
        var cc_exp_year = $('#cc_exp_year').val();
        //Validate


        if (!Stripe.validateCVC(cc_cvv)) {
            error = true;
            swal("The CVV number appears to be invalid.")
                // reportError('The CVV number appears to be invalid.');
        } else {}
        if (!Stripe.validateExpiry(cc_exp_month, cc_exp_year)) {
            error = true;
            swal("The expiration date appears to be invalid.")
                // reportError('The expiration date appears to be invalid.');
        }
        if (!Stripe.validateCardNumber(cc_number)) {
            error = true;
            swal("The credit card number appears to be invalid.")
                // reportError('The credit card number appears to be invalid.');

        }
        if (!error) {
            Stripe.createToken({
                number: cc_number,
                cvc: cc_cvv,
                exp_month: cc_exp_month,
                exp_year: cc_exp_year
            }, stripeResponseHandler);
        } else {
            $('input[type=submit]', this).attr('disabled', false);
            $('input[type=submit]').val('Place order');
        }
        return false;
    });

    function stripeResponseHandler(status, response) {

        if (response.error) {
            reportError(response.error.message);
        } else {
            var billing_form = $('#billing-form');
            var token = response.id;
            billing_form.append('<input type="hidden" name = "token" value="' + token + '">');
            billing_form.get(0).submit();

        }
    }

    function reportError(msg) {
        $('#error-span').text(msg);
        $('input[type=submit]').attr('disabled', false);
        $('input[type=submit]').val('Place order');
    }
});