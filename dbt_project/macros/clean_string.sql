{% macro clean_string(column_name) %}
    nullif(trim(upper({{ column_name }})), '')
{% endmacro %}