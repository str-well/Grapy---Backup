{#/*============================================================================
    #Specific store JS functions: product variants, cart, shipping, etc
==============================================================================*/#}

{#/*============================================================================

	Table of Contents

	#Lazy load
	#Notifications and tooltips
	#Modals
	#Tabs
	#Cards
	#Accordions
	#Header and nav
		// Header
		// Utilities
		// Nav
		// Search suggestions
	#Sliders
		// Home slider
		// Products slider
		// Brand slider
		// Product related
		// Banner services slider
	#Social
		// Youtube or Vimeo video
		// Instagram feed
	#Product grid
		// Secondary image on mouseover
		// Fixed category controls
		// Filters
		// Sort by
		// Infinite scroll
		// Quickshop
	#Product detail functions
		// Installments
		// Change Variant
		// Submit to contact form
		// Product labels on variant change
		// Color and size variants change
		// Custom mobile variants change
		// Submit to contact
		// Product slider
		// Pinterest sharing
		// Add to cart
		// Product quantity
	#Cart
		// Toggle cart 
		// Add to cart
		// Cart quantitiy changes
		// Empty cart alert
	#Shipping calculator
		// Select and save shipping function
		// Calculate shipping function
		// Calculate shipping by submit
		// Shipping and branch click
		// Select shipping first option on results
		// Toggle branches link
		// Toggle more shipping options
		// Calculate shipping on page load
		// Shipping provinces
		// Change store country
	#Forms
	#Footer
	#Empty placeholders

==============================================================================*/#}

// Move to our_content
window.urls = {
    "shippingUrl": "{{ store.shipping_calculator_url | escape('js') }}"
}

{#/*============================================================================
  #Lazy load
==============================================================================*/ #}

document.addEventListener('lazybeforeunveil', function(e){
    if ((e.target.parentElement) && (e.target.nextElementSibling)) {
        var parent = e.target.parentElement;
        var sibling = e.target.nextElementSibling;
        if (sibling.classList.contains('js-lazy-loading-preloader')) {
            sibling.style.display = 'none';
            parent.style.display = 'block';
        }
    }
});


window.lazySizesConfig = window.lazySizesConfig || {};
lazySizesConfig.hFac = 0.4;


DOMContentLoaded.addEventOrExecute(() => {

	{#/*============================================================================
	  #Notifications and tooltips
	==============================================================================*/ #}

    {# /* // Close notification and tooltip */ #}

    jQueryNuvem(".js-notification-close, .js-tooltip-close").on( "click", function(e) {
        e.preventDefault();
        jQueryNuvem(e.currentTarget).closest(".js-notification, .js-tooltip").hide();
        jQueryNuvem(".js-quick-login-badge").hide();
    });

    {# Notifications variables #}

    var $notification_order_cancellation = jQueryNuvem(".js-notification-order-cancellation");
    var $notification_status_page = jQueryNuvem(".js-notification-status-page");
    var $quick_login_notification = jQueryNuvem(".js-notification-quick-login");
    var $fixed_bottom_button = jQueryNuvem(".js-btn-fixed-bottom");
    
	{# /* // Follow order status notification */ #}
    
    if ($notification_status_page.length > 0){
        if (LS.shouldShowOrderStatusNotification($notification_status_page.data('url'))){
            $notification_status_page.show();
        };
        jQueryNuvem(".js-notification-status-page-close").on( "click", function(e) {
            e.preventDefault();
            LS.dontShowOrderStatusNotificationAgain($notification_status_page.data('url'));
        });
    }

    {# /* // Order cancellation notification */ #}

    if ($notification_order_cancellation.length > 0){
        if (LS.shouldShowOrderCancellationNotification($notification_order_cancellation.data('url'))){

            {% if not params.preview %}
                {# Show order cancellation notification only if cookie banner is not visible #}

                if (window.cookieNotificationService.isAcknowledged()) {
            {% endif %}
                    $notification_order_cancellation.show();
            {% if not params.preview %}
                }
            {% endif %}
            
            $fixed_bottom_button.css("marginBottom", "40px");

            {% if store.country == 'AR' and template == 'home' and status_page_url %}
                {# If cancellation order notification move quick login #}
                $quick_login_notification.css("bottom" , "40px");
            {% endif %}
        };
        jQueryNuvem(".js-notification-order-cancellation-close").on( "click", function(e) {
            e.preventDefault();
            LS.dontShowOrderCancellationNotification($notification_order_cancellation.data('url'));
            $quick_login_notification.css("bottom" , "0px");
        });
    }

    {# /* // Cart notification: Dismiss notification */ #}

    jQueryNuvem(".js-cart-notification-close").on("click", function(){
        jQueryNuvem(".js-alert-added-to-cart").removeClass("notification-visible").addClass("notification-hidden");
        setTimeout(function(){
            jQueryNuvem('.js-cart-notification-item-img').attr('src', '');
            jQueryNuvem(".js-alert-added-to-cart").hide();
        },2000);
    });

    {% if not settings.head_fix %}

        {# /* // Add to cart notification on non fixed header */ #}

        var topBarHeight = jQueryNuvem(".js-topbar").outerHeight();
        var logoBarHeight = jQueryNuvem(".js-nav-logo-bar").outerHeight();
        var searchBarHeight = jQueryNuvem(".js-search-container").outerHeight();
        if (window.innerWidth > 768) {
            var fixedNotificationPosition = topBarHeight + logoBarHeight; 
        }else{
            var fixedNotificationPosition = logoBarHeight - searchBarHeight; 
        }
        var $addedToCartNotification = jQueryNuvem(".js-alert-added-to-cart");
        var $addedToCartNotificationArrow = $addedToCartNotification.find(".js-cart-notification-arrow-up");

        $addedToCartNotification.css("top", fixedNotificationPosition.toString() + 'px').css("marginTop", "-10px");

        !function () {
            window.addEventListener("scroll", function (e) {
                if (window.pageYOffset == 0) {
                    $addedToCartNotification.css("top" , fixedNotificationPosition.toString() + 'px');
                    $addedToCartNotificationArrow.css("visibility" , "visible");
                } else {
                    $addedToCartNotification.css("top" , "20px");
                    $addedToCartNotificationArrow.css("visibility" , "hidden");
                }
            });
        }();

    {% endif %}

    {# /* // Quick Login notification */ #}

    {% if not customer and template == 'home' %}

        {# Show quick login messages if it is returning customer #}

        setTimeout(function(){
            if (cookieService.get('returning_customer') && LS.shouldShowQuickLoginNotification()) {
                {% if store.country == 'AR' %}
                    jQueryNuvem(".js-quick-login-badge").fadeIn();
                    jQueryNuvem(".js-login-tooltip").show();
                    jQueryNuvem(".js-login-tooltip-desktop").show().addClass("visible");
                {% else %}
                    $quick_login_notification.fadeIn();
                {% endif %}
                return;
            }
            
        },500);

    {% endif %}

    {# Dismiss quick login notifications #}

    jQueryNuvem(".js-dismiss-quicklogin").on( "click", function(e) {
        LS.dontShowQuickLoginNotification();
    });


    setTimeout(function(){
        jQueryNuvem(".js-quick-login-success").fadeOut();
    },8000);

    {% if not params.preview %}

        {# /* // Cookie banner notification */ #}

        restoreNotifications = function(){

            // Whatsapp button position
            if (window.innerWidth < 768) {
                $fixed_bottom_button.css("marginBottom", "10px");
            }

            {# Restore notifications when Cookie Banner is closed #}

            var show_order_cancellation = ($notification_order_cancellation.length > 0) && (LS.shouldShowOrderCancellationNotification($notification_order_cancellation.data('url')));

            {% if store.country == 'AR' %}
                {# Order cancellation #}
                if (show_order_cancellation){
                    $notification_order_cancellation.show();
                    $fixed_bottom_button.css("marginBottom", "40px");
                }
            {% endif %}
        };

        if (!window.cookieNotificationService.isAcknowledged()) {
            jQueryNuvem(".js-notification-cookie-banner").show();

            {# Whatsapp button position #}
            if (window.innerWidth < 768) {
                $fixed_bottom_button.css("marginBottom", "120px");
            }
        }

        jQueryNuvem(".js-acknowledge-cookies").on( "click", function(e) {
            window.cookieNotificationService.acknowledge();
            restoreNotifications();
        });

    {% endif %}

    {#/*============================================================================
      #Modals
    ==============================================================================*/ #}

    {# Full screen mobile modals back events #}

    if (window.innerWidth < 768) {

        {# Clean url hash function #}

        cleanURLHash = function(){
            const uri = window.location.toString();
            const clean_uri = uri.substring(0, uri.indexOf("#"));
            window.history.replaceState({}, document.title, clean_uri);
        };

        {# Go back 1 step on browser history #}

        goBackBrowser = function(){
            cleanURLHash();
            history.back();
        };

        {# Clean url hash on page load: All modals should be closed on load #}

        if(window.location.href.indexOf("modal-fullscreen") > -1) {
            cleanURLHash();
        }

        {# Open full screen modal and url hash #}

        jQueryNuvem(document).on("click", ".js-fullscreen-modal-open", function(e) {
            e.preventDefault();
            var modal_url_hash = jQueryNuvem(this).data("modalUrl");
            window.location.hash = modal_url_hash;
        });

        {# Close full screen modal: Remove url hash #}

        jQueryNuvem(document).on("click", ".js-fullscreen-modal-close", function(e) {
            e.preventDefault();
            goBackBrowser();
        });

        {# Hide panels or modals on browser backbutton #}

        window.onhashchange = function() {
            if(window.location.href.indexOf("modal-fullscreen") <= -1) {

                {# Close opened modal #}

                if(jQueryNuvem(".js-fullscreen-modal").hasClass("modal-show")){

                    {# Remove body lock only if a single modal is visible on screen #}

                    if(jQueryNuvem(".js-modal.modal-show").length == 1){
                        jQueryNuvem("body").removeClass("overflow-none");
                    }
                    var $opened_modal = jQueryNuvem(".js-fullscreen-modal.modal-show");
                    var $opened_modal_overlay = $opened_modal.prev();

                    $opened_modal.removeClass("modal-show");
                    setTimeout(() => $opened_modal.hide(), 500);
                    $opened_modal_overlay.fadeOut(500);

                }
            }
        }

    }

    jQueryNuvem(document).on("click", ".js-modal-open", function(e) {
        e.preventDefault(); 
        var modal_id = jQueryNuvem(this).data('toggle');
        var $overlay_id = jQueryNuvem('.js-modal-overlay[data-modal-id="' + modal_id + '"]');
        if (jQueryNuvem(modal_id).hasClass("modal-show")) {
            let modal = jQueryNuvem(modal_id).removeClass("modal-show");
            setTimeout(() => modal.hide(), 500);
        } else {
            {# Lock body scroll if there is no modal visible on screen #}
            
            if(!jQueryNuvem(".js-modal.modal-show").length){
                jQueryNuvem("body").addClass("overflow-none");
            }
            $overlay_id.fadeIn(400);
            jQueryNuvem(modal_id).detach().appendTo("body");
            $overlay_id.detach().insertBefore(modal_id);
            jQueryNuvem(modal_id).show().addClass("modal-show");
        }             
    });

    jQueryNuvem(document).on("click", ".js-modal-close", function(e) {
        e.preventDefault();  

        {# Remove body lock only if a single modal is visible on screen #}

        if(jQueryNuvem(".js-modal.modal-show").length == 1){
            jQueryNuvem("body").removeClass("overflow-none");
        }
        var $modal = jQueryNuvem(this).closest(".js-modal");
        var modal_id = $modal.attr('id');
        var $overlay_id = jQueryNuvem('.js-modal-overlay[data-modal-id="#' + modal_id + '"]');
        $modal.removeClass("modal-show");
        setTimeout(() => $modal.hide(), 500);
        $overlay_id.fadeOut(500);
        
        {# Close full screen modal: Remove url hash #}

        if ((window.innerWidth < 768) && (jQueryNuvem(this).hasClass(".js-fullscreen-modal-close"))) {
            goBackBrowser();
        }
    });

    jQueryNuvem(document).on("click", ".js-modal-overlay", function(e) {
        e.preventDefault();

        {# Remove body lock only if a single modal is visible on screen #}

        if(jQueryNuvem(".js-modal.modal-show").length == 1){
            jQueryNuvem("body").removeClass("overflow-none");
        }

        var modal_id = jQueryNuvem(this).data('modalId');
        let modal = jQueryNuvem(modal_id).removeClass("modal-show");
        setTimeout(() => modal.hide(), 500);
        jQueryNuvem(this).fadeOut(500);
    });

    {% if template == 'home' and settings.home_promotional_popup %}

        {# /* // Home popup and newsletter popup */ #}

        jQueryNuvem('#news-popup-form').on("submit", function () {
            jQueryNuvem(".js-news-spinner").show();
            jQueryNuvem(".js-news-send, .js-news-popup-submit").hide();
            jQueryNuvem(".js-news-popup-submit").prop("disabled", true);
        });

        LS.newsletter('#news-popup-form-container', '#home-modal', '{{ store.contact_url | escape('js') }}', function (response) {
            jQueryNuvem(".js-news-spinner").hide();
            jQueryNuvem(".js-news-send, .js-news-popup-submit").show();
            var selector_to_use = response.success ? '.js-news-popup-success' : '.js-news-popup-failed';
            let newPopupAlert = jQueryNuvem(this).find(selector_to_use).fadeIn(100);
            setTimeout(() => newPopupAlert.fadeOut(500), 4000);
            if (jQueryNuvem(".js-news-popup-success").css("display") == "block") {
                setTimeout(function () {
                    jQueryNuvem('[data-modal-id="#home-modal"]').fadeOut(500);
                    let homeModal = jQueryNuvem("#home-modal").removeClass("modal-show");
                    setTimeout(() => homeModal.hide(), 500);
                }, 2500);
            }
            jQueryNuvem(".js-news-popup-submit").prop("disabled", false);
        });


        var callback_show = function(){
            jQueryNuvem('.js-modal-overlay[data-modal-id="#home-modal"]').fadeIn(500);
            jQueryNuvem("#home-modal").detach().appendTo("body").show().addClass("modal-show");
        }
        var callback_hide = function(){
            jQueryNuvem('.js-modal-overlay[data-modal-id="#home-modal"]').fadeOut(500);
            let homeModal = jQueryNuvem("#home-modal").removeClass("modal-show");
            setTimeout(() => homeModal.hide(), 500);
        }
        LS.homePopup({
            selector: "#home-modal",
            timeout: 10000
        }, callback_hide, callback_show);

    {% endif %}

    {#/*============================================================================
      #Tabs
    ==============================================================================*/ #}

    var $tab_open = jQueryNuvem('.js-tab');

    $tab_open.on("click", function (e) {
        e.preventDefault(); 
        var $tab_container = jQueryNuvem(e.currentTarget).closest(".js-tab-container");
        $tab_container.find(".js-tab, .js-tab-panel").removeClass("active");
        jQueryNuvem(e.currentTarget).addClass("active");
        var tab_to_show = jQueryNuvem(e.currentTarget).find(".js-tab-link").attr("href");
        $tab_container.find(tab_to_show).addClass("active");    
    });

    {#/*============================================================================
      #Cards
    ==============================================================================*/ #}
    jQueryNuvem(document).on("click", ".js-card-collapse-toggle", function(e) {
        e.preventDefault();
        jQueryNuvem(this).toggleClass('active');
        jQueryNuvem(this).closest(".js-card-collapse").toggleClass('active');
    });

    {#/*============================================================================
      #Accordions
    ==============================================================================*/ #}
    jQueryNuvem(document).on("click", ".js-accordion-toggle", function(e) {
        e.preventDefault();
        if(jQueryNuvem(this).hasClass("js-accordion-show-only")){
            jQueryNuvem(this).hide();
        }else{
            jQueryNuvem(this).find(".js-accordion-toggle-inactive").toggle();
            jQueryNuvem(this).find(".js-accordion-toggle-active").toggle();
        }
        jQueryNuvem(this).prev(".js-accordion-container").slideToggle();
    });

	{#/*============================================================================
      #Header and nav
    ==============================================================================*/ #}

    {# /* // Header */ #}

        {% if template == 'home' and settings.head_transparent %}
            {% if settings.slider and settings.slider is not empty %}        

                var $swiper_height = window.innerHeight - 100;
                
                document.addEventListener("scroll", function() {
                    if (document.documentElement.scrollTop > $swiper_height ) {
                        jQueryNuvem(".js-head-main").removeClass("head-transparent");
                    } else {
                        jQueryNuvem(".js-head-main").addClass("head-transparent");
                    }
                });

            {% endif %}
        {% endif %}

        {# /* // Nav offset */ #}

        function applyOffset(selector){

            // Get nav height on load
            if (window.innerWidth > 768) {
                var head_height = jQueryNuvem(".js-head-main").height();
                jQueryNuvem(selector).css("paddingTop", head_height.toString() + 'px');
            }else{

                {# On mobile there is no top padding due to position sticky CSS #}
                var head_height = 0;
            }

            // Apply offset nav height on load
            
            window.addEventListener("resize", function() {

                // Get nav height on resize
                var head_height = jQueryNuvem(".js-head-main").height();

                // Apply offset on resize
                if (window.innerWidth > 768) {
                    jQueryNuvem(selector).css("paddingTop", head_height.toString() + 'px');
                }else{

                    {# On mobile there is no top padding due to position sticky CSS #}
                    jQueryNuvem(selector).css("paddingTop", "0px");
                }
            });
        }


    {% if settings.head_fix %}

        applyOffset(".js-head-offset");

        {# Show and hide mobile nav on scroll #}

            var didScroll;
            var lastScrollTop = 0;
            var delta = 30;
            var navbarHeight = jQueryNuvem(".js-head-main").outerHeight();
            var topbarHeight = jQueryNuvem(".js-topbar").outerHeight();

            window.addEventListener("scroll", function(event){
                didScroll = true;
            });

            setInterval(function() {
                if (didScroll) {
                    hasScrolled();
                    didScroll = false;
                }
            }, 250);

            function hasScrolled() {
                var st = window.pageYOffset;
                
                // Make sure they scroll more than delta
                if(Math.abs(lastScrollTop - st) <= delta)
                    return;
                
                // If they scrolled down and are past the navbar, add class .move-up.
                if (st > lastScrollTop && st > navbarHeight){
                    jQueryNuvem(".js-head-main").addClass('compress').css('top', (- topbarHeight).toString() + 'px' );
                    if (window.innerWidth < 768) {
                    	$category_controls.css('top', (navbarHeight - topbarHeight - 2).toString() + 'px' );
                	}
                    
                } else {
                    // Scroll Up
                    let documentHeight = Math.max(
                        document.body.scrollHeight,
                        document.body.offsetHeight,
                        document.documentElement.clientHeight,
                        document.documentElement.scrollHeight,
                        document.documentElement.offsetHeight
                    );

                    if(st + window.innerHeight < documentHeight) {
                        jQueryNuvem(".js-head-main").removeClass('compress').css('top', "0px" );
                        if (window.innerWidth < 768) {
                        	$category_controls.css('top', navbarHeight.toString() + 'px' );
                    	}
                    }
                }

                lastScrollTop = st;
            }
            
    {% endif %}      


    {# /* // Utilities */ #}

        jQueryNuvem(".js-utilities-item").on("mouseenter", function (e) {
            e.preventDefault();
            jQueryNuvem(e.currentTarget).toggleClass("active");
        }).on("mouseleave", function(e) {
            e.preventDefault();
            jQueryNuvem(e.currentTarget).toggleClass("active");
        });


    {# /* // Nav */ #}

        var $top_nav = jQueryNuvem(".js-mobile-nav");
        var $page_main_content = jQueryNuvem(".js-main-content");
        var $search_backdrop = jQueryNuvem(".js-search-backdrop");

        $top_nav.addClass("move-down").removeClass("move-up");


        {# Nav subitems #}

        jQueryNuvem(".js-toggle-page-accordion").on("click", function (e) {
            e.preventDefault();
            jQueryNuvem(e.currentTarget).toggleClass("active").closest(".js-nav-list-toggle-accordion").next(".js-pages-accordion").slideToggle(300);
        });

        var win_height = window.innerHeight;
        var head_height = jQueryNuvem(".js-head-main").height();

        jQueryNuvem(".js-desktop-dropdown").css('maxHeight', (win_height - head_height - 50).toString() + 'px');

        jQueryNuvem(".js-item-subitems-desktop").on("mouseenter", function (e) {
            jQueryNuvem(e.currentTarget).addClass("active");
        }).on("mouseleave", function(e) {
            jQueryNuvem(e.currentTarget).removeClass("active");
        });

        jQueryNuvem(".nav-main-item").on("mouseenter", function (e) {
            jQueryNuvem('.nav-desktop-list').children(".selected").removeClass("selected");

            jQueryNuvem(e.currentTarget).addClass("selected");
        });



        {# Focus search #}

        jQueryNuvem(".js-toggle-search").on("click", function (e) {
            e.preventDefault;
            jQueryNuvem(".js-search-input").trigger('focus');
        });


    {# /* // Search suggestions */ #}

        LS.search(jQueryNuvem(".js-search-input"), function (html, count) {
            $search_suggests = jQueryNuvem(this).closest(".js-search-container").next(".js-search-suggest");
            if (count > 0) {
                $search_suggests.html(html).show();
            } else {
                $search_suggests.hide();
            }
            if (jQueryNuvem(this).val().length == 0) {
                $search_suggests.hide();
            }
        }, {
            snipplet: 'header/header-search-results.tpl'
        });

        if (window.innerWidth > 768) {

            {# Hide search suggestions if user click outside results #}

            jQueryNuvem("body").on("click", function () {
                jQueryNuvem(".js-search-suggest").hide();
            });

            {# Maintain search suggestions visibility if user click on links inside #}

            jQueryNuvem(document).on("click", ".js-search-suggest a", function () {
                jQueryNuvem(".js-search-suggest").show();
            });
        }

        jQueryNuvem(".js-search-suggest").on("click", ".js-search-suggest-all-link", function (e) {
            e.preventDefault();
            $this_closest_form = jQueryNuvem(this).closest(".js-search-suggest").prev(".js-search-form");
            $this_closest_form.submit();
        });


	{#/*============================================================================
	  #Sliders
	==============================================================================*/ #}

	{% if template == 'home' %}

		{# /* // Home slider */ #}


        var width = window.innerWidth;
        if (width > 767) {
            var slider_autoplay = {delay: 6000,};
        } else {
            var slider_autoplay = false;
        }

        window.homeSlider = {
            getAutoRotation: function() {
                return slider_autoplay;
            },
            updateSlides: function(slides) {
                homeSwiper.removeAllSlides();
                slides.forEach(function(aSlide){
                    homeSwiper.appendSlide(
                        '<div class="swiper-slide slide-container">' +
                            (aSlide.link ? '<a href="' + aSlide.link + '">' : '' ) +
                                '<img src="' + aSlide.src + '" class="slider-image"/>' +
                                '<div class="swiper-text swiper-' + aSlide.color + '">' +
                                    (aSlide.description ? '<div class="swiper-description mb-3">' + aSlide.description + '</div>' : '' ) +
                                    (aSlide.title ? '<div class="swiper-title">' + aSlide.title + '</div>' : '' ) +
                                    (aSlide.button && aSlide.link ? '<div class="btn btn-primary btn-small swiper-btn mt-4 px-4">' + aSlide.button + '</div>' : '' ) +
                                '</div>' +
                            (aSlide.link ? '</a>' : '' ) +
                        '</div>'
                    );
                });

                {% set has_mobile_slider = settings.toggle_slider_mobile and settings.slider_mobile and settings.slider_mobile is not empty %}

                if(!slides.length){
                    jQueryNuvem(".js-home-main-slider-container").addClass("hidden");
                    jQueryNuvem(".js-home-empty-slider-container").removeClass("hidden");
                    jQueryNuvem(".js-home-mobile-slider-visibility").removeClass("d-md-none");
                    {% if has_mobile_slider %}
                        jQueryNuvem(".js-home-main-slider-visibility").removeClass("d-none d-md-block");
                        homeMobileSwiper.update();
                    {% endif %}
                }else{
                    jQueryNuvem(".js-home-main-slider-container").removeClass("hidden");
                    jQueryNuvem(".js-home-empty-slider-container").addClass("hidden");
                    jQueryNuvem(".js-home-mobile-slider-visibility").addClass("d-md-none");
                    {% if has_mobile_slider %}
                        jQueryNuvem(".js-home-main-slider-visibility").addClass("d-none d-md-block");
                    {% endif %}
                }
            },
            changeAutoRotation: function(){

            },
        };

        var preloadImagesValue = false;
        var lazyValue = true;
        var loopValue = true;
        var paginationClickableValue = true;

        var homeSwiper = null;
        createSwiper(
            '.js-home-slider', {
                preloadImages: preloadImagesValue,
                lazy: lazyValue,
                {% if settings.slider | length > 1 %}
                    loop: loopValue,
                {% endif %}
                autoplay: slider_autoplay,
                pagination: {
                    el: '.js-swiper-home-pagination',
                    clickable: paginationClickableValue,
                },
                navigation: {
                    nextEl: '.js-swiper-home-next',
                    prevEl: '.js-swiper-home-prev',
                },
            },
            function(swiperInstance) {
                homeSwiper = swiperInstance;
            }
        );

        var homeMobileSwiper = null;
        createSwiper(
            '.js-home-slider-mobile', {
                preloadImages: preloadImagesValue,
                lazy: lazyValue,
                {% if settings.slider_mobile | length > 1 %}
                    loop: loopValue,
                {% endif %}
                autoplay: slider_autoplay,
                pagination: {
                    el: '.js-swiper-home-pagination-mobile',
                    clickable: paginationClickableValue,
                },
                navigation: {
                    nextEl: '.js-swiper-home-next-mobile',
                    prevEl: '.js-swiper-home-prev-mobile',
                },
            },
            function(swiperInstance) {
                homeMobileSwiper = swiperInstance;
            }
        );

        {% if settings.slider | length == 1 %}
            jQueryNuvem('.js-swiper-home .swiper-wrapper').addClass( "disabled" );
            jQueryNuvem('.js-swiper-home-pagination, .js-swiper-home-prev, .js-swiper-home-next').remove();
        {% endif %}

        {% set columns = settings.grid_columns %}


        {# /* // Products slider */ #}

        {% set has_featured_products_slider = sections.primary.products and settings.featured_products_format != 'grid' %}
        {% set has_new_products_slider = sections.new.products and settings.new_products_format != 'grid' %}
        {% set has_sale_products_slider = sections.sale.products and settings.sale_products_format != 'grid' %}

        {% if has_featured_products_slider or has_new_products_slider or has_sale_products_slider %}

            var lazyVal = true;
            var watchOverflowVal = true;
            var centerInsufficientSlidesVal = true;
            var slidesPerViewDesktopVal = {% if columns == 2 %}4{% else %}3{% endif %};
            var slidesPerViewMobileVal = 1.5;

            {% if has_featured_products_slider %}

                window.swiperLoader('.js-swiper-featured', {
                    lazy: lazyVal,
                    watchOverflow: watchOverflowVal,
                    centerInsufficientSlides: centerInsufficientSlidesVal,
                    threshold: 5,
                    watchSlideProgress: true,
                    watchSlidesVisibility: true,
                    slideVisibleClass: 'js-swiper-slide-visible',
                {% if sections.primary.products | length > 3 %}
                    loop: true,
                {% endif %}
                    navigation: {
                        nextEl: '.js-swiper-featured-next',
                        prevEl: '.js-swiper-featured-prev',
                    },
                    slidesPerView: slidesPerViewMobileVal,
                    breakpoints: {
                        768: {
                            slidesPerView: slidesPerViewDesktopVal,
                        }
                    }
                });

            {% endif %}

            {% if has_new_products_slider %}

                window.swiperLoader('.js-swiper-new', {
                    lazy: lazyVal,
                    watchOverflow: watchOverflowVal,
                    centerInsufficientSlides: centerInsufficientSlidesVal,
                    threshold: 5,
                    watchSlideProgress: true,
                    watchSlidesVisibility: true,
                    slideVisibleClass: 'js-swiper-slide-visible',
                {% if sections.new.products | length > 3 %}
                    loop: true,
                {% endif %}
                    navigation: {
                        nextEl: '.js-swiper-new-next',
                        prevEl: '.js-swiper-new-prev',
                    },
                    slidesPerView: slidesPerViewMobileVal,
                    breakpoints: {
                        768: {
                            slidesPerView: slidesPerViewDesktopVal,
                        }
                    }
                });

            {% endif %}

            {% if has_sale_products_slider %}

                window.swiperLoader('.js-swiper-sale', {
                    lazy: lazyVal,
                    watchOverflow: watchOverflowVal,
                    centerInsufficientSlides: centerInsufficientSlidesVal,
                    threshold: 5,
                    watchSlideProgress: true,
                    watchSlidesVisibility: true,
                    slideVisibleClass: 'js-swiper-slide-visible',
                {% if sections.sale.products | length > 3 %}
                    loop: true,
                {% endif %}
                    navigation: {
                        nextEl: '.js-swiper-sale-next',
                        prevEl: '.js-swiper-sale-prev',
                    },
                    slidesPerView: slidesPerViewMobileVal,
                    breakpoints: {
                        768: {
                            slidesPerView: slidesPerViewDesktopVal,
                        }
                    }
                });

            {% endif %}

        {% endif %}

        {# /* // Home demo products slider */ #}

        createSwiper('.js-swiper-featured-demo', {
            lazy: true,
            loop: true,
            watchOverflow: true,
            centerInsufficientSlides: true,
            slidesPerView: 1.5,
            navigation: {
                nextEl: '.js-swiper-featured-demo-next',
                prevEl: '.js-swiper-featured-demo-prev',
            },
            breakpoints: {
                640: {
                    slidesPerView: {% if columns == 2 %}4{% else %}3{% endif %},
                }
            }
        });


        {# /* // Brands slider */ #}

        {% if settings.brands and settings.brands is not empty %}

            createSwiper('.js-swiper-brands', {
                lazy: true,
                {% if settings.brands | length > 4 %}
                    loop: true,
                {% endif %}
                watchOverflow: true,
                centerInsufficientSlides: true,
                spaceBetween: 30,
                slidesPerView: 1.5,
                navigation: {
                    nextEl: '.js-swiper-brands-next',
                    prevEl: '.js-swiper-brands-prev',
                },
                breakpoints: {
                    640: {
                        slidesPerView: 5,
                    }
                }
            });

        {% endif %}

	{% endif %}

    {% if template == 'product' %}

        {# /* // Product Related */ #}

        {% set related_products_ids = product.metafields.related_products.related_products_ids %}
        {% if related_products_ids %}
            {% set related_products = related_products_ids | get_products %}
            {% set show = (related_products | length > 0) %}
        {% endif %}
        {% if not show %}
            {% set related_products = category.products | shuffle | take(8) %}
            {% set show = (related_products | length > 1) %}
        {% endif %}

        {% set columns = settings.grid_columns %}
         createSwiper('.js-swiper-related', {
            lazy: true,
            {% if related_products | length > 3 %}
                loop: true,
            {% endif %}
            watchOverflow: true,
            centerInsufficientSlides: true,
            threshold: 5,
            watchSlideProgress: true,
            watchSlidesVisibility: true,
            slideVisibleClass: 'js-swiper-slide-visible',
            slidesPerView: 1.5,
            navigation: {
                nextEl: '.js-swiper-related-next',
                prevEl: '.js-swiper-related-prev',
            },
            breakpoints: {
                640: {
                    slidesPerView: {% if columns == 2 %}4{% else %}3{% endif %},
                }
            }
        });

    {% endif %}



	{% set has_banner_services = settings.banner_services %}

	{% if has_banner_services %}

		{# /* // Banner services slider */ #}

        var width = window.innerWidth;
        if (width < 767) {
            createSwiper('.js-informative-banners', {
                slidesPerView: 1.2,
                watchOverflow: true,
                centerInsufficientSlides: true,
                pagination: {
                    el: '.js-informative-banners-pagination',
                    clickable: true,
                },
                breakpoints: {
                    640: {
                        slidesPerView: 3,
                    }
                }
            });
        }

    {% endif %}

	{#/*============================================================================
	  #Social
	==============================================================================*/ #}

    {% if template == 'home' %}
        {% set video_url = settings.video_embed %}
    {% elseif template == 'product' and product.video_url %}
        {% set video_url = product.video_url %}
    {% endif %}

	{% if video_url %}

        {# /* // Youtube or Vimeo video for home or each product */ #}

        LS.loadVideo('{{ video_url }}');

    {% endif %}

	{#/*============================================================================
	  #Product grid
	==============================================================================*/ #}

    {# /* // Secondary image on mouseover */ #}
    
    {% if settings.product_hover %}
        if (window.innerWidth > 767) {
            jQueryNuvem(document).on("mouseover", ".js-item-with-secondary-image:not(.item-with-two-images)", function(e) {
                var secondary_image_to_show = jQueryNuvem(this).find(".js-item-image-secondary");
                secondary_image_to_show.show();
                secondary_image_to_show.on('lazyloaded', function(e){
                    jQueryNuvem(e.currentTarget).closest(".js-item-with-secondary-image").addClass("item-with-two-images");
                });
            });
        }
    {% endif %}

    var $category_controls = jQueryNuvem(".js-category-controls");
    var mobile_nav_height = jQueryNuvem(".js-head-main").innerHeight();

	{% if template == 'category' %}

        {# /* // Fixed category controls */ #}

        if (window.innerWidth < 768) {

            {% if settings.head_fix %}
                $category_controls.css("top" , mobile_nav_height.toString() + 'px');
            {% else %}
                jQueryNuvem(".js-category-controls").css("top" , "0px");
            {% endif %}

            {# Detect if category controls are sticky and add css #}

            var observer = new IntersectionObserver(function(entries) {
                if(entries[0].intersectionRatio === 0)
                    jQueryNuvem(".js-category-controls").addClass("is-sticky");
                else if(entries[0].intersectionRatio === 1)
                    jQueryNuvem(".js-category-controls").removeClass("is-sticky");
                }, { threshold: [0,1]
            });

            observer.observe(document.querySelector(".js-category-controls-prev"));
        }

        {# /* // Filters */ #}

        jQueryNuvem(document).on("click", ".js-apply-filter, .js-remove-filter", function(e) {
            e.preventDefault();
            var filter_name = jQueryNuvem(this).data('filterName');
            var filter_value = jQueryNuvem(this).attr('data-filter-value');
            if(jQueryNuvem(this).hasClass("js-apply-filter")){
                jQueryNuvem(this).find("[type=checkbox]").prop("checked", true);
                LS.urlAddParam(
                    filter_name,
                    filter_value,
                    true
                );
            }else{
                jQueryNuvem(this).find("[type=checkbox]").prop("checked", false);
                LS.urlRemoveParam(
                    filter_name,
                    filter_value
                );
            }

            {# Toggle class to avoid adding double parameters in case of double click and show applying changes feedback #}

            if (jQueryNuvem(this).hasClass("js-filter-checkbox")){
                if (window.innerWidth < 768) {
                    jQueryNuvem(".js-filters-overlay").show();
                    if(jQueryNuvem(this).hasClass("js-apply-filter")){
                        jQueryNuvem(".js-applying-filter").show();
                    }else{
                        jQueryNuvem(".js-removing-filter").show();
                    }
                }
                jQueryNuvem(this).toggleClass("js-apply-filter js-remove-filter");
            }
        });

        jQueryNuvem(document).on("click", ".js-remove-all-filters", function(e) {
            e.preventDefault();
            LS.urlRemoveAllParams();
        });

		{# /* // Sort by */ #}

        jQueryNuvem('.js-sort-by').on("change", function (e) {
            var params = LS.urlParams;
            params['sort_by'] = jQueryNuvem(e.currentTarget).val();
            var sort_params_array = [];
            for (var key in params) {
                if (!['results_only', 'page'].includes(key)) {
                    sort_params_array.push(key + '=' + params[key]);
                }
            }
            var sort_params = sort_params_array.join('&');
            window.location = window.location.pathname + '?' + sort_params;
        });

	{% endif %}

    {% if template == 'category' or template == 'search' %}

        !function() {

        	{# /* // Infinite scroll */ #}

            {% if pages.current == 1 and not pages.is_last %}
                LS.hybridScroll({
                    productGridSelector: '.js-product-table',
                    spinnerSelector: '#js-infinite-scroll-spinner',
                    loadMoreButtonSelector: '.js-load-more',
                    hideWhileScrollingSelector: ".js-hide-footer-while-scrolling",
                    productsBeforeLoadMoreButton: 50,
                    productsPerPage: 12
                });
            {% endif %}
        }();

	{% endif %}

    {% if settings.quick_shop %}

        {# /* // Quickshop */ #}

        jQueryNuvem(document).on("click", ".js-item-buy-open", function(e) {
            e.preventDefault();
            jQueryNuvem(this).toggleClass("btn-primary btn-secondary");
            jQueryNuvem(this).closest(".js-quickshop-container").find(".js-item-variants").fadeToggle(300);

            var elementTop = jQueryNuvem(this).closest(".js-product-container").offset().top;
            var viewportTop = window.pageYOffset;

            if(elementTop < viewportTop){
                document.documentElement.scroll({
                    top: jQueryNuvem(this).closest(".js-product-container").offset().top - 180,
                    behavior: 'smooth'
                });
            }

        });

        jQueryNuvem(document).on("click", ".js-item-buy-close", function(e) {
            e.preventDefault();
            jQueryNuvem(this).closest(".js-item-variants").fadeToggle(300);
            jQueryNuvem(this).closest(".js-quickshop-container").find(".js-item-buy-open").toggleClass("btn-primary btn-secondary");
        });

    {% endif %}

    {% if settings.product_color_variants %}

        {# Product color variations #}

        jQueryNuvem(document).on("click", ".js-color-variant", function(e) {
            e.preventDefault();
            $this = jQueryNuvem(this);

            var option_id = $this.data('option');
            $selected_option = $this.closest('.js-item-product').find('.js-variation-option option').filter(function(el) {
                return el.value == option_id;
            });
            $selected_option.prop('selected', true).trigger('change');
            var available_variant = jQueryNuvem(this).closest(".js-quickshop-container").data('variants');

            var available_variant_color = jQueryNuvem(this).closest('.js-color-variant-active').data('option');

            for (var variant in available_variant) {
                if (option_id == available_variant[variant]['option'+ available_variant_color ]) {

                    if (available_variant[variant]['stock'] == null || available_variant[variant]['stock'] > 0 ) {

                        var otherOptions = getOtherOptionNumbers(available_variant_color);

                        var otherOption = available_variant[variant]['option' + otherOptions[0]];
                        var anotherOption = available_variant[variant]['option' + otherOptions[1]];

                        changeSelect(jQueryNuvem(this), otherOption, otherOptions[0]);
                        changeSelect(jQueryNuvem(this), anotherOption, otherOptions[1]);
                        break;

                    }
                }
            }

            $this.siblings().removeClass("selected");
            $this.addClass("selected");
        });

        function getOtherOptionNumbers(selectedOption) {
            switch (selectedOption) {
                case 0:
                    return [1, 2];
                case 1:
                    return [0, 2];
                case 2:
                    return [0, 1];
            }
        }

        function changeSelect(element, optionToSelect, optionIndex) {
            if (optionToSelect != null) {
                var selected_option_attribute = element.closest('.js-item-product').find('.js-color-variant-available-' + (optionIndex + 1)).data('value');
                var selected_option = element.closest('.js-item-product').find('#' + selected_option_attribute + " option").filter(function(el) {
                    return el.value == optionToSelect;
                });

                selected_option.prop('selected', true).trigger('change');
            }
        }
    {% endif %}

    {% if settings.quick_shop or settings.product_color_variants %}

        LS.registerOnChangeVariant(function(variant){
            {# Show product image on color change #}
            var current_image = jQueryNuvem('.js-item-product[data-product-id="'+variant.product_id+'"] .js-item-image');
            current_image.attr('srcset', variant.image_url);

            {% if settings.product_hover %}
                {# Remove secondary feature on image updated from changeVariant #}
                current_image.closest(".js-item-with-secondary-image").removeClass("item-with-two-images");
            {% endif %}
        });

    {% endif %}

    {#/*============================================================================
	  #Product detail functions
	==============================================================================*/ #}

	{# /* // Installments */ #}

	{# Installments without interest #}

	function get_max_installments_without_interests(number_of_installment, installment_data, max_installments_without_interests) {
	    if (parseInt(number_of_installment) > parseInt(max_installments_without_interests[0])) {
	        if (installment_data.without_interests) {
	            return [number_of_installment, installment_data.installment_value.toFixed(2)];
	        }
	    }
	    return max_installments_without_interests;
	}

	{# Installments with interest #}

	function get_max_installments_with_interests(number_of_installment, installment_data, max_installments_with_interests) {
	    if (parseInt(number_of_installment) > parseInt(max_installments_with_interests[0])) {
	        if (installment_data.without_interests == false) {
	            return [number_of_installment, installment_data.installment_value.toFixed(2)];
	        }
	    }
	    return max_installments_with_interests;
	}

	{# Refresh installments inside detail popup #}

	function refreshInstallmentv2(price){
        jQueryNuvem(".js-modal-installment-price" ).each(function( el ) {
	        const installment = Number(jQueryNuvem(el).data('installment'));
	        jQueryNuvem(el).text(LS.currency.display_short + (price/installment).toLocaleString('de-DE', {maximumFractionDigits: 2, minimumFractionDigits: 2}));
	    });
	}

    {# Refresh price on payments popup with payment discount applied #}

    function refreshPaymentDiscount(price){
        jQueryNuvem(".js-price-with-discount" ).each(function( el ) {
            const payment_discount = jQueryNuvem(el).data('paymentDiscount');
            jQueryNuvem(el).text(LS.formatToCurrency(price - ((price * payment_discount) / 100)))
        });
    }

	{# /* // Change variant */ #}

	{# Updates price, installments, labels and CTA on variant change #}

	function changeVariant(variant) {
        jQueryNuvem(".js-product-detail .js-shipping-calculator-response").hide();
        jQueryNuvem("#shipping-variant-id").val(variant.id);

	    var parent = jQueryNuvem("body");
	    if (variant.element) {
	        parent = jQueryNuvem(variant.element);
	    }

	    var sku = parent.find('#sku');
	    if(sku.length) {
	        sku.text(variant.sku).show();
	    }

	    var installment_helper = function($element, amount, price){
	        $element.find('.js-installment-amount').text(amount);
	        $element.find('.js-installment-price').attr("data-value", price);
	        $element.find('.js-installment-price').text(LS.currency.display_short + parseFloat(price).toLocaleString('de-DE', { minimumFractionDigits: 2 }));
	        if(variant.price_short && Math.abs(variant.price_number - price * amount) < 1) {
	            $element.find('.js-installment-total-price').text((variant.price_short).toLocaleString('de-DE', { minimumFractionDigits: 2 }));
	        } else {
	            $element.find('.js-installment-total-price').text(LS.currency.display_short + (price * amount).toLocaleString('de-DE', { minimumFractionDigits: 2 }));
	        }
	    };

	    if (variant.installments_data) {
	        var variant_installments = JSON.parse(variant.installments_data);
	        var max_installments_without_interests = [0,0];
	        var max_installments_with_interests = [0,0];
	        for (let payment_method in variant_installments) {
                let installments = variant_installments[payment_method];
	            for (let number_of_installment in installments) {
                    let installment_data = installments[number_of_installment];
	                max_installments_without_interests = get_max_installments_without_interests(number_of_installment, installment_data, max_installments_without_interests);
	                max_installments_with_interests = get_max_installments_with_interests(number_of_installment, installment_data, max_installments_with_interests);
	                var installment_container_selector = '#installment_' + payment_method + '_' + number_of_installment;

	                if(!parent.hasClass("js-quickshop-container")){
	                    installment_helper(jQueryNuvem(installment_container_selector), number_of_installment, installment_data.installment_value.toFixed(2));
	                }
	            }
	        }
	        var $installments_container = jQueryNuvem(variant.element + ' .js-max-installments-container .js-max-installments');
	        var $installments_modal_link = jQueryNuvem(variant.element + ' #btn-installments');
	        var $payments_module = jQueryNuvem(variant.element + ' .js-product-payments-container');
	        var $installmens_card_icon = jQueryNuvem(variant.element + ' .js-installments-credit-card-icon');

	        {% if product.has_direct_payment_only %}
	        var installments_to_use = max_installments_without_interests[0] >= 1 ? max_installments_without_interests : max_installments_with_interests;

	        if(installments_to_use[0] <= 0 ) {
	        {%  else %}
	        var installments_to_use = max_installments_without_interests[0] > 1 ? max_installments_without_interests : max_installments_with_interests;

	        if(installments_to_use[0] <= 1 ) {
	        {% endif %}
	            $installments_container.hide();
	            $installments_modal_link.hide();
	            $payments_module.hide();
	            $installmens_card_icon.hide();
	        } else {
	            $installments_container.show();
	            $installments_modal_link.show();
	            $payments_module.show();
	            $installmens_card_icon.show();
	            installment_helper($installments_container, installments_to_use[0], installments_to_use[1]);
	        }
	    }

	    if(!parent.hasClass("js-quickshop-container")){
            jQueryNuvem('#installments-modal .js-installments-one-payment').text(variant.price_short).attr("data-value", variant.price_number);
		}

	    if (variant.price_short){

            var variant_price_clean = variant.price_short.replace('$', '').replace('R', '').replace(',', '').replace('.', '');
            var variant_price_raw = parseInt(variant_price_clean, 10);

	        parent.find('.js-price-display').text(variant.price_short).show();
	        parent.find('.js-price-display').attr("content", variant.price_number).data('productPrice', variant_price_raw);
	    } else {
	        parent.find('.js-price-display').hide();
	    }

	    if ((variant.compare_at_price_short) && !(parent.find(".js-price-display").css("display") == "none")) {
	        parent.find('.js-compare-price-display').text(variant.compare_at_price_short).show();
	    } else {
	        parent.find('.js-compare-price-display').hide();
	    }

	    var button = parent.find('.js-addtocart');
	    button.removeClass('cart').removeClass('contact').removeClass('nostock');
	    var $product_shipping_calculator = parent.find("#product-shipping-container");

        {# Update CTA wording and status #}

	    {% if not store.is_catalog %}
	    if (!variant.available){
	        button.val('{{ "Sin stock" | translate }}');
	        button.addClass('nostock');
	        button.attr('disabled', 'disabled');
	        $product_shipping_calculator.hide();
	    } else if (variant.contact) {
	        button.val('{{ "Consultar precio" | translate }}');
	        button.addClass('contact');
	        button.removeAttr('disabled');
	        $product_shipping_calculator.hide();
	    } else {
	        button.val('{{ "Agregar al carrito" | translate }}');
	        button.addClass('cart');
	        button.removeAttr('disabled');
	        $product_shipping_calculator.show();
	    }

	    {% endif %}

        {% if template == 'product' %}
            const base_price = Number(jQueryNuvem("#price_display").attr("content"));
            refreshInstallmentv2(base_price);
            refreshPaymentDiscount(variant.price_number);

            {% if settings.last_product and product.variations %}
                if(variant.stock == 1) {
                    jQueryNuvem('.js-last-product').show();
                } else {
                    jQueryNuvem('.js-last-product').hide();
                }
            {% endif %}
        {% endif %}


        {# Update shipping on variant change #}

        LS.updateShippingProduct();

        zipcode_on_changevariant = jQueryNuvem("#product-shipping-container .js-shipping-input").val();
        jQueryNuvem("#product-shipping-container .js-shipping-calculator-current-zip").text(zipcode_on_changevariant);

        {% if store.has_free_shipping_progress and cart.free_shipping.min_price_free_shipping.min_price %}
            {# Updates free shipping bar #}

            LS.freeShippingProgress();

        {% endif %}
	}

	{# /* // Trigger change variant */ #}

    jQueryNuvem(document).on("change", ".js-variation-option", function(e) {
        var $parent = jQueryNuvem(this).closest(".js-product-variants");
        var $variants_group = jQueryNuvem(this).closest(".js-product-variants-group");
        var quick_id = jQueryNuvem(this).closest(".js-quickshop-container").attr("id");
        if($parent.hasClass("js-product-quickshop-variants")){
            {% if template == 'home' %}
                LS.changeVariant(changeVariant, '.js-swiper-slide-visible #' + quick_id);
            {% else %}
                LS.changeVariant(changeVariant, '#' + quick_id);
            {% endif %}

            {% if settings.product_color_variants %}
                {# Match selected color variant with selected quickshop variant #}
                if(($variants_group).hasClass("js-color-variants-container")){
                    var selected_option_id = jQueryNuvem(this).find("option").filter((el) => el.selected).val();
                    jQueryNuvem('#' + quick_id).find('.js-color-variant').removeClass("selected");
                    jQueryNuvem('#' + quick_id).find('.js-color-variant[data-option="'+selected_option_id+'"]').addClass("selected");
                }
            {% endif %}
        } else {
            LS.changeVariant(changeVariant, '#single-product');
        }

        {# Offer and discount labels update #}

        var $this_product_container = jQueryNuvem(this).closest(".js-product-container");
        var $this_compare_price = $this_product_container.find(".js-compare-price-display");
        var $this_price = $this_product_container.find(".js-price-display");
        var $installment_container = $this_product_container.find(".js-product-payments-container");
        var $installment_text = $this_product_container.find(".js-max-installments-container");
        var $this_add_to_cart =  $this_product_container.find(".js-prod-submit-form");

        // Get the current product discount percentage value
        var current_percentage_value = $this_product_container.find(".js-offer-percentage");

        // Get the current product price and promotional price
        var compare_price_value = $this_compare_price.html();
        var price_value = $this_price.html();

        // Calculate new discount percentage based on difference between filtered old and new prices
        const percentageDifference = window.moneyDifferenceCalculator.percentageDifferenceFromString(compare_price_value, price_value);
        if(percentageDifference){
            $this_product_container.find(".js-offer-percentage").text(percentageDifference);
            $this_product_container.find(".js-offer-label").css("display" , "table");
        }

        if ($this_compare_price.css("display") == "none" || !percentageDifference) {
            $this_product_container.find(".js-offer-label").hide();
        }
        if ($this_add_to_cart.hasClass("nostock")) {
            $this_product_container.find(".js-stock-label").show();
        }
        else {
            $this_product_container.find(".js-stock-label").hide();
	    }
	    if ($this_price.css('display') == 'none'){
	        $installment_container.hide();
	        $installment_text.hide();
	    }else{
	        $installment_text.show();
	    }
	});

	{# /* // Submit to contact */ #}

	{# Submit to contact form when product has no price #}

    jQueryNuvem(".js-product-form").on("submit", function (e) {
	    var button = jQueryNuvem(e.currentTarget).find('[type="submit"]');
	    button.attr('disabled', 'disabled');
	    if ((button.hasClass('contact')) || (button.hasClass('catalog'))) {
	        e.preventDefault();
	        var product_id = jQueryNuvem(e.currentTarget).find("input[name='add_to_cart']").val();
	        window.location = "{{ store.contact_url | escape('js') }}?product=" + product_id;
	    } else if (button.hasClass('cart')) {
	        button.val('{{ "Agregando..." | translate }}');
	    }
	});

	{% if template == 'product' %}

        {% set has_multiple_slides = product.images_count > 1 or video_url %}

	    {# /* // Product slider */ #}

            var width = window.innerWidth;
            if (width > 767) {
                var speedVal = 0;
                var spaceBetweenVal = 0;
                var slidesPerViewVal = 1;
            } else {
                var speedVal = 300;
                var spaceBetweenVal = 10;
                var slidesPerViewVal = 1.2;
            }

            var productSwiper = null;
            createSwiper(
                '.js-swiper-product', {
                    lazy: true,
                    speed: speedVal,
                    {% if has_multiple_slides %}
                    slidesPerView: slidesPerViewVal,
                    centeredSlides: true,
                    spaceBetween: spaceBetweenVal,
                    {% endif %}
                    pagination: {
                        el: '.js-swiper-product-pagination',
                        type: 'fraction',
                        clickable: true,
                    },
                    navigation: {
                        nextEl: '.js-swiper-product-next',
                        prevEl: '.js-swiper-product-prev',
                    },
                    on: {
                        init: function () {
                            jQueryNuvem(".js-product-slider-placeholder").hide();
                            jQueryNuvem(".js-swiper-product").css("visibility", "visible").css("height", "auto");
                            {% if product.video_url %}
                                if (window.innerWidth < 768) {
                                    productSwiperHeight = jQueryNuvem(".js-swiper-product").height();
                                    jQueryNuvem(".js-product-video-slide").height(productSwiperHeight);
                                }
                            {% endif %}
                        },
                        {% if product.video_url %}
                            slideChangeTransitionEnd: function () {
                                if(jQueryNuvem(".js-product-video-slide").hasClass("swiper-slide-active")){
                                    jQueryNuvem(".js-labels-group").fadeOut(100);
                                }else{
                                    jQueryNuvem(".js-labels-group").fadeIn(100);
                                }
                                jQueryNuvem('.js-video').show();
                                jQueryNuvem('.js-video-iframe').hide().find("iframe").remove();
                            },
                        {% endif %}
                    },
                },
                function(swiperInstance) {
                    productSwiper = swiperInstance;
                }
            );

            {% if store.useNativeJsLibraries() %}

                Fancybox.bind('[data-fancybox="product-gallery"]', {
                    Toolbar: { display: ['counter', 'close'] },
                    Thumbs: { autoStart: false },
                    on: {
                        shouldClose: (fancybox, slide) => {
                            // Update position of the slider
                            productSwiper.slideTo( fancybox.getSlide().index, 0 );
                            jQueryNuvem(".js-product-thumb").removeClass("selected");

                            var $product_thumbnail = jQueryNuvem(".js-product-thumb[data-thumb-loop='"+fancybox.getSlide().index+"']").addClass("selected");
                            if($product_thumbnail.length){
                                $product_thumbnail.addClass("selected");
                            }else{
                                jQueryNuvem(".js-product-thumb[data-thumb-loop='4']").addClass("selected");
                            }
                        },
                    },
                });

            {% else %}

                $().fancybox({
                    selector : '[data-fancybox="product-gallery"]',
                    toolbar  : false,
                    smallBtn : true,
                    beforeClose : function(instance) {
                        // Update position of the slider
                        productSwiper.slideTo( instance.currIndex, 0 );
                        jQueryNuvem(".js-product-thumb").removeClass("selected");

                        var $product_thumbnail = jQueryNuvem(".js-product-thumb[data-thumb-loop='"+instance.currIndex+"']").addClass("selected");
                        if($product_thumbnail.length){
                            $product_thumbnail.addClass("selected");
                        }else{
                            jQueryNuvem(".js-product-thumb[data-thumb-loop='4']").addClass("selected");
                        }
                    },
                });

            {% endif %}

	    {% if has_multiple_slides %}
	        LS.registerOnChangeVariant(function(variant){
	            var liImage = jQueryNuvem('.js-swiper-product').find("[data-image='"+variant.image+"']");
	            var selectedPosition = liImage.data('imagePosition');
                var slideToGo = parseInt(selectedPosition);
                productSwiper.slideTo(slideToGo);
                jQueryNuvem(".js-product-slide-img").removeClass("js-active-variant");
                liImage.find(".js-product-slide-img").addClass("js-active-variant");
	        });

            jQueryNuvem(".js-product-thumb").on("click", function(e){
                e.preventDefault();
                jQueryNuvem(".js-product-thumb").removeClass("selected");
                jQueryNuvem(e.currentTarget).addClass("selected");
                var thumbLoop = jQueryNuvem(e.currentTarget).data("thumbLoop");
                var slideToGo = parseInt(thumbLoop);
                productSwiper.slideTo(slideToGo);
                if(jQueryNuvem(e.currentTarget).hasClass("js-product-thumb-modal")){
                    jQueryNuvem('.js-swiper-product').find("[data-image-position='"+slideToGo+"'] .js-product-slide-link").trigger('click');
                }
            });
	    {% endif %}

        {# /* // Pinterest sharing */ #}

        jQueryNuvem('.js-pinterest-share').on("click", function(e){
            e.preventDefault();
            jQueryNuvem(".pinterest-hidden a").get()[0].click();
        });

        {# Product show description and relocate on mobile #}

        if (window.innerWidth > 767) {
            jQueryNuvem("#product-description").show();
        }else{
            jQueryNuvem("#product-description").insertAfter("#product_form").show();
        }

	{% endif %}

    {# Product quantitiy #}

    jQueryNuvem('.js-quantity .js-quantity-up').on('click', function(e) {
        $quantity_input = jQueryNuvem(e.currentTarget).closest(".js-quantity").find(".js-quantity-input");
        $quantity_input.val( parseInt($quantity_input.val(), 10) + 1);
    });

    jQueryNuvem('.js-quantity .js-quantity-down').on('click', function(e) {
        $quantity_input = jQueryNuvem(e.currentTarget).closest(".js-quantity").find(".js-quantity-input");
        quantity_input_val = $quantity_input.val();
        if (quantity_input_val>1) {
            $quantity_input.val( parseInt($quantity_input.val(), 10) - 1);
        }
    });


	{#/*============================================================================
	  #Cart
	==============================================================================*/ #}

    {# /* // Toggle cart */ #}
    {% if store.has_free_shipping_progress and cart.free_shipping.min_price_free_shipping.min_price %}

        {# Updates free progress on page load #}

        LS.freeShippingProgress(true);

    {% endif %}

    {# /* // Position of cart page summary */ #}

    var head_height = jQueryNuvem(".js-head-main").outerHeight();

    if (window.innerWidth > 768) {
        {% if settings.head_fix %}
            jQueryNuvem("#cart-sticky-summary").css("top" , (head_height + 10).toString() + 'px');
        {% else %}
            jQueryNuvem("#cart-sticky-summary").css("top" , "10px");
        {% endif %}
    }


    {# /* // Add to cart */ #}

    jQueryNuvem(document).on("click", ".js-addtocart:not(.js-addtocart-placeholder)", function (e) {

        {# Button variables for transitions on add to cart #}

        var $productContainer = jQueryNuvem(this).closest('.js-product-container');
        var $productVariants = $productContainer.find(".js-variation-option");
        var $productButton = $productContainer.find("input[type='submit'].js-addtocart");
        var $productButtonPlaceholder = $productContainer.find(".js-addtocart-placeholder");
        var $productButtonText = $productButtonPlaceholder.find(".js-addtocart-text");
        var $productButtonAdding = $productButtonPlaceholder.find(".js-addtocart-adding");
        var $productButtonSuccess = $productButtonPlaceholder.find(".js-addtocart-success");

        {# Define if event comes from quickshop or product page #}

        var isQuickShop = $productContainer.hasClass('js-quickshop-container');

         {# Added item information for notification #}

        if (!isQuickShop) {
            if(jQueryNuvem(".js-product-slide-img.js-active-variant").length) {
                var imageSrc = $productContainer.find('.js-product-slide-img.js-active-variant').data('srcset').split(' ')[0];
            } else {
                var imageSrc = $productContainer.find('.js-product-slide-img').attr('srcset').split(' ')[0];
            }
            var quantity = $productContainer.find('.js-quantity-input').val();
            var name = $productContainer.find('.js-product-name').text();
            var price = $productContainer.find('.js-price-display').text();
            var addedToCartCopy = "{{ 'Agregar al carrito' | translate }}";
        } else {
            var imageSrc = jQueryNuvem(this).closest('.js-quickshop-container').find('img').attr('srcset').split(' ')[0];
            var quantity = 1;
            var name = $productContainer.find('.js-item-name').text();
            var price = $productContainer.find('.js-price-display').text().trim();
            var addedToCartCopy = "{{ 'Comprar' | translate }}";
            if ($productContainer.hasClass("js-quickshop-has-variants")) {
                var addedToCartCopy = "{{ 'Agregar al carrito' | translate }}";
            }else{
                var addedToCartCopy = "{{ 'Comprar' | translate }}";
            }
        }

        if (!jQueryNuvem(this).hasClass('contact')) {

            {% if settings.ajax_cart %}
                e.preventDefault();
            {% endif %}

            {# Hide real button and show button placeholder during event #}

            $productButton.hide();
            $productButtonPlaceholder.css('display' , 'inline-block');
            $productButtonText.fadeOut();
            $productButtonAdding.addClass("active");

            {% if settings.ajax_cart %}

                var callback_add_to_cart = function(){

                    {# Animate cart amount #}

                    jQueryNuvem(".js-cart-widget-amount").addClass("swing");

                    setTimeout(function(){
                        jQueryNuvem(".js-cart-widget-amount").removeClass("swing");
                    },6000);

                    {# Fill notification info #}

                    jQueryNuvem('.js-cart-notification-item-img').attr('srcset', imageSrc);
                    jQueryNuvem('.js-cart-notification-item-name').text(name);
                    jQueryNuvem('.js-cart-notification-item-quantity').text(quantity);
                    jQueryNuvem('.js-cart-notification-item-price').text(price);

                    if($productVariants.length){
                        var output = [];

                        $productVariants.each( function(el){
                            var variants = jQueryNuvem(el);
                            output.push(variants.val());
                        });
                        jQueryNuvem(".js-cart-notification-item-variant-container").show();
                        jQueryNuvem(".js-cart-notification-item-variant").text(output.join(', '))
                    }else{
                        jQueryNuvem(".js-cart-notification-item-variant-container").hide();
                    }

                    {# Set products amount wording visibility #}

                    var cartItemsAmount = jQueryNuvem(".js-cart-widget-amount").text();

                    if(cartItemsAmount > 1){
                        jQueryNuvem(".js-cart-counts-plural").show();
                        jQueryNuvem(".js-cart-counts-singular").hide();
                    }else{
                        jQueryNuvem(".js-cart-counts-singular").show();
                        jQueryNuvem(".js-cart-counts-plural").hide();
                    }

                    {# Show button placeholder with transitions #}

                    $productButtonAdding.removeClass("active");
                    $productButtonSuccess.addClass("active");
                    setTimeout(function(){
                        $productButtonSuccess.removeClass("active");
                        $productButtonText.fadeIn();
                    },2000);
                    setTimeout(function(){
                        $productButtonPlaceholder.removeAttr("style").hide();
                        $productButton.show();
                    },3000);

                    $productContainer.find(".js-added-to-cart-product-message").slideDown();

                    {# Show notification and hide it only after second added to cart #}

                    setTimeout(function(){
                        jQueryNuvem(".js-alert-added-to-cart").show().addClass("notification-visible").removeClass("notification-hidden");
                    },500);

                    if (!cookieService.get('first_product_added_successfully')) {
                        cookieService.set('first_product_added_successfully', 1, 7 );
                    } else{
                        setTimeout(function(){
                            jQueryNuvem(".js-alert-added-to-cart").removeClass("notification-visible").addClass("notification-hidden");
                            setTimeout(function(){
                                jQueryNuvem('.js-cart-notification-item-img').attr('src', '');
                                jQueryNuvem(".js-alert-added-to-cart").hide();
                            },2000);
                        },8000);
                    }


                    {# Update shipping input zipcode on add to cart #}

                    {# Use zipcode from input if user is in product page, or use zipcode cookie if is not #}

                    if (jQueryNuvem("#product-shipping-container .js-shipping-input").val()) {
                        zipcode_on_addtocart = jQueryNuvem("#product-shipping-container .js-shipping-input").val();
                        jQueryNuvem("#cart-shipping-container .js-shipping-input").val(zipcode_on_addtocart);
                        jQueryNuvem(".js-shipping-calculator-current-zip").text(zipcode_on_addtocart);
                    } else if (cookieService.get('calculator_zipcode')){
                        var zipcode_from_cookie = cookieService.get('calculator_zipcode');
                        jQueryNuvem('.js-shipping-input').val(zipcode_from_cookie);
                        jQueryNuvem(".js-shipping-calculator-current-zip").text(zipcode_from_cookie);
                    }

                    {% if store.has_free_shipping_progress %}

                        {# Update free shipping wording #}

                        jQueryNuvem(".js-fs-add-this-product").hide();
                        jQueryNuvem(".js-fs-add-one-more").show();
                    {% endif %}

                }
                var callback_error = function(){
                    {# Restore real button visibility in case of error #}

                    $productButtonAdding.removeClass("active");
                    $productButtonText.fadeIn();
                    $productButtonPlaceholder.removeAttr("style").hide();
                    $productButton.show();
                }
                $prod_form = jQueryNuvem(this).closest("form");
                LS.addToCartEnhanced(
                    $prod_form,
                    addedToCartCopy,
                    '{{ "Agregando..." | translate }}',
                    '{{ "¡Uy! No tenemos más stock de este producto para agregarlo al carrito." | translate }}',
                    {{ store.editable_ajax_cart_enabled ? 'true' : 'false' }},
                        callback_add_to_cart,
                        callback_error
                );
            {% endif %}
        }
    });


    {# /* // Cart quantitiy changes */ #}

    jQueryNuvem(document).on("keypress", ".js-cart-quantity-input", function (e) {
        if (e.which != 8 && e.which != 0 && (e.which < 48 || e.which > 57)) {
            return false;
        }
    });

    jQueryNuvem(document).on("focusout", ".js-cart-quantity-input", function (e) {
        var itemID = jQueryNuvem(this).attr("data-item-id");
        var itemVAL = jQueryNuvem(this).val();
        if (itemVAL == 0) {
            var r = confirm("{{ '¿Seguro que quieres borrar este artículo?' | translate }}");
            if (r == true) {
                LS.removeItem(itemID, true);
            } else {
                jQueryNuvem(this).val(1);
            }
        } else {
            LS.changeQuantity(itemID, itemVAL, true);
        }
    });

    {# /* // Empty cart alert */ #}

    jQueryNuvem(".js-trigger-empty-cart-alert").on("click", function (e) {
        e.preventDefault();
        let emptyCartAlert = jQueryNuvem(".js-mobile-nav-empty-cart-alert").fadeIn(100);
        setTimeout(() => emptyCartAlert.fadeOut(500), 1500);
    });

    {# /* // Go to checkout */ #}

    {# Clear cart notification cookie after consumers continues to checkout #}

    jQueryNuvem('form[action="{{ store.cart_url | escape('js') }}"]').on("submit", function() {
        cookieService.remove('first_product_added_successfully');
    });


	{#/*============================================================================
	  #Shipping calculator
	==============================================================================*/ #}

    {# /* // Update calculated cost wording */ #}

    {% if settings.shipping_calculator_cart_page %}
        if (jQueryNuvem('.js-selected-shipping-method').length) {
            var shipping_cost = jQueryNuvem('.js-selected-shipping-method').data("cost");
            var $shippingCost = jQueryNuvem("#shipping-cost");
            $shippingCost.text(shipping_cost);
            $shippingCost.removeClass('opacity-40');
        }
    {% endif %}

	{# /* // Select and save shipping function */ #}

    selectShippingOption = function(elem, save_option) {
        jQueryNuvem(".js-shipping-method, .js-branch-method").removeClass('js-selected-shipping-method');
        jQueryNuvem(elem).addClass('js-selected-shipping-method');

        {% if settings.shipping_calculator_cart_page %}

            var shipping_cost = jQueryNuvem(elem).data("cost");
            var shipping_price_clean = jQueryNuvem(elem).data("price");

            if(shipping_price_clean = 0.00){
                var shipping_cost = '{{ Gratis | translate }}'
            }

            // Updates shipping (ship and pickup) cost on cart
            var $shippingCost = jQueryNuvem("#shipping-cost");
            $shippingCost.text(shipping_cost);
            $shippingCost.removeClass('opacity-40');

        {% endif %}

        if (save_option) {
            LS.saveCalculatedShipping(true);
        }
        if (jQueryNuvem(elem).hasClass("js-shipping-method-hidden")) {
            {# Toggle other options visibility depending if they are pickup or delivery for cart and product at the same time #}
            if (jQueryNuvem(elem).hasClass("js-pickup-option")) {
                jQueryNuvem(".js-other-pickup-options, .js-show-other-pickup-options .js-shipping-see-less").show();
                jQueryNuvem(".js-show-other-pickup-options .js-shipping-see-more").hide();
            } else {
                jQueryNuvem(".js-other-shipping-options, .js-show-more-shipping-options .js-shipping-see-less").show();
                jQueryNuvem(".js-show-more-shipping-options .js-shipping-see-more").hide()
            }
        }
    };

    {# Apply zipcode saved by cookie if there is no zipcode saved on cart from backend #}

    if (cookieService.get('calculator_zipcode')) {

        {# If there is a cookie saved based on previous calcualtion, add it to the shipping input to triggert automatic calculation #}

        var zipcode_from_cookie = cookieService.get('calculator_zipcode');

        {% if settings.ajax_cart %}

            {# If ajax cart is active, target only product input to avoid extra calulation on empty cart #}

            jQueryNuvem('#product-shipping-container .js-shipping-input').val(zipcode_from_cookie);

        {% else %}

            {# If ajax cart is inactive, target the only input present on screen #}

            jQueryNuvem('.js-shipping-input').val(zipcode_from_cookie);

        {% endif %}

        jQueryNuvem(".js-shipping-calculator-current-zip").text(zipcode_from_cookie);

        {# Hide the shipping calculator and show spinner  #}

        jQueryNuvem(".js-shipping-calculator-head").addClass("with-zip").removeClass("with-form");
        jQueryNuvem(".js-shipping-calculator-with-zipcode").addClass("transition-up-active");
        jQueryNuvem(".js-shipping-calculator-spinner").show();
    } else {

        {# If there is no cookie saved, show calcualtor #}

        jQueryNuvem(".js-shipping-calculator-form").addClass("transition-up-active");
    }

    {# Remove shipping suboptions from DOM to avoid duplicated modals #}

    removeShippingSuboptions = function(){
        var shipping_suboptions_id = jQueryNuvem(".js-modal-shipping-suboptions").attr("id");
        jQueryNuvem("#" + shipping_suboptions_id).remove();
        jQueryNuvem('.js-modal-overlay[data-modal-id="#' + shipping_suboptions_id + '"').remove();
    };

    {# /* // Calculate shipping function */ #}


    jQueryNuvem(".js-calculate-shipping").on("click", function (e) {
	    e.preventDefault();

        {# Take the Zip code to all shipping calculators on screen #}
        let shipping_input_val = jQueryNuvem(e.currentTarget).closest(".js-shipping-calculator-form").find(".js-shipping-input").val();

        jQueryNuvem(".js-shipping-input").val(shipping_input_val);

        {# Calculate on page load for both calculators: Product and Cart #}
        {% if template == 'product' %}
             if (!vanillaJS) {
                LS.calculateShippingAjax(
                    jQueryNuvem('#product-shipping-container').find(".js-shipping-input").val(),
                    '{{store.shipping_calculator_url | escape('js')}}',
                    jQueryNuvem("#product-shipping-container").closest(".js-shipping-calculator-container") );
             }
        {% endif %}

        if (jQueryNuvem(".js-cart-item").length) {
            LS.calculateShippingAjax(
            jQueryNuvem('#cart-shipping-container').find(".js-shipping-input").val(),
            '{{store.shipping_calculator_url | escape('js')}}',
            jQueryNuvem("#cart-shipping-container").closest(".js-shipping-calculator-container") );
        }

        jQueryNuvem(".js-shipping-calculator-current-zip").html(shipping_input_val);
        removeShippingSuboptions();
	});

	{# /* // Calculate shipping by submit */ #}

    jQueryNuvem(".js-shipping-input").on('keydown', function (e) {
	    var key = e.which ? e.which : e.keyCode;
	    var enterKey = 13;
	    if (key === enterKey) {
	        e.preventDefault();
            jQueryNuvem(e.currentTarget).closest(".js-shipping-calculator-form").find(".js-calculate-shipping").trigger('click');
	        if (window.innerWidth < 768) {
                jQueryNuvem(e.currentTarget).trigger('blur');
	        }
	    }
	});

    {# /* // Shipping and branch click */ #}

    jQueryNuvem(document).on("change", ".js-shipping-method, .js-branch-method", function (e) {
        selectShippingOption(this, true);
        jQueryNuvem(".js-shipping-method-unavailable").hide();
    });

    {# /* // Select shipping first option on results */ #}

    jQueryNuvem(document).on('shipping.options.checked', '.js-shipping-method', function (e) {
        let shippingPrice = jQueryNuvem(this).attr("data-price");
        LS.addToTotal(shippingPrice);

        let total = (LS.data.cart.total / 100) + parseFloat(shippingPrice);
        jQueryNuvem(".js-cart-widget-total").html(LS.formatToCurrency(total));

        selectShippingOption(this, false);
    });

    {# /* // Toggle branches link */ #}

    jQueryNuvem(document).on("click", ".js-toggle-branches", function (e) {
        e.preventDefault();
        jQueryNuvem(".js-store-branches-container").slideToggle("fast");
        jQueryNuvem(".js-see-branches, .js-hide-branches").toggle();
    });

    {# /* // Toggle more shipping options */ #}

    jQueryNuvem(document).on("click", ".js-toggle-more-shipping-options", function(e) {
	    e.preventDefault();

        {# Toggle other options depending if they are pickup or delivery for cart and product at the same time #}

        if(jQueryNuvem(this).hasClass("js-show-other-pickup-options")){
            jQueryNuvem(".js-other-pickup-options").slideToggle(600);
            jQueryNuvem(".js-show-other-pickup-options .js-shipping-see-less, .js-show-other-pickup-options .js-shipping-see-more").toggle();
        }else{
            jQueryNuvem(".js-other-shipping-options").slideToggle(600);
            jQueryNuvem(".js-show-more-shipping-options .js-shipping-see-less, .js-show-more-shipping-options .js-shipping-see-more").toggle();
        }
	});

    {# /* // Calculate shipping on page load */ #}

    {# Only shipping input has value, cart has saved shipping and there is no branch selected #}

    calculateCartShippingOnLoad = function() {
        {# Triggers function when a zipcode input is filled #}
        if (jQueryNuvem("#cart-shipping-container .js-shipping-input").val()) {
            // If user already had calculated shipping: recalculate shipping
            setTimeout(function() {
                LS.calculateShippingAjax(
                    jQueryNuvem('#cart-shipping-container').find(".js-shipping-input").val(),
                    '{{store.shipping_calculator_url | escape('js')}}',
                    jQueryNuvem("#cart-shipping-container").closest(".js-shipping-calculator-container") );
                    removeShippingSuboptions();
            }, 100);
        }

        if (jQueryNuvem(".js-branch-method").hasClass('js-selected-shipping-method')) {
            {% if store.branches|length > 1 %}
                jQueryNuvem(".js-store-branches-container").slideDown("fast");
                jQueryNuvem(".js-see-branches").hide();
                jQueryNuvem(".js-hide-branches").show();
            {% endif %}
        }
    };

    {% if cart.has_shippable_products %}
        calculateCartShippingOnLoad();
    {% endif %}


    {% if template == 'product' %}
        if (!vanillaJS) {
            {# /* // Calculate product detail shipping on page load */ #}

            if(jQueryNuvem('#product-shipping-container').find(".js-shipping-input").val()){
                setTimeout(function() {
                    LS.calculateShippingAjax(
                        jQueryNuvem('#product-shipping-container').find(".js-shipping-input").val(),
                        '{{store.shipping_calculator_url | escape('js')}}',
                        jQueryNuvem("#product-shipping-container").closest(".js-shipping-calculator-container") );

                    removeShippingSuboptions();
                }, 100);
            }
        }

        {# /* // Pitch login instead of zipcode helper if is returning customer */ #}

        {% if not customer %}
            if (cookieService.get('returning_customer')) {
                jQueryNuvem('.js-shipping-zipcode-help').remove();
            } else {
                jQueryNuvem('.js-product-quick-login').remove();
            }
        {% endif %}

    {% endif %}

    {# /* // Change CP */ #}

    jQueryNuvem(document).on("click", ".js-shipping-calculator-change-zipcode", function(e) {
        e.preventDefault();
        jQueryNuvem(".js-shipping-calculator-response").fadeOut(100);
        jQueryNuvem(".js-shipping-calculator-head").addClass("with-form").removeClass("with-zip");
        jQueryNuvem(".js-shipping-calculator-with-zipcode").removeClass("transition-up-active");
        jQueryNuvem(".js-shipping-calculator-form").addClass("transition-up-active");
    });

	{# /* // Shipping provinces */ #}

	{% if provinces_json %}
        jQueryNuvem('select[name="country"]').on("change", function (e) {
		    var provinces = {{ provinces_json | default('{}') | raw }};
		    LS.swapProvinces(provinces[jQueryNuvem(e.currentTarget).val()]);
		}).trigger('change');
	{% endif %}


    {# /* // Change store country: From invalid zipcode message */ #}

    jQueryNuvem(document).on("click", ".js-save-shipping-country", function(e) {

        e.preventDefault();

        {# Change shipping country #}

        var selected_country_url = jQueryNuvem(this).closest(".js-modal-shipping-country").find(".js-shipping-country-select option").filter((el) => el.selected).attr("data-country-url");
        location.href = selected_country_url;

        jQueryNuvem(this).text('{{ "Aplicando..." | translate }}').addClass("disabled");
    });

    {#/*============================================================================
      #Forms
    ==============================================================================*/ #}

    jQueryNuvem(".js-winnie-pooh-form").on("submit", function (e) {
        jQueryNuvem(e.currentTarget).attr('action', '');
    });

    jQueryNuvem(".js-form").on("submit", function (e) {
        jQueryNuvem(e.currentTarget).find('.js-form-spinner').show();
    });

    {% if template == 'account.login' %}
        {% if not result.facebook and result.invalid %}
            jQueryNuvem(".js-account-input").addClass("alert-danger");
            jQueryNuvem(".js-account-input.alert-danger").on("focus", function() {
                jQueryNuvem(".js-account-input").removeClass("alert-danger");
            });
        {% endif %}
    {% endif %}

    {# Show the success or error message when resending the validation link #}

    {% if template == 'account.register' or template == 'account.login' %}
        jQueryNuvem(".js-resend-validation-link").on("click", function(e){
            window.accountVerificationService.resendVerificationEmail('{{ customer_email }}');
        });
    {% endif %}

    jQueryNuvem('.js-password-view').on("click", function (e) {
        jQueryNuvem(e.currentTarget).toggleClass('password-view');

        if(jQueryNuvem(e.currentTarget).hasClass('password-view')){
            jQueryNuvem(e.currentTarget).parent().find(".js-password-input").attr('type', '');
            jQueryNuvem(e.currentTarget).find(".js-eye-open, .js-eye-closed").toggle();
        } else {
            jQueryNuvem(e.currentTarget).parent().find(".js-password-input").attr('type', 'password');
            jQueryNuvem(e.currentTarget).find(".js-eye-open, .js-eye-closed").toggle();
        }
    });

    {% if store.country == 'AR' and template == 'home' %}

        if (cookieService.get('returning_customer') && LS.shouldShowQuickLoginNotification()) {
            {# Make login link toggle quick login modal #}
            jQueryNuvem(".js-login").removeAttr("href").attr("data-toggle", "#quick-login").addClass("js-modal-open js-trigger-modal-zindex-top");
        }
    {% endif %}


    {#/*============================================================================
      #Footer
    ==============================================================================*/ #}

    {% if store.afip %}

        {# Add alt attribute to external AFIP logo to improve SEO #}

        jQueryNuvem('img[src*="www.afip.gob.ar"]').attr('alt', '{{ "Logo de AFIP" | translate }}');

    {% endif %}


    {#/*============================================================================
      #Empty placeholders
    ==============================================================================*/ #}

    {% set show_help = not has_products %}

    {% if template == 'home' and show_help %}

        {# /* // Home slider */ #}

        var width = window.innerWidth;
        if (width > 767) {
            var slider_empty_autoplay = {delay: 6000,};
        } else {
            var slider_empty_autoplay = false;
        }

        window.homeEmptySlider = {
            getAutoRotation: function() {
                return slider_empty_autoplay;
            },
        };
        createSwiper('.js-home-empty-slider', {
            {% if not params.preview %}
            lazy: true,
            {% endif %}
            loop: true,
            autoplay: slider_empty_autoplay,
            pagination: {
                el: '.js-swiper-empty-home-pagination',
                clickable: true,
                renderBullet: function (index, className) {
                  return '<span class="' + className + '">' + (index + 1) + '</span>';
                },
            },
            navigation: {
                nextEl: '.js-swiper-empty-home-next',
                prevEl: '.js-swiper-empty-home-prev',
            },
            on: {
                init: function () {
                    jQueryNuvem(".js-home-empty-slider").css("visibility", "visible").css("height", "100%");
                },
            },
        });


        {# /* // Banner services slider */ #}
        var width = window.innerWidth;
        if (width < 767) {
            createSwiper('.js-informative-banners', {
                slidesPerView: 1.2,
                watchOverflow: true,
                centerInsufficientSlides: true,
                pagination: {
                    el: '.js-informative-banners-pagination',
                    clickable: true,
                },
                breakpoints: {
                    640: {
                        slidesPerView: 3,
                    }
                }
            });
        }

        {# /* // Brands slider */ #}
        createSwiper('.js-swiper-brands', {
            lazy: true,
            loop: true,
            watchOverflow: true,
            centerInsufficientSlides: true,
            spaceBetween: 30,
            slidesPerView: 1.5,
            navigation: {
                nextEl: '.js-swiper-brands-next',
                prevEl: '.js-swiper-brands-prev',
            },
            breakpoints: {
                640: {
                    slidesPerView: 5,
                }
            }
        });

    {% endif %}

    {% if template == '404' and show_help %}

        {# /* // Product Related */ #}

        {% set columns = settings.grid_columns %}
        createSwiper('.js-swiper-related', {
            lazy: true,
            loop: true,
            watchOverflow: true,
            centerInsufficientSlides: true,
            slidesPerView: 1.5,
            watchSlideProgress: true,
            watchSlidesVisibility: true,
            slideVisibleClass: 'js-swiper-slide-visible',
            navigation: {
                nextEl: '.js-swiper-related-next',
                prevEl: '.js-swiper-related-prev',
            },
            breakpoints: {
                640: {
                    slidesPerView: {% if columns == 2 %}4{% else %}3{% endif %},
                }
            }
        });

        {# /* // Product slider */ #}

        var width = window.innerWidth;
        if (width > 767) {
            var speedVal = 0;
            var loopVal = false;
            var spaceBetweenVal = 0;
            var slidesPerViewVal = 1;
        } else {
            var speedVal = 300;
            var loopVal = true;
            var spaceBetweenVal = 10;
            var slidesPerViewVal = 1.2;
        }

        createSwiper('.js-swiper-product', {
            lazy: true,
            speed: speedVal,
            {% if product.images_count > 1 %}
            loop: loopVal,
            slidesPerView: slidesPerViewVal,
            centeredSlides: true,
            spaceBetween: spaceBetweenVal,
            {% endif %}
            pagination: {
                el: '.js-swiper-product-pagination',
                type: 'fraction',
                clickable: true,
            },
            on: {
                init: function () {
                    jQueryNuvem(".js-product-slider-placeholder").hide();
                    jQueryNuvem(".js-swiper-product").css("visibility", "visible").css("height", "auto");
                },
            },
        });

        {# /* 404 handling to show the example product */ #}

        if ( window.location.pathname === "/product/example/" || window.location.pathname === "/br/product/example/" ) {
            document.title = "{{ "Producto de ejemplo" | translate | escape('js') }}";
            jQueryNuvem("#404").hide();
            jQueryNuvem("#product-example").show();
        } else {
            jQueryNuvem("#product-example").hide();
        }

    {% endif %}

});
