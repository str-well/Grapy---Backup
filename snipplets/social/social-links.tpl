{% for sn in ['instagram', 'facebook', 'youtube', 'tiktok', 'twitter', 'pinterest'] %}
    {% set sn_url = attribute(store,sn) %}
    {% if sn_url %}
        <a class="{% if circle %}social-icon-rounded{% else %}social-icon{% endif %}" href="{{ sn_url }}" target="_blank" aria-label="{{ sn }} {{ store.name }}">
            {% if sn == "facebook" %}
                {% set social_network = sn ~ '-f' %}
            {% else %}
                {% set social_network = sn %}
            {% endif %}
            {% if circle %}
                {% set icon_class = 'icon-inline icon-lg' %}
            {% else %}
                {% set icon_class = 'icon-inline icon-md' %}
            {% endif %}
            {% include "snipplets/svg/" ~ social_network ~ ".tpl" with {svg_custom_class: icon_class} %}
        </a>
    {% endif %}
{% endfor %}