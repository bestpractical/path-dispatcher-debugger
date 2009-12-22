jQuery(function () {
    jQuery('.path_tester').bind('keyup', function () {
        jQuery.get(
            '/matching_rules',
            this.value,
            function (response) {
                jQuery('#matching_rules').html(response);
            },
            'html'
        );
    });
});

