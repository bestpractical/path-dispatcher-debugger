var PathDispatcherDebugger = {};

PathDispatcherDebugger.update_matching_rules = function (response) {
    jQuery('#matching_rules').html(response);
};

jQuery(function () {
    jQuery('.path_tester').bind('keyup', function () {
        jQuery.get(
            '/matching_rules',
            { test_path: this.value },
            PathDispatcherDebugger.update_matching_rules,
            'html'
        );
    });
});

