{% macro generate_surrogate_key(columns) %}
    md5(
        concat_ws(
            '||',
            {% for column in columns %}
                coalesce(cast({{ column }} as varchar), 'null_value')
                {% if not loop.last %}, {% endif %}
            {% endfor %}
        )
    )
{% endmacro %}