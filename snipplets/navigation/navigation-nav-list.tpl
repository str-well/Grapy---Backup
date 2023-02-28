{% set desktop_nav = desktop_nav | default(false) %}
{% set mobile_nav = mobile_nav | default(false) %}
{% set subitem = subitem | default(false) %}

{% for item in navigation %}
	{% if item.subitems %}
    	<li class="nav-item {% if desktop_nav %}js-item-subitems-desktop nav-item-desktop {% if not subitem %}nav-dropdown nav-main-item {% endif %}{% endif %}item-with-subitems" data-component="menu.item">
    		<div class="nav-item-container {% if not desktop_nav %}js-nav-list-toggle-accordion{% endif %}">
	            <a class="{% if not desktop_nav %}js-toggle-page-accordion{% endif %} nav-list-link {{ item.current ? 'selected' : '' }}" href="{% if desktop_nav %}{{ item.url }}{% else %}#{% endif %}">{{ item.name }}
		            {% if not subitem or mobile_nav %}
			            <span class="nav-list-arrow transition-soft">
			            	{% include "snipplets/svg/chevron-down.tpl" with {svg_custom_class: "icon-inline icon-md"} %}
			            </span>
			        {% endif %}
	        	</a>
	        </div>
	        {% if desktop_nav %}{% if not subitem %}<div class="js-desktop-dropdown nav-dropdown-content desktop-dropdown">{% endif %}{% endif %}
				<ul class="{% if desktop_nav %}{% if not subitem %}desktop-list-subitems{% endif %}{% else %}js-pages-accordion{% endif %} list-subitems nav-list-accordion" {% if not desktop_nav %}style="display:none;"{% endif %}>
					{% if not desktop_nav and item.isCategory  %}
						<li class="nav-item nav-item-desktop">
							<a class="nav-list-link {{ item.current ? 'selected' : '' }}" href="{{ item.url }}">
								<strong>
									{% if item.isRootCategory %}
										{{ 'Ver todos los productos' | translate }}
									{% else %}
										{{ 'Ver todo en' | translate }} {{ item.name }}
									{% endif %}
								</strong>
						 	</a>
				        </li>
			        {% endif %}
			        {% if mobile_nav %}
			        	{% include 'snipplets/navigation/navigation-nav-list.tpl' with { 'navigation' : item.subitems, 'subitem' : true, 'mobile_nav' : true  } %}
			        {% else %}
						{% include 'snipplets/navigation/navigation-nav-list.tpl' with { 'navigation' : item.subitems, 'subitem' : true  } %}
			        {% endif %}
					
				</ul>
			{% if desktop_nav %}{% if not subitem %}</div>{% endif %}{% endif %}
		</li>
	{% else %}
		<li class="nav-item {% if desktop_nav %}nav-item-desktop {% if not subitem %}nav-main-item{% endif %}{% endif %}" data-component="menu.item">
        	<a class="nav-list-link {{ item.current ? 'selected' : '' }}" href="{{ item.url | setting_url }}">{{ item.name }}</a>
        </li>
	{% endif %}
{% endfor %}