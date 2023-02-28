{% if settings.brands and settings.brands is not empty %}
	<section class="section-brands-home">
		<div class="container">
			<div class="row">
				<div class="col p-0 px-md-3">
					<div class="js-swiper-brands swiper-container">
					    <div class="swiper-wrapper">
					        {% for slide in settings.brands %}
				                <div class="swiper-slide slide-container">
				                	{% if slide.link %}
				                		<a href="{{ slide.link | setting_url }}" title="{{ 'Marca {1} de' | translate(loop.index) }} {{ store.name }}" aria-label="{{ 'Marca {1} de' | translate(loop.index) }} {{ store.name }}">
				                	{% endif %}
				                		<img src="{{ 'images/empty-placeholder.png' | static_url }}" data-src="{{ slide.image | static_url | settings_image_url('large') }}" class="lazyload brand-image" alt="{{ 'Marca {1} de' | translate(loop.index) }} {{ store.name }}">
						            {% if slide.link %}
						            	</a>
						            {% endif %}
				            	</div>
					        {% endfor %}
					    </div>
					</div>
				</div>
			</div>
		</div>
		<div class="js-swiper-brands-prev swiper-button-prev d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-left.tpl" with {svg_custom_class: "icon-inline icon-2x mr-1"} %}</div>
	    <div class="js-swiper-brands-next swiper-button-next d-none d-md-block svg-circle svg-circle-big svg-icon-text{% if settings.icons_solid %} svg-solid{% endif %}">{% include "snipplets/svg/chevron-right.tpl" with {svg_custom_class: "icon-inline icon-2x ml-1"} %}</div>
	</section>
{% endif %}