var PathDispatcherDebugger = {};

PathDispatcherDebugger.recalculate_matching_rules = function (form) {
    var dispatch_type = jQuery("input[@name='dispatch_type']:checked").val();

    jQuery.get(
        '/matching_rules',
        {
            test_path: jQuery('#path_tester').val(),
            dispatch_type: dispatch_type
        },
        PathDispatcherDebugger.update_matching_rules,
        'html'
    );
};

PathDispatcherDebugger.update_matching_rules = function (response) {
    jQuery('#matching_rules').html(response);
};

PathDispatcherDebugger.set_path = function (path) {
    jQuery('#path_tester').val(path);
    PathDispatcherDebugger.recalculate_matching_rules();
};

jQuery(function () {
    jQuery('#path_tester').bind('keyup', PathDispatcherDebugger.recalculate_matching_rules);
    jQuery('.dispatch_type').bind('change', PathDispatcherDebugger.recalculate_matching_rules);
    jQuery('#path_tester').focus();
});

