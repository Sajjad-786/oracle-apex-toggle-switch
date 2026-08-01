------------------------------------------------------------------------
-- S&H Software Solutions
-- Segmented Toggle Switch - Oracle APEX Item Plugin
-- ------------------------------------------------------------------
-- Component : Render procedure for LOV-driven, N-segment toggle switch
-- Version   : 1.1.0
-- Date      : 2026-07-31
-- Author    : S&H Software Solutions
-- License   : MIT License. This code is free and open to use, modify,
--             and redistribute, with or without attribution, for
--             personal or commercial projects.
------------------------------------------------------------------------

PROCEDURE render_toggle_switch (
    p_item       IN            apex_plugin.t_item
  , p_plugin     IN            apex_plugin.t_plugin
  , p_param      IN            apex_plugin.t_item_render_param
  , p_result     IN OUT NOCOPY apex_plugin.t_item_render_result
)
IS
    ------------------------------------------------------------------
    -- Declarations
    ------------------------------------------------------------------
    v_element_id       VARCHAR2(4000) := p_item.name;
    v_current_value    VARCHAR2(4000) := p_param.value;
    v_column_list      apex_plugin_util.t_column_value_list;
    v_total_count      PLS_INTEGER;
    v_is_checked       BOOLEAN;
    v_has_active        BOOLEAN := FALSE;

    -- Custom attributes with fallback to default values
    v_bg_color         VARCHAR2(20) := NVL(p_item.attribute_01, '#eef0f3');
    v_toggle_color     VARCHAR2(20) := NVL(p_item.attribute_02, '#3a6df0');
    v_border_color     VARCHAR2(20) := NVL(p_item.attribute_03, 'rgba(0,0,0,0.08)');
    v_border_thickness NUMBER := LEAST(GREATEST(NVL(p_item.attribute_04, 1), 0), 99);
BEGIN

    ------------------------------------------------------------------
    -- Step 1: Execute LOV query -> fetch display/return value pairs
    ------------------------------------------------------------------
    v_column_list := apex_plugin_util.get_data (
        p_sql_statement  => p_item.lov_definition
      , p_min_columns    => 2
      , p_max_columns    => 2
      , p_component_name => p_item.name
    );

    v_total_count := v_column_list(1).count;

    ------------------------------------------------------------------
    -- Step 2: HTML - open wrapper + hidden input
    ------------------------------------------------------------------
    sys.htp.p (
        '<span class="sh-tgl-switch" id="' || v_element_id || '_SH_SWITCH" data-segments="' || v_total_count || '">'
    );

    apex_plugin_util.print_hidden (
        p_item  => p_item
      , p_param => p_param
    );

    sys.htp.p (
        '<span class="sh-tgl-toggle" style="background:' || apex_escape.html_attribute(v_bg_color)
        || ';border-color:' || apex_escape.html_attribute(v_border_color)
        || ';border-width:' || v_border_thickness || 'px;">'
        || '<span class="sh-tgl-knob" style="background:' || apex_escape.html_attribute(v_toggle_color) || ';"></span>'
    );

    ------------------------------------------------------------------
    -- Step 3: HTML - one segment per display/return value pair
    ------------------------------------------------------------------
    FOR v_index IN 1 .. v_total_count
    LOOP
        v_is_checked := (v_column_list(2)(v_index) = v_current_value);

        IF v_is_checked THEN
            v_has_active := TRUE;
        END IF;

        sys.htp.p (
            '<span class="sh-tgl-segment' || CASE WHEN v_is_checked THEN ' sh-tgl-segment--active' END
            || '" data-value="' || apex_escape.html_attribute(v_column_list(2)(v_index))
            || '" data-index="' || v_index || '" tabindex="0" role="button">'
            || apex_escape.html(v_column_list(1)(v_index)) || '</span>'
        );
    END LOOP;

    ------------------------------------------------------------------
    -- Step 4: HTML - close wrapper
    ------------------------------------------------------------------
    sys.htp.p('</span>'); -- .sh-tgl-toggle
    sys.htp.p('</span>'); -- .sh-tgl-switch

    ------------------------------------------------------------------
    -- Step 5: JS init call
    ------------------------------------------------------------------
    apex_javascript.add_onload_code (
        p_code => 'shToggleSwitch.init("' || v_element_id || '", ' || v_total_count || ');'
    );

    p_result.item_rendered := TRUE;

END render_toggle_switch;
