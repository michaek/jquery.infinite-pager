$ = jQuery

$.fn.infinitePager = (options) ->
  $context = $(@)
  currentlyLoading = false
  options = $.extend {}, $.infinitePager.defaults, options

  nearBottomOfPage = ->
    $(window).scrollTop() > $(document).height() - $(window).height() - options.bottomOffset
  paginationPossible = ->
    $list = $context.find(options.listSelector)
    $list.length && $list.find('.pagination').length

  $(window).scroll ->

    if !currentlyLoading && nearBottomOfPage() && paginationPossible()
      $list = $context.find(options.listSelector)
      $pagination = $list.find(options.pagerSelector)

      $pagination.find(options.linkSelector).last().each ->
        $next = $(@)
        $list.toggleClass(options.loadingClass, currentlyLoading=true)

        $.get $next.attr('href'), (data) ->
          $list.toggleClass(options.loadingClass, currentlyLoading=false)
          $loadedList = $(data).find(options.listSelector)
          if $loadedList.length
            options.success $loadedList
            $pagination.replaceWith $loadedList.children()

$.infinitePager = (options) ->
  $(document).infinitePager(options)

$.infinitePager.defaults =
  bottomOffset:   200
  listSelector:   '[rel=paginates]'
  pagerSelector:  '.pagination'
  linkSelector:   'a[rel=next]'
  loadingClass:   'loading'
  success:        ($context) ->
