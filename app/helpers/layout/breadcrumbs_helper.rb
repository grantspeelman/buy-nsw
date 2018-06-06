module Layout::BreadcrumbsHelper

  def render_breadcrumbs(*links)
    links.flatten!(1)
    render(partial: 'shared/breadcrumbs', locals: { links: links })
  end

end
